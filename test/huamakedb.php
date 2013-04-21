<?php
require_once( '../simpletest/unit_tester.php' );
require_once( '../simpletest/reporter.php' );
require_once( '../app/huamakecommentsxml.php' );
require_once( '../app/huamakerecvdata.php' );
//require_once( '../app/huamakedb.php' );
require_once( '../app/huamakedbinfo.php' );

// recvdata inputs: parent, username, email, captcha, secret, subject, usermessage

class TestCaseOfhuamakedb extends UnitTestCase {
/*
This script is used for regression testing.  It can be run a few times to populate a test database with some data.
It should not be used against a production database, because it will fill the database with junk messages.
*/
	private $conn;
	private $err;
	private $db;
	private $result;
	private $comment;
	private $cresponse;
	private $messageids;
	private $userids;
	private $hmkxml;
	private $hmkrcv;
	private $i;
	private $dbinfo;

	function __construct() {
		$this->dbinfo = new huamakedbinfo();
		$this->db = $this->dbinfo->getAttr( "dbname" );
		$this->comment = "It was a dark and stormy night.";
		$this->cresponse = "And, so?";
		$messageids = array();
		$userids = array();
	}

	function setUp() {
		$this->conn = new huamakedb( $this->db, $this->dbinfo->getAttr( "dbuser" ) , $this->dbinfo->getAttr( "dbpasswd" ) );
		$this->err = $this->conn->isok();
		$this->assertTrue( !$this->err );

	}
	function testhuamakedbInsert() {
		echo "inserttest.";
		$this->err = $this->conn->adduser( "mpainter@aol.com", "bek3000", "Mark" );
		$this->assertTrue( !$this->err );
		if( $this->err ) $this->fail( $this->err );
		$this->err = $this->conn->addcomment( "x@y", 0, $this->comment );
		$this->assertTrue( !$this->err );
		if( $this->err ) $this->fail( $this->err );
	}
	function testhuamakedbGetComments() {

		echo "gettest.";
		//sleep( 5 );
		$this->result = $this->conn->getcomments( 0, 0, 10 );
		if( !$this->result ) {
			echo mysql_error();
		}
		$row = mysql_fetch_assoc($this->result);
		$this->assertTrue( $row );
		$this->i = 0;
		while( $row ) {
			echo "id: " . $row['id'] . "\n";
			$this->messageids[ $this->i ] = $row['id'];
			echo "userid: " . $row['userid'] . "\n";
			$this->userids[ $this->i++ ] = $row['userid'];
			echo "body: " . $row['body'] . "\n";
			$this->assertEqual( $row['body'], $this->comment );
			$row = mysql_fetch_assoc($this->result);
		}
	}
	function testhuamakeCommentsXML () {
		$this->hmkxml = new huamakeCommentsXML( $this->db );
		$hmkstr = $this->hmkxml->commentstoStr( 0, 0, 10 );
		echo urlencode($hmkstr);
		$this->assertWantedPattern( "/".$this->comment."/", $hmkstr );
	}
	function testhuamakeAddResponses( ) {
		foreach( $this->messageids as $mid ) {
			foreach( $this->userids as $uid ) {
				$this->err = $this->conn->addcomment( "x@y", $mid, $this->cresponse );
				$this->assertTrue( !$this->err );
			}
		}
	}
	function testhuamakeResponsesXML ( ) {
		foreach( $this->messageids as $mid ) {
			$hmkstr = $this->hmkxml->commentstoStr( $mid, 0, 10 );
			echo urlencode($hmkstr);
			$this->assertWantedPattern( "/".$this->cresponse."/", $hmkstr );
		}
		
	}
	function testhuamakeaddcomment2 ( ) {
		$testsubject = "buzz cuts";
		$testcomment = "make ears protrude.";
		$this->result = $this->conn->addcomment2( 1, 3, $testsubject, $testcomment, 0 );
		$this->err = 0;
		echo $this->result;
		if( !$this->result ) {
			$this->err = mysql_error();
			echo $this->err;
			//$this->fail( $this->err );
		}
		$this->assertTrue( !$this->err );
	}
	function testhuamakerecvcommentdata2 () {
// recvdata inputs: parent, username, email, captcha, secret, subject, usermessage
		$captchas = $this->conn->getcaptchaarray( 0 );
		echo $captchas;
		$this->hmkrcv = new huamakerecvdata( $this->db );
		$test_assoc[ 'parent' ] = 1;
		$test_assoc[ 'username' ] = "oldcrust";
		$test_assoc[ 'email' ] = "abc@xyz";
		$test_assoc[ 'captcha' ] = $this->conn->getcaptchafromid( $test_assoc[ 'parent' ], $captchas );
		$test_assoc[ 'secret' ] = "grandmothersnail";
		$test_assoc[ 'subject' ] = "frogs in a well";
		$test_assoc[ 'usermessage' ] = "You are breathing your own exhaust.";
		$this->result = $this->hmkrcv->recvcommentdata2( $test_assoc );
		echo $this->result;
		$this->assertWantedPattern( "/ok/", $this->result );
		
	}
	function testhuamakegetuserID ( ) {
		$testname = "Mark";
		$testemail = "mpainter@aol.com";
		$testsecret = "secret";
		$row = $this->conn->getuserID( $testname, $testemail, $testsecret );
		$this->assertEqual( 1, $row[ 'id' ] );
	}

}


$test = new TestCaseOfhuamakedb();

$test->run( new HtmlReporter() );

?>
