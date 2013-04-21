<?php
class geomatchdbinfo {
/*
This class contains all parameters related to logging into the geomatch database.

	"dbname" is the database used by regression tests.

	
*/
	private $info;
	
	function __construct () {
		$this->info[ 'dbname' ] = "geomatch";
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