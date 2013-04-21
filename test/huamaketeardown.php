<?php
require_once( '../simpletest/unit_tester.php' );
require_once( '../simpletest/reporter.php' );
require_once( '../app/huamakedb.php' );
require_once( '../app/huamakedbinfo.php' );

class TestCaseOfhuamakedb extends UnitTestCase {
/*
This script is used to destroy a test database with the intention of creating a fresh start for regression testing.
*/
	private $conn;
	private $err;
	private $db;
	private $result;
	private $comment;
	private $dbinfo;

	function __construct() {
		$this->dbinfo = new huamakedbinfo();
		$this->db = $this->dbinfo->getAttr( "dbname" );
		$this->comment = "It was a dark and stormy night.";
	}

	function setUp() {
		$this->conn = new huamakedb( $this->db, $this->dbinfo->getAttr( "dbuser" ) , $this->dbinfo->getAttr( "dbpasswd" ) );
		$this->err = $this->conn->isok();
		$this->assertTrue( !$this->err );

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
		while( $row ) {
			echo "id: " . $row['id'] . "\n";
			echo "userid: " . $row['userid'] . "\n";
			echo "body: " . $row['body'] . "\n";
			$this->assertEqual( $row['body'], $this->comment );
			$row = mysql_fetch_assoc($this->result);
		}
	}
	function tearDown() {
		$this->conn->destroydb( $this->db );
	}
}


$test = new TestCaseOfhuamakedb();

$test->run( new HtmlReporter() );

?>
