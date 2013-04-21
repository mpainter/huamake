<?php
require_once( '../geomatch/geomatchdb.php' );
require_once( '../geomatch/geomatchdbinfo.php' );

class huamakerecvdata {
/* 
ALL server side application logic for processing data posted by the user to geomatch is contained in this class.

Other scripts will provide target URLs, but simply perform syntactic data validation and URLencode posted data, before calling methods from this class and returning their results.
The lower level class, geomatchdb will be used to actually perform database operations.
*/
	private $db;
	private $conn;
	private $result;
	private $outstr;
	private $dbinfo;

	function __construct( $db ) {
		$this->db = $db;
		$this->dbinfo = new huamakedbinfo();
		$this->conn = new huamakedb( $this->db, $this->dbinfo->getAttr( "dbuser" ) , 
			$this->dbinfo->getAttr( "dbpasswd" ) );
	}
/* Purpose: This is a prototype of the function for creating a new message.  It is currently only used within regression tests and might be useful later for developement of new features without disturbing production code.
	$parid - database ID of message being responded to, or 0, if this is a top level thread.
	$username - screen name of user.
	$usermessage - content of message

Method: call lower level function to perform database manipulation.
*/
	function recvcommentdata( $parid, $username, $usermessage ) {
		$this->result = $this->conn->addcomment ( "x@y", $parid, $usermessage );
		if( !$this->result ) {
			$this->outstr .= "<error>" . mysql_error() . "</error>";
			return $this->outstr;
		}
		return "<ok>ok</ok>";
	}
/* Purpose: This is the production version of the function for creating a new message.  
	$sent_assoc - an associative array assembled by the caller that contains the parameter values of all data posted by the user, indexed by the parameter name, and URL encoded.

Method: check "captcha" and user identity before proceeding.  If user is a new user, create a new user record for them.  If all is ok, proceed with calling lower level function to create a new message within the database.  Return an error string for processing by the client, if anything went wrong.
*/
	function recvcommentdata2( $sent_assoc ) {
// recvdata inputs: parent, username, email, captcha, secret, subject, usermessage
		$this->result = "<huamakeresponse>";
		// check human-ness
		$captchas = $this->conn->getcaptchaarray( 0 );
		$captchai = ($sent_assoc[ 'parent' ] % sizeof( $captchas ) ) + 1;
		if( $sent_assoc[ 'captcha' ] != $captchas[ $captchai ] ) { // needs to be more sophisticated
			$this->result .= "<error>captcha</error></huamakeresponse>";
			return ($this->result);
		}
		// check if user exists
		$userrow = $this->conn->getuserID( $sent_assoc[ 'username' ], 
			$sent_assoc[ 'email' ], 
			$sent_assoc[ 'secret' ] );  //secret should probably be hashed
		if( !is_array( $userrow ) ) {
			// create a new user
			$this->conn->adduser( $sent_assoc[ 'email' ], 
				$sent_assoc[ 'secret' ],
				$sent_assoc[ 'username' ] );
			$userrow = $this->conn->getuserID( $sent_assoc[ 'username' ], $sent_assoc[ 'email' ], $sent_assoc[ 'secret' ] );  //secret should probably be hashed

		}
		//echo gettype( $userrow );
		if( is_array( $userrow ) ) {
			if( $userrow[ 'password' ] == $sent_assoc[ 'secret' ] ) {
				$approved = $userrow[ 'trusted' ];
				$row = $this->conn->addcomment2 ( $userrow[ 'id' ], 
					$sent_assoc[ 'parent' ], 
					$sent_assoc[ 'subject' ], 
					$sent_assoc[ 'usermessage' ], $approved );
				$this->err = mysql_error();
				if( $this->err ) {
					$this->result .= "<error><system>" . mysql_error() . "</system></error>";
				} else {
					$this->conn->rmfromcache( $sent_assoc[ 'parent' ] . "_*_*.xml",
						"list" );
					$this->conn->rmfromcache( "*.xml", "adminlist" );
					$this->result .= "<ok>ok</ok>";
				}
			} else {
				$this->result .= "<error><nouser>Secret doesn't match.</nouser></error>";
			}
		} else {

			$this->result .= "<error><nouser>" . mysql_error() . "</nouser></error>";
		}
		$this->result .= "</huamakeresponse>";
		return $this->result;
	}
/* Purpose: This is an administrative function for surpressing unwanted or inappropriate messages.  Either a single message, or all messages from a given user may be surpressed.
  
	$sent_assoc - an associative array assembled by the caller that contains the parameter values of all data posted by the user, indexed by the parameter name, and URL encoded.

Method: basically, only the user "Mark" may perform this method. Check "captcha" and user identity before proceeding.  If all is ok, proceed with calling lower level function to update the trust status of a message or user.  Return an error string for processing by the client, if anything went wrong.
*/
	function recvusertotrust( $sent_assoc ) {
// recvusertotrust inputs: username, email, captcha, secret, usertotrust
		$this->result = "<p>";
		// check human-ness
		if( $sent_assoc[ 'captcha' ] != "halflife" ) { // needs to be more sophisticated
			$this->result .= "Captcha incorrect";
			return ($this->result);
		}
		// check if user exists
		$userrow = $this->conn->getuserID( $sent_assoc[ 'username' ], 
			$sent_assoc[ 'email' ], 
			$sent_assoc[ 'secret' ] );  //secret should probably be hashed
		if( !is_array( $userrow ) || $sent_assoc[ 'username' ] != "Mark" ) {
			// not administrator
			$this->result .= "User name incorrect";
			return ($this->result);

		} else if ( $userrow[ 'password' ] != $sent_assoc[ 'secret' ] ) {
			// not administrator
			$this->result .= "User name incorrect";
			return ($this->result);
		}
		if( $sent_assoc[ 'usertotrust' ] != "" ) {
			$targetrow = $this->conn->getuserID( $sent_assoc[ 'usertotrust' ], 
				"", 
				"" );
			if( !is_array( $targetrow )  ) {
				// bad target user name
				$this->result .= "User to trust name incorrect";
				return ($this->result);
			}
			$row = $this->conn->setusertrust ( $targetrow[ 'id' ], $sent_assoc[ 'trust' ] ); 
			if( $row ) {
				$this->result .= "<error><system>" . mysql_error() . "</system></error>";
			} else {
				$this->conn->rmfromcache( "*.xml", "list" );
				$this->result .= "<ok>ok</ok>";
			}
		} else if( $sent_assoc[ 'messagetotrust' ] != "" ) {
			$row = $this->conn->setmessagetrust ( $sent_assoc[ 'messagetotrust' ], $sent_assoc[ 'trust' ] ); 
			if( $row ) {
				$this->result .= "<error><system>" . mysql_error() . "</system></error>";
			} else {
				$this->conn->rmfromcache("*.xml", "list" );
				$this->result .= "<ok>ok</ok>";
			}
		} else {
			$this->result .= "<error><nouser>No operation to perform.</nouser></error>";
		}
		$this->result .= "</p>";
		return $this->result;
	}
}
?>