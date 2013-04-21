<?php
require_once( '../geomatch/geomatchrecvdata.php' );
require_once( '../geomatch/geomatchdbinfo.php' );
require_once( '../geomatch/geomatchutil.php' );

/*
This script is the URL target for requests to create a new message within a discussion thread.
	parent - the database ID of the message this thread is responding to, or 0 if the message is a new top-level discusssion topic.
	 username - the screen name of the user
	 email - the user's email address
	 captcha - the answer to the captcha question
	 secret - a string used to authenticate the user's screen name
	 subject - the subject of the message
	 usermessage - the content of the message
	 showall - administrator view

*/


$hmkdbinfo = new huamakedbinfo();
$hmkxml = new huamakerecvdata( $hmkdbinfo->getAttr( "pdbname" ) );
$input_assoc[ 'parent' ] = getUrlPStringValue( "parent", "0" );
$input_assoc[ 'username' ] = getUrlPStringValue( "username", "" );
$input_assoc[ 'email' ] = getUrlPStringValue( "email", "" );
$input_assoc[ 'captcha' ] = getUrlPStringValue( "captcha", "" );
$input_assoc[ 'secret' ] = getUrlPStringValue( "secret", "" );
$input_assoc[ 'subject' ] = getUrlPStringValue( "subject", "" );
$input_assoc[ 'usermessage' ] = getUrlPStringValue( "usermessage", "" );
$input_assoc[ 'showall' ] = getUrlPStringValue( "showall", "" );
echo $hmkxml->recvcommentdata2( $input_assoc );
?>