<?php
class huamakedbinfo {
/*
This class contains all parameters related to running the threaded discussion application on a given
platform.

	"dbname" is the database used by regression tests.
	"pdbname" is the database used in production.

If regression tests are to be conducted on a platform that includes a production database, these two should not be the same, except for the initial setup of the production database.
	
*/
	private $info;
	
	function __construct () {
		$this->info[ 'dbname' ] = "testdb";
		$this->info[ 'pdbname' ] = "testdb";
		$this->info[ 'dbuser' ] = "root";
		$this->info[ 'dbpasswd' ] = "bek2000";
		$this->info[ 'dbhost' ] = "127.0.0.1";
	}
	function getAttr( $key ) {
		$rval = $this->info[ $key ];
		return( $rval );
	}
}
?>