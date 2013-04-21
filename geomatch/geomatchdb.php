<?php
require_once( "../geomatch/geomatchdbinfo.php" );

class geomatchdb {
/*
All SQL code for implementing the geomatch application is contained in this class
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
		$this->dbinfo = new geomatchdbinfo();
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

Method: Use SQL INSERT.
*/
	function adduser ( $name ) {
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
/* Purpose: insert a user's visit to a place into the database.
	$name - user's screen name

Method: Use SQL INSERT.
*/
	function addvisit ( $email, $parentid, $comment ) {
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
/* Purpose: return an array of point a user has visited within a specified interval

Method: Use SQL SELECT.
*/

	function getvisitpath( $myqora ) {
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


}
?>