<?php
require_once( '../simpletest/unit_tester.php' );
require_once( '../simpletest/reporter.php' );
require_once( '../app/huamakedb.php' );

class TestCaseOfhuamakedb extends UnitTestCase {
	private $conn;
	private $err;
	private $db;
	private $result;
	private $comment;

	function __construct() {
		$this->db = "testdb";
		$this->comment = "It was a dark and stormy night.";
	}

	function setUp() {
		$this->conn = new huamakedb( "root", "bek2000" );
		$this->err = $this->conn->isok();
		$this->assertTrue( !$this->err );
		$this->err = $this->conn->setup( $this->db );
		$this->assertTrue( !$this->err );

	}
	function testhuamakedbInsert() {
		echo "inserttest.";
		$this->err = $this->conn->adduser( "x@y", "secret", "minime" );
		$this->assertTrue( !$this->err );
		if( $this->err ) $this->fail( $this->err );
		$this->err = $this->conn->addcomment( "x@y", 0, $this->comment );
		$this->assertTrue( !$this->err );
		if( $this->err ) $this->fail( $this->err );
	}
	function testhuamakedbOpen () {
		echo "opentest.";
		$this->err = $this->conn->open( $this->db, "root", "bek2000" );
		$this->assertTrue( !$this->err );
	}
	function testhuamakedbGetComments() {
		echo "gettest.";
		//sleep( 5 );
		$this->result = $this->conn->getcomments( 0, 10 );
		if( !$this->result ) {
			echo msql_error();
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
