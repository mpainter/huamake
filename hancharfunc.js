/* Copyright 2010 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included. */

var hanconvertinited = false;
var tradtosimp;
var simptotrad;

function inithanconvert()
{

	var textNode = null;
	var xmlhttp;


	if( !hanconvertinited ) {
 		if (window.XMLHttpRequest)
  		{
  			// code for IE7+, Firefox, Chrome, Opera, Safari
  			xmlhttp=new XMLHttpRequest();
  		}
		else if (window.ActiveXObject)
  		{
  			// code for IE6, IE5
  			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  		}
		else
  		{
  			alert("Your browser does not support XMLHTTP!");
  			return;
 		 }
 		xmlhttp.onreadystatechange=function()
    		{
     			if(xmlhttp.readyState==4)
        		{
				//reset theCharList, theCharIndex
          			txtResponse= xmlhttp.responseText;
				//alert( xmlhttp.status );
	  			if( xmlhttp.status == 200 ) {
					//ok, to proceed, parse javascript/json
					//alert( txtResponse.substr( 0, 100 ));

					// should parse as a consistancy check for security

					if( txtResponse.length > 100 ) {
						eval( txtResponse );
						hanconvertinited = true;
					}
					//alert( otherelements );
        			} else {
 					alert( "Character mapping data failed to load." );
         			}
       			}
    		}
   		theURL = "./hancharmaps.js";
   		xmlhttp.open("GET",theURL,true);
   		xmlhttp.send(null);
	}
}

function convertsimp( tstr )
{
	rstr = "";
	for( i = 0 ; i < tstr.length ; ++i ) {
		if( simptotrad[ tstr.charAt(i) ] != undefined ) {
			rstr += simptotrad[ tstr.charAt(i) ];
		} else {
			rstr += tstr.charAt(i);
		}
	}
	return( rstr );
}

function converttrad( tstr )
{
	rstr = "";
	for( i = 0 ; i < tstr.length ; ++i ) {
		if( tradtosimp[ tstr.charAt(i) ] != undefined ) {
			rstr += tradtosimp[ tstr.charAt(i) ];
		} else {
			rstr += tstr.charAt(i);
		}
	}
	return( rstr );
}

function converttree( mynode, tosimp )
{
	var i;

	if( mynode && mynode.childNodes.length > 0 ) {
		for( i = 0 ; i < mynode.childNodes.length ; ++i ) {
			converttree( mynode.childNodes[i], tosimp );
		}
	}
	if( mynode ) {
		//alert( mynode.nodeName + ":" + mynode.nodeType + ":" + mynode.value );
	}
	if( mynode && mynode.nodeType == 1 && mynode.value != undefined ) {
		if( tosimp ) {
			mynode.value = converttrad( mynode.value );
		} else {
			mynode.value = convertsimp( mynode.value );
		}
	}
	if( mynode && mynode.nodeType == 3 && mynode.nodeValue ) {
		if( tosimp ) {
			mynode.nodeValue = converttrad( mynode.nodeValue );
		} else {
			mynode.nodeValue = convertsimp( mynode.nodeValue );
		}
	}

}