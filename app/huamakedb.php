<?php
require_once( "../app/huamakedbinfo.php" );

class huamakedb {
/*
All SQL code for implementing threaded discussions is contained in this class
*/
	private $conn;  // the database connection
	private $err;   // error strings, when there are any
	private $dbinfo; // database parameters

/* Purpose: establish connection to database.
	$db - database name
	$dbuser - database user name
	$dbpass - database user's password

Method: Use mysql_connect.
*/
	function __construct( $db, $dbuser, $dbpass ) {
		$this->dbinfo = new huamakedbinfo();
		$this->conn = mysql_connect($this->dbinfo->getAttr( "dbhost" ),$dbuser, $dbpass );
		$this->err = mysql_error( $this->conn );
		@mysql_query( "USE " . $db, $this->conn );
	}
/* Purpose: check error status of last operation.

Method: return member variable.
*/
	function isok() {
		return( $this->err );
	}
/* Purpose: create database schema.  This is used for regression testing and initial setup of a new database.
	$db - name of the database to setup

Method: Use mysql_query to create database and tables.
*/

	function setup( $db ) {
		mysql_query( "CREATE DATABASE " . $db, $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			return $this->err;
		}
		mysql_query( "USE " . $db, $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			return $this->err;
		}
		mysql_query( "CREATE TABLE kehu( id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, signedupwhen TIMESTAMP, email VARCHAR(255), name VARCHAR( 255 ) UNIQUE, INDEX (name), password VARCHAR( 255 ), trusted INT DEFAULT 0 ) type=InnoDB;", $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo mysql_error( $this->conn );
			return $this->err;
		}
		mysql_query( "CREATE TABLE comments( id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, parent INT, enteredwhen TIMESTAMP, userid INT, FOREIGN KEY (userid) REFERENCES kehu (id), body TEXT, approved INT DEFAULT 0, subject VARCHAR(255) DEFAULT \"\" ) type=InnoDB;", $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo mysql_error( $this->conn );
			return( $this->err );
		}
		mysql_query( "CREATE TABLE notes( id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, messageid INT, FOREIGN KEY (messageid) REFERENCES comments (id), topic VARCHAR(255) ) type=InnoDB;", $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo mysql_error( $this->conn );
			return( $this->err );
		}
		mysql_query( "CREATE TABLE captcha ( id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, question VARCHAR( 255 ), answer VARCHAR(255) ) type=InnoDB;", $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo mysql_error( $this->conn );
			return( $this->err );
		}

		mysql_query( "START TRANSACTION;", $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			return( $this->err );
		}
		return $this->err;
	}
/* Purpose: re-establish connection to database.  This function was mostly an unsuccessful attempt to work around a problem where records inserted from the same PHP page that setup the database are not visible in queries from that page. (They are visible in subsequent pages, and data inserted from subsequent pages is visible in queries from those same pages
	$db - database name
	$dbuser - database user name
	$dbpass - database user's password

Method: First, close the current connection, then use mysql_connect to establish a new connection.
*/
	function open( $db, $dbuser, $dbpass ) {
		mysql_query( "COMMIT" );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo $this->err;
			return( $this->err );
		}
		return $this->err;
		if( $this->conn ) {
			$this->close();
		}
		$this->conn = mysql_connect($this->dbinfo->getAttr( "dbhost" ),$dbuser, $dbpass );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo mysql_error( $this->conn );
			return $this->err;
		}
		mysql_query( "USE " . $db, $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo mysql_error( $this->conn );
			return $this->err;
		}
	}
/* Purpose: close connection to database.

Method: Use mysql_close.
*/
	function close() {
		mysql_close( $this->conn );
		$this->conn = 0;
	}
