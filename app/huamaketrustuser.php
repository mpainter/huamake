<html><head></head><body>
<?php
require_once( '../app/huamakerecvdata.php' );
require_once( '../app/huamakedbinfo.php' );
require_once( '../app/huamakeutil.php' );

/*
This script is the URL target for administrative requests to change the trust status of a user, or the approval status of an individual message.
	username - the screen name of the administrator
	email - the email of the administrator
	captcha - an answer to a captcha question
	secret - a string used to authenticate the administrator
	trust - 1 = trust target user or approve target message, 0 - untrust target user or unapprove target message.
	usertotrust - screenname of target user, if set messageto trust will be ignored.
	messagetotrust - database ID of the target message.  This can be obtained by inspecting the DOM elements of the message list.
*/

$hmkdbinfo = new huamakedbinfo();
$hmkxml = new huamakerecvdata( $hmkdbinfo->getAttr( "pdbname" ) );
$input_assoc[ 'username' ] = getUrlPStringValue( "username", "" );
$input_assoc[ 'email' ] = getUrlPStringValue( "email", "" );
$input_assoc[ 'captcha' ] = getUrlPStringValue( "captcha", "" );
$input_assoc[ 'secret' ] = getUrlPStringValue( "secret", "" );
$input_assoc[ 'trust' ] = getUrlPStringValue( "trust", "0" );
$input_assoc[ 'usertotrust' ] = getUrlPStringValue( "usertotrust", "" );
$input_assoc[ 'messagetotrust' ] = getUrlPStringValue( "messagetotrust", "" );
echo $hmkxml->recvusertotrust( $input_assoc );
?>
</body></html>