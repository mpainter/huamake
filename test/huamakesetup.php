<?php
require_once( '../simpletest/unit_tester.php' );
require_once( '../simpletest/reporter.php' );
require_once( '../app/huamakedb.php' );
require_once( '../app/huamakedbinfo.php' );

class TestCaseOfhuamakedb extends UnitTestCase {
/*
This script serves two purposes.  One is to initialize a fresh database for regression testing. The other is to initialize a database for a new production environment.

testhuamakecaptcha will fail.  For unknown reasons, select statements to retrieve data that has been inserted into the database will fail within this script.  It seems to have something to do with the fact that the database was created within this script.
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
		$this->conn = new huamakedb( $this->db, $this->dbinfo->getAttr( "dbuser" ) , 
			$this->dbinfo->getAttr( "dbpasswd" ) );
		$this->err = $this->conn->isok();
		$this->assertTrue( !$this->err );
		$this->err = $this->conn->setup( $this->db );
		$this->assertTrue( !$this->err );

	}
	function testhuamakedbOpen () {
		echo "opentest.";
		$this->err = $this->conn->open( $this->db, $this->dbinfo->getAttr( "dbuser" ) , $this->dbinfo->getAttr( "dbpasswd" ) );
		$this->assertTrue( !$this->err );
	}
	function testhuamakecaptcha() {
		$this->conn->gencaptchadata( );
		$captchas = $this->conn->getcaptchaarray( 0 );
		echo $captchas;
		$this->assertEqual( $captchas[ 10 ], "10" );
	}

}


$test = new TestCaseOfhuamakedb();

$test->run( new HtmlReporter() );

?>