/* Purpose: add information about a user to the database.
	$email - the user's email
	$passwd - their secret string (not hashed at present)
	$name - user's screen name

Method: Use SQL INSERT.  At present, the "trusted" flag is set to true to support a policy where users will be considered trustworthy until they do something that is not.  Comments from users that are not trusted, will not be displayed.  $name must be unique, but that is enforced by a database constraint.
*/
	function adduser ( $email, $passwd, $name ) {
		// trust users until they do something untrustworthy
		$query = "INSERT INTO kehu ( email, name, password, trusted ) VALUES ( '" . $email . "', '" . $name . "', '" . $passwd . "', 1 )";
		mysql_query( $query );
		//echo $query;
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo $this->err;
			return( $this->err );
		}
		return 0;

	}
/* Purpose: an early version of the function for inserting a comment into the database.  It is still used in regression tests and might, in the future, be useful for testing changes to the comment insertion functionality without affecting "production" code.
	$email - user's email (not used)
	$parentid - message ID of message this comment is a response to, or 0, if this message is starting a top level discussion thread.
	$comment - text of the comment.

Method: Use SQL INSERT.
*/
	function addcomment ( $email, $parentid, $comment ) {
		$query = "INSERT INTO comments ( userid, parent, body ) VALUES ( " . "1" . ", " . $parentid . ", '" . $comment . "' )";
		mysql_query( $query  );
		//echo $query;
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo $this->err;
			return( $this->err );
		}
		//mysql_commit( $this->conn );
		return 0;
	}
/* Purpose: the "production" function for inserting a comment into the database.  
	$userid - the database ID of the user making the comment
	$parentid - message ID of message this comment is a response to, or 0, if this message is starting a top level discussion thread.
	$subject - text of the subject for the comment.
	$comment - text of the comment.
	$approved - 1 = the message is approved. 0 = the message is not approved.  At present, the policy is to automatically approve messages from "trusted" users.  Messages that are not "approved" will not be displayed.

Method: Use SQL INSERT.  $parentid, $subject and $comment are input data.  At this level it is assumed the strings have been rendered inert in regard to potential SQL injection.
*/
	function addcomment2( $userid, $parentid, $subject, $comment, $approved ) {
// recvdata inputs: parent, username, email, captcha, secret, subject, usermessage
		$query = "INSERT INTO comments ( userid, parent, subject, body, approved ) VALUES ( " . $userid . ", " . $parentid . ", '" . $subject . "', '" . $comment . "', " . $approved . " )";
		mysql_query( $query  );
		//echo $query;
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo $this->err;
			return( $this->err );
		}
		//mysql_commit( $this->conn );
		return 0;
	}
/* Purpose: insert a question and answer into the database.  Ideally, the question should make the answer obvious to humans, but not to programs.
	$question - a phrase that suggests an answer
	$answer - the correct answer to the question.

Method: Use SQL INSERT.
*/
	function addcaptcha ( $question, $answer ) {
		$query = 'INSERT INTO captcha ( question, answer ) VALUES ( "' . $question . '", "' .
			$answer . '" )';
		mysql_query( $query );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo $this->err;
			return( $this->err );
		}
		return 0;
	}
/* Purpose: generate some questions for distinguishing users from computers and add them to the database.

Method: generate multiplication tables using words in place of numbers.  I should replace this with standard captcha technology, but this technique may be sufficient for a site in the "long tail" of the Internet.
*/
	function gencaptchadata( ) {
		$digitwords = array( "zero", "one", "two", "three", "four", "five",
			"six", "seven", "eight", "nine", "ten" );
		$thedigits = array( "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" );
		for( $i = 1; $i < 11 ; $i++ ) {
			for( $j = 1; $j < 11 ; $j++ ) {
				$question = $i . " times " . $j . "equals ??";
				$question = str_replace( $thedigits, $digitwords, $question );
				$answer = $i * $j;
				$this->addcaptcha( $question, $answer );
			}
		}
	}
/* Purpose: return either an array of questions, or an array of answers, indexed by a numerical id.
	$myqora - 1 = values in the array are to be questions, 0 = values in the array are to be answers.

Method: Use SQL SELECT.
*/

	function getcaptchaarray( $myqora ) {
		$query = "select * from captcha;";
		$this->result = mysql_query( $query );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			echo $this->err;
			return( $this->err );
		}
		$row = mysql_fetch_assoc( $this->result );
		$rval = array();
		while ( $row ) {
			if( $myqora ) {
				$rval[ $row[ 'id' ] ] = $row[ 'question' ];
			} else {
				$rval[ $row[ 'id' ] ] = $row[ 'answer' ];
			}
			$row = mysql_fetch_assoc( $this->result );
		}
		return( $rval );
	}
/* Purpose: given a message id and and an array generated by "getcaptchaarray", return the question or answer that corresponds to that ID.
	$id - a message id
	$captchas - the array of questions or answers.

Method: In the future I could introduce more complexity to the computation to randomize the relationship between messages and questions and answers, but for now, the message id is just used as an index into the array.  Changes would require that the question not be included in the cached message description, be independently obtained by the client, and that there would be a new method for matching questions to requests.
*/

	function getcaptchafromid( $id, $captchas ) {
		//return( ( date( "m" ) * 31 + date( "j" ) + $id ) );
		$captchai = ( $id % sizeof( $captchas ) ) + 1;
		return ( $captchas[ $captchai ] );
	}
/* Purpose: get messages from the most recent IDS and scroll position within that the administrator view.
	$parent - database id of comment that initiated this conversation thread.
	$firstcom - ordinal of the most recent comment to display within this thread.
	$lastcom - ordinal of the least recent comment to display within this thread.

Method: Use a SQL select statement. The portions of the where clause regarding kehu.trusted and message.approved are the basic mechanism to filter out unwanted and inappropriate content.  Higher layers of software determine the policy for setting these flags. At present, the policy is to trust until the trust is violated.
*/
	function getcommentsAdmin ( $parent, $firstcom, $lastcom ) {
		$limit = $lastcom - $firstcom + 1;
		// only get messages from trusted users
		$query = "SELECT comments.id, comments.userid, comments.body, comments.subject, kehu.name, comments.enteredwhen FROM comments, kehu WHERE (comments.userid = kehu.id AND kehu.trusted=1 AND comments.approved=1) order by comments.enteredwhen  desc LIMIT " . $firstcom . "," . $limit . " ;";
		$this->result = mysql_query( $query  );
		//echo $query;
		return $this->result;
	}
/* Purpose: get messages from the specified conversation thread and scroll position within that thread.
	$parent - database id of comment that initiated this conversation thread.
	$firstcom - ordinal of the most recent comment to display within this thread.
	$lastcom - ordinal of the least recent comment to display within this thread.

Method: Use a SQL select statement. The portions of the where clause regarding kehu.trusted and message.approved are the basic mechanism to filter out unwanted and inappropriate content.  Higher layers of software determine the policy for setting these flags. At present, the policy is to trust until the trust is violated.
*/
	function getcomments ( $parent, $firstcom, $lastcom ) {
		$limit = $lastcom - $firstcom + 1;
		// only get messages from trusted users
		$query = "SELECT comments.id, comments.userid, comments.body, comments.subject, kehu.name, comments.enteredwhen FROM comments, kehu WHERE (comments.parent=" . $parent . " AND comments.userid = kehu.id AND kehu.trusted=1 AND comments.approved=1) order by comments.enteredwhen  desc LIMIT " . $firstcom . "," . $limit . " ;";
		$this->result = mysql_query( $query  );
		//echo $query;
		return $this->result;
	}
/* Purpose: given a message id return the contents of the database row that corresponds to the message ID.
	$myid - a message id

Method: Use a SQL query to get the row, return an associative array containing the row data indexed by column name.  At present, no filtering is done in regard to the message content, or trust worthiness of the user.  This should be ok, because of the constrained usage of the content; basically, just the body of a comment will be retrieved to cache.
*/
	function getcomment ( $myid ) {
		$query = "SELECT comments.id, comments.userid, comments.body, comments.subject, kehu.name, comments.enteredwhen FROM comments, kehu WHERE comments.id=" . $myid . " AND comments.userid = kehu.id ;";
		$this->result = mysql_query( $query  );
		//echo $query;
		return $this->result;
	}
/* Purpose: check if a user exists and if so, return database information about that user.  
	$name - screen name of the user
	$email - user's email (not used here).
	$secret - user's secret string (not used here).

Method: Use SQL SELECT.  $name is input data.  At this level it is assumed the strings have been rendered inert in regard to potential SQL injection.
*/
	function getuserID ( $name, $email, $secret ) {
		$query = 'SELECT * from kehu where name="' . $name . '";';
		$this->result = mysql_query( $query );
		$row = mysql_fetch_assoc($this->result);
		return( $row );

	}
/* Purpose: make data accessable on the Web server as a plain file (e.g. .txt, .htm, .xml).
	$cid - a unique file name for this data item, chosen by caller.
	$ctype - "list" for lists of mesages, "file" for the contents of lengthy messages, perhaps other types in the future.
	$cdata - data to write to the cache file.

Method: use input parameters and conventions to compose path name for data, and dump $cdata to a file with that name.
*/
	function puttocache( $cid, $ctype, $cdata ) {
		$this->result = fopen( "../cache/" . $ctype . "/" . $cid, "w" );
		if( $this->result ) {
			fwrite( $this->result, $cdata );
			fclose( $this->result );
		}
	}
/* Purpose: retrieve data placed into the filesystem by "puttocache" for use within a PHP script.
	$cid - a unique file name for this data item, chosen by caller.
	$ctype - "list" for lists of mesages, "file" for the contents of lengthy messages, perhaps other types in the future.

Method: use input parameters and conventions to compose path name for data, and retrieve the data from the resulting named file, and return it to the caller as a string.
*/


	function getfromcache( $cid, $ctype ) {
		$cfilename = "../cache/" . $ctype . "/" . $cid;
		$this->result = 0;
		if( file_exists( $cfilename ) ) {
			$this->result = fopen( $cfilename , "r" );
		}
		if( $this->result ) {
			$rval = fread( $this->result, filesize( $cfilename ) );
			fclose( $this->result );
		} else {
			return( 0 );
		}
		return( $rval );
	}
/* Purpose: clean a cache, or portion of a cache.
	$cid - a unique file name for this data item, chosen by caller.
	$ctype - "list" for lists of mesages, "file" for the contents of lengthy messages, perhaps other types in the future.

Method: use input parameters and conventions to compose path name for data, which may include wildcars and remove all matching files.
*/	
	function rmfromcache( $cid, $ctype ) {
		$cfilename = "../cache/" . $ctype . "/" . $cid;
		$cfilelist = glob( $cfilename );
		foreach (  $cfilelist as $cfname  ) {
			$this->result |= unlink( $cfname );
		}
		return( $this->result );
	}
/* Purpose: flag users as trusted, or untrusted.  Messages from untrusted users will not be displayed.  This is an administrative function.
	$uid - database ID of user.
	$trust - 1 = trusted, 0 = untrusted.

Method: use SQL UPDATE.
*/
	function setusertrust( $uid, $trust ) {
		$query = "UPDATE kehu SET trusted=". $trust . " WHERE id=" . $uid . ";";
		//echo $query;
		mysql_query( $query );
		$this->result = mysql_error( $this->conn );
		return( $this->result );
	}
/* Purpose: flag messages as approved, or unapproved.  Messages that are not approved will not be displayed.  This is an administrative function.
	$mid - database ID of message.
	$trust - 1 = approved, 0 = unapproved.

Method: use SQL UPDATE.
*/

	function setmessagetrust( $mid, $trust ) {
		$query = "UPDATE comments SET approved=". $trust . " WHERE id=" . $mid . ";";
		//echo $query;
		mysql_query( $query );
		$this->result = mysql_error( $this->conn );
		return( $this->result );
	}
/* Purpose: remove database and schema.  This is used to establish a clean baseline for regression tests, and obviously should not be applied to the production database.
	$db - name of database to drop.

Method: use SQL DROP DATABASE.
*/
	function destroydb( $db ) {
		@mysql_query( "DROP DATABASE " . $db, $this->conn );
		$this->err = mysql_error( $this->conn );
		if( $this->err ) {
			return( $this->err );
		}
		return $this->err;

	}

}
?>