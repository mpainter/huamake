<?php
require_once( '../app/huamakedb.php' );
require_once( '../app/huamakedbinfo.php' );

class huamakeCommentsXML {
/* 
ALL server side application logic for processing read access to threaded discussions is contained in this class.

Other scripts will provide target URLs, but simply perform syntactic data validation of parameters specifying data to be returned and format the final document to output. The lower level class, huamakedb will be used to actually perform database operations.
*/
	private $db;
	private $conn;
	private $result;
	private $outstr;
	private $dbinfo;
	private $showall;

	function __construct( $db ) {
		$this->db = $db;
		$this->dbinfo = new huamakedbinfo();
		$this->conn = new huamakedb( $this->db, $this->dbinfo->getAttr( "dbuser" ) , $this->dbinfo->getAttr( "dbpasswd" ) );
	}
/* Purpose: Return text that originated from user input in a format that is inert with respect to potential javascript and html injection.
	$mytext - the text to be rendered "safe".

Method: Undo the URL encoding of user contributed text, and replace tag delimiters with escape sequences used to display them as text.
*/
	function safetext ( $mytext ) {
		$mytext = urldecode( $mytext );
		$inchars = array( "<", ">" );
		$outchars = array( "&lt;", "&gt;" );
		$mytext = str_replace( $inchars, $outchars, $mytext );
		return( $mytext );
	}
/* Purpose: Return text associated with a lengthy message.
	$myid - database ID of message that contains desired text.

Method: First check cache.  If data is not in cache, retrieve from database and place into cache.
*/
	function cbodyout( $myid ) {
		$this->outstr = $this->conn->getfromcache( $myid . ".txt" , "file" );
		if( $this->outstr ) {
			return( $this->outstr );
		}
		$this->result = $this->conn->getcomment( $myid );
		if( !$this->result ) {
			$this->outstr .= "<error>" . mysql_error() . "</error>";
			return $this->outstr;
		}
		$row = mysql_fetch_assoc($this->result);
		$this->outstr = $this->safetext( $row[ 'body' ] );
		$this->conn->puttocache( $myid . ".txt", "file", $this->outstr );
		return( $this->outstr );
	}
/* Purpose: wrapper function for commentstoStr to allow for additional inputs.
	$pid - database ID of message this discussion thread is a response to, or 0 for a list of top level messages.
	$firstcom - ordinal within thread of the first comment to be returned.
	$lastcom - ordinal within thread of the last comment to be returned.
	$showall - administrator flag

Method: Convert array values to scalars and call original function.  New variables become class members.
*/
	function commentstoStrAssoc( $input_assoc ) {
		$pid = $input_assoc[ 'pid' ];
		$firstcom = $input_assoc[ 'firstcom' ];
		$lastcom = $input_assoc[ 'lastcom' ];
		$this->showall = $input_assoc[ 'showall' ];
		return( $this->commentstoStr( $pid, $firstcom, $lastcom ) );
	}

/* Purpose: format a portion of a discussion thread as an XML document for interpretation by client side javascript.
	$pid - database ID of message this discussion thread is a response to, or 0 for a list of top level messages.
	$firstcom - ordinal within thread of the first comment to be returned.
	$lastcom - ordinal within thread of the last comment to be returned.

Method: First, check cache for the result of a request with identical parameters.  If the desired database is not in cache retrieve it from the database and place it into cache. (New messages to this discussion thread will clean the cache for all entries related to $pid.)
*/
	
	function commentstoStr( $pid, $firstcom, $lastcom ) {
		$cachedir = ( $this->showall == "abracadabra" )? "adminlist" : "list";
		$cacheid = $pid . "_" . $firstcom . "_" . $lastcom . ".xml";
		$this->outstr = $this->conn->getfromcache( $cacheid , $cachedir );
		if( $this->outstr ) {
			return( $this->outstr );
		}
		$this->outstr = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
		$captchas = $this->conn->getcaptchaarray( 1 );  //get captcha questions
		if( $this->showall == "abracadabra" ) {
			$this->result = $this->conn->getcommentsAdmin( $pid, $firstcom, $lastcom );
		} else {
			$this->result = $this->conn->getcomments( $pid, $firstcom, $lastcom );
		}
		if( !$this->result ) {
			$this->outstr .= "<error>" . mysql_error() . "</error>";
			return $this->outstr;
		}
		$row = mysql_fetch_assoc($this->result);
		$this->outstr .= "<commentblock>\n";
		$this->outstr .= "<meta http-equiv=\"cache-control\" content=\"no-cache\"/>";
		while( $row ) {
			$this->outstr .= "<comment>";
			$this->outstr .= "<id>" . $row['id'] . "</id>";
			$this->outstr .= "<userid>" . $row['userid'] . "</userid>";
			$this->outstr .= "<username>" . $row['name'] . "</username>";
			$subj = $this->safetext( $row[ 'subject' ] );
			$this->outstr .= "<subject>" . $subj . "</subject>";
			$this->outstr .= "<enteredwhen>" . $row['enteredwhen'] . "</enteredwhen>";
			$cbody = $row[ 'body' ];
			$cbody = $this->safetext( $cbody );
			if( strlen( $cbody ) > 160 ) {
				// might as well cache the data here, it is already out of the DB
				$cbody = "<html><head></head><body>" . $cbody . "</body></html>";
				$this->conn->puttocache( $row[ 'id' ] . ".htm", "file",
					$cbody );
				$cbody = "-long-";  //signal client side
			} else {
			}

			$this->outstr .= "<commentbody>" . $cbody . "</commentbody>";
			$captchai = ($row[ 'id' ] % sizeof( $captchas )) + 1;
			$this->outstr .= "<captcha>" . $captchas[ $captchai ] . "</captcha>";
			$row = mysql_fetch_assoc($this->result);
			$this->outstr .= "</comment>\n";
		}
		$captchai = ($pid % sizeof( $captchas )) + 1;
		$this->outstr .= "<pcaptcha>" . $captchas[ $captchai ] . "</pcaptcha>";
		$this->outstr .= "</commentblock>\n";
		$this->conn->puttocache( $cacheid, $cachedir, $this->outstr );
		return $this->outstr;
	}
}
?>