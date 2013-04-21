<?php
require_once( '../app/huamakecommentsxml.php' );
require_once( '../app/huamakedbinfo.php' );
require_once( '../app/huamakeutil.php' );
/*
This script is a placeholder for a more complicated Captcha mechanism that does not yet exist.
*/

$hmkdbinfo = new huamakedbinfo();
$hmkxml = new huamakeCommentsXML( $hmkdbinfo->getAttr( "pdbname" ) );
$parid = getUrlQStringValue( "parent", "0" );
$cstart = getUrlQStringValue( "cstart", "1" ) - 1;
$cend = getUrlQStringValue( "cend", "10" ) - 1;
//range should come from query string, but hard-coded, for now
echo $hmkxml->commentstoStr( $parid, $cstart, $cend );
//echo $parid . ":" . $cstart . ":" . $cend;
?>