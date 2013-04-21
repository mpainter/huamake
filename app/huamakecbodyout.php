<html><head></head><body>
<?php
require_once( '../app/huamakecommentsxml.php' );
require_once( '../app/huamakedbinfo.php' );
require_once( '../app/huamakeutil.php' );
/* 
This script is the URL target for requests for the contents of lengthy messages.
Given the current caching algorithm, it is unlikely to be invoked.
	id- the database ID of the message who's content is being requested.
*/


$hmkdbinfo = new huamakedbinfo();
$hmkxml = new huamakeCommentsXML( $hmkdbinfo->getAttr( "pdbname" ) );
$myid = getUrlQStringValue( "id", "0" );
echo $hmkxml->cbodyout( $myid );
?>
</body></html>