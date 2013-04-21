<?php
header('Content-type: text/xml');
require_once( '../app/huamakecommentsxml.php' );
require_once( '../app/huamakedbinfo.php' );
require_once( '../app/huamakeutil.php' );
/*
This script is the URL target for requests for lists of messages within a given discussion thread.

	parent - the query string variable containing the database id of the message the thread is a reponse to.
	cstart - the query string variable containing the ordinal of the first message requested within the thread.
	cend - the query string variable containing the ordinal of the last message requested within the thread.
	showall - administator flag
*/

$hmkdbinfo = new huamakedbinfo();
$hmkxml = new huamakeCommentsXML( $hmkdbinfo->getAttr( "pdbname" ) );
$input_assoc[ 'pid' ] = getUrlQStringValue( "parent", "0" );
$input_assoc[ 'firstcom' ] = getUrlQStringValue( "cstart", "1" ) - 1;
$input_assoc[ 'lastcom' ] = getUrlQStringValue( "cend", "10" ) - 1;
$input_assoc[ 'showall' ] = getUrlQStringValue( "showall", "no" );
echo $hmkxml->commentstoStrAssoc( $input_assoc );
?>