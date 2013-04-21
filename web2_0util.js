/* Copyright 2009, 2010, 2011 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included.

Definition and pronounciation data is from CC-CEDICT (http://usa.mdbg.net/chindict/chindict.php?page=cedict) which is licensed under a Creative Commons Attribution Share-Alike 3.0 License.  So, anyone may use data I have derrived under that same license, provided attribution is given, and the resulting work uses the same license. 
*/

function hextobin( digit )
{
	hexdigits = "0123456789ABCDEF";

	rval = hexdigits.indexOf( digit );
	return( rval );

}

function bintohex( num )
{
	var rval;
	var tmpnum;

	rval = "";
	tmpnum = num;
	charval = "0123456789ABCDEF";

	while( tmpnum ) {
		if( (tmpnum & 0xf0) != 0 ) {
			dig = (tmpnum & 0xf0 ) >> 4;
			tmpnum = tmpnum & 0xf;
			trailingzero = tmpnum == 0;
		} else if ( ( tmpnum & 0xf) != 0 ) {
			dig = tmpnum & 0xf;
			tmpnum = 0;
			trailingzero = false;
		}
		rval += charval.charAt( dig );
		if( trailingzero ) {
			rval += "0";

		}
	}



	return( rval );
}

function unitourlencodedutf8( uni )
{
	//alert( "unitourlencodedutf8" );
	y = (hextobin( uni.charAt(0) ) << 4) | hextobin( uni.charAt(1));
	//alert( "1" );
	x = (hextobin( uni.charAt(2) ) << 4) | hextobin( uni.charAt(3));
	//alert( "2" );
	b1 = 0xe0 | ( (0xf0 & y ) >> 4 );
	b2 = 0x80 | ( (0x0f & y ) << 2 ) | ( (0xc0 & x) >> 6 );
	b3 = 0x80 | ( (0x3f & x ) );
	//alert( "3" );
	return( "%" + bintohex( b1 ) + "%" + bintohex( b2 ) + "%" + bintohex( b3 ) ); 


}

function changecur(nodeId, nextchar)
{
	var curparent;
	var curchar;
	
	//alert( nextchar );
	curparent = document.getElementById( nodeId );
	if( !curparent ) {
		//alert( nodeId );
		return;
	}
	//alert( curparent );
	if( curparent.childNodes.length > 0 ) {
		curchar = curparent.firstChild.nodeValue;
		//alert( curchar );
		//curparent.firstChild.nodeValue = nextchar;
		curparent.innerHTML = nextchar;
	} else {
		curparent.innerHTML = nextchar;
	}
}

function getcontainedinlinks( elementid, inmsg, inmsg2, intarget )
{
	if( !elementid ) {
		return "";
	}
	mycharlist = "";
		// we have the id for the radical
		//alert( elementid );
 		if (window.XMLHttpRequest)
  		{
  			// code for IE7+, Firefox, Chrome, Opera, Safari
  			var xmlhttp=new XMLHttpRequest();
  		}
		else if (window.ActiveXObject)
  		{
  			// code for IE6, IE5
  			var xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  		}
		else
  		{
  			alert("Your browser does not support XMLHTTP!");
  			return;
 		 }
 		xmlhttp.msg = inmsg.substr( 0 );
		xmlhttp.msg2 = inmsg2.substr( 0 );
		xmlhttp.target = intarget.substr( 0 );
 		xmlhttp.onreadystatechange=function()
    		{
    			if(xmlhttp.readyState==4)
        		{
				//reset theCharList, theCharIndex
          			//txtResponse= xmlhttp.responseText;
				//alert( xmlhttp.status );
			
	  			if( xmlhttp.status == 200 ) {
					//ok, to proceed, parse XML
					var xmlDoc; 
					var msg = xmlhttp.msg;
					var msg2 = xmlhttp.msg2;
					var target = xmlhttp.target;															var meat = null;


					var mycharlist = "";
					xmlDoc = xmlhttp.responseXML;
					//alert( xmlDoc );
					if( xmlDoc ) {
						var meat = xmlDoc.getElementsByTagName( "elementchar" );
					}
					//alert( meat );
					//alert( meat.length );
					for( i = 0 ;meat && i < meat.length ; ++i ) {
						///alert( "theCharList: " + theCharList );
						if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
							mycharlist += unescape( meat[i].childNodes[0].nodeValue );
						}
					}
					var mychar = elementid;
					if( !target ) {
						target = "charlist";
					}
					if( mycharlist && mycharlist.length > 0 ) {
						var tmpstr = msg;
						var homestr = "web2_0.htm?";
						if( typeof( huamake ) != "undefined" ) {
							homestr = "home.htm?thePage=web2_0new&";
						}
						for( i = 0 ; i < mycharlist.length ; ++i ) {
							var ch = mycharlist.charAt( i );
							var chuni = escape( ch );

							if( chuni != mychar ) {
								tmpstr += "<span class=\"listchar\" onClick=\"javascript:window.location='http:./" + homestr + "godeep=on&theChar=" + chuni + "'\" id=\"" + chuni.substr(1,chuni.length -1) + "_li\" />" + ch + "</span>";
							} else {
								//tmpstr += "<span class=\"curchar\" onClick=\"javascript:skipto(this)\" id=\"" + chuni.substr(1,chuni.length -1) + "_li\" />" + ch + "</span>";
							}
						}
						tmpstr += msg2;
						changecur( target, tmpstr );  // tmpstr
					} else {
						changecur( target, "" );
					}
					var height1 = $("#bicharlist" ).height();
					var height2 = $("#fragpick" ).height();
					if( height1 > height2 ) {
						$( "#fragpick" ).height( height1 );
					}
 					$( "#fragback" ).button( "enable" );
       			} else {
 					alert( "Data on" + elementid + "characters missing." );
         			}
       			}
    		}
   		var theURL = elementid;
		var theExtension = ".xml";
   		if( theURL.charAt(0) == "%" ) {
			theURL = theURL.substr( 1, theURL.length - 1 );
			theExtension =  "_l" + ".xml";
   		}
  		theURL += theExtension;
   		//alert( theURL );
   		xmlhttp.open("GET",theURL,true);
   		xmlhttp.send(null);

}

function animatedemo( n, steps, interval ) {
	var oldn = n;
	var computedid;
	var computedstyle;


	//alert( "animatedemo: " + n );
	if( oldn >= 0 && oldn < steps.length ) {
		computedid = steps[oldn].id1class + "_" + oldn;
		$( "#" + computedid ).remove();
		//$( steps[oldn].id1 ).removeClass( steps[oldn].id1class );
		$( steps[oldn].id2 ).hide();
	}
	//alert( "animatedemo2: " + n );
	if( steps.active ) {
		++n;
		if( n >= steps.length ) {
			n = 0;
		}
		var p = $( steps[n].id1 ).position();
		if( p ) {
			computedid = steps[n].id1class + "_" + n;
			computedstyle = "position:absolute;z-index:25;top:" + p.top + ";left:" + p.left + ";height:" + $( steps[n].id1 ).height() + ";width:" + $( steps[n].id1 ).width();
			computedonclick = $( steps[n].id1 ).attr( "onClick" );
			//$( steps[n].id1 ).addClass( steps[n].id1class );
			//$( ".fragpicker" )
			$(steps[n].id2cont).append( '<div id="' + computedid + '" class="' + steps[n].id1class + '" style="' + computedstyle + '" onClick="' + computedonclick +'" >00</div>' );
		}
		if( steps[n].action != undefined ) {
			steps[n].action();
		}
		$( steps[n].id2 ).show();
		setTimeout( function(){ animatedemo( n, steps, interval ); }, interval );
	}

	return n;
}
