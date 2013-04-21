/* Copyright 2009 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included.

Definition and pronounciation data is from CC-CEDICT (http://usa.mdbg.net/chindict/chindict.php?page=cedict) which is licensed under a Creative Commons Attribution Share-Alike 3.0 License.  So, anyone may use data I have derrived under that same license, provided attribution is given, and the resulting work uses the same license. 
*/


function wordmenu( theword, thechargbk, e )
{
var xmlhttp;
var meat;
var definition;
var pronounciation;
var debugstr;

debugstr = "";
if( theword.charAt( 0 ) == "%" ) {
	theword = unescape( theword );
}

//alert( "fetchotherelements: " + theCode + ":" + theElementId + ":" + initStr );
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
		if( xmlhttp.status == 200 ) {
			//ok, to proceed, parse XML
			var xmlDoc; 															var meat = null;
			var catstr;


			xmlDoc = xmlhttp.responseXML;
 			if( xmlDoc ) {
				meat = xmlDoc.getElementsByTagName( "def" );
			}
			//alert( meat );
			//alert( meat.length );
			definition = "<b>Definition: </b>";
			for( i = 0 ;meat && i < meat.length ; ++i ) {
				//alert( "otherElements: " + otherElements );
				if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
					var elid;
					var elhtml;

					definition += unescape(meat[i].childNodes[0].nodeValue);
				}
			}
			definition = strtopinyin( definition );
  			if( xmlDoc ) {
				meat = xmlDoc.getElementsByTagName( "pro" );
			}
			//alert( meat );
			//alert( meat.length );
			pronounciation = "<b>Pronounciation: </b>";
			for( i = 0 ;meat && i < meat.length ; ++i ) {
				//alert( "otherElements: " + otherElements );
				if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
					var elid;
					var elhtml;

					pronounciation += meat[i].childNodes[0].nodeValue;
				}
			}
			pronounciation = strtopinyin( pronounciation );
  			menu = document.getElementById( "mywordmenu" );
			if( menu ) {
				wwidth = 800;
				wheight = 600;
				swidth = 0;
				sheight = 0;

				if (window.innerWidth)  {//if browser supports window.innerWidth
					wwidth = window.innerWidth;
					whieght = window.innerHeight;
					swidth = window.pageXOffset;
					sheight = window.pageYOffset;
				} else if (document.all) { //else if browser supports document.all (IE 4+)
					wwidth = document.body.clientWidth;
					wheight = document.body.clientHeight;
					swidth = document.body.scrollLeft;
					sheight = document.body.scrollTop;
				}

				menu.style.position = "absolute";
				mouseY = e.clientY + sheight;
				mouseX = e.clientX + swidth;
				//debugstr = "wwidth: " + wwidth + " wheight: " + wheight + " swidth: " + swidth + "sheight: " + sheight + "e.clientX:" + e.clientX + "eclientY:" + e.clientY;
				if( e.clientY > wheight / 2 ) {
					menu.style.bottom = -sheight + wheight - (e.clientY - 15);
					menu.style.top = "auto";
				} else {
					menu.style.top = mouseY + 15;
					menu.style.bottom = "auto";
				}
				if( e.clientX > wwidth / 2 ) {
					menu.style.right = wwidth - mouseX;
					menu.style.left = "auto";
				} else {
					menu.style.left = mouseX;
					menu.style.right = "auto";
				}
				menu.style.visibility = "visible";
			}
			curparent = document.getElementById( "theword" );
			//alert( curparent );
			if( curparent.childNodes.length > 0 ) {
				curchar = curparent.firstChild.nodeValue;
				//alert( curchar );
				//curparent.firstChild.nodeValue = nextchar;
				curparent.innerHTML = "<b>" + theword + debugstr + "</b>";
			} else {
				curparent.innerHTML = "<b>" + theword + debugstr + "</b>";
			}
			curparent = document.getElementById( "thefloatdef" );
			//alert( curparent );
			if( curparent.childNodes.length > 0 ) {
				curchar = curparent.firstChild.nodeValue;
				curparent.innerHTML = definition;
			} else {
				curparent.innerHTML = definition;
			}
			curparent = document.getElementById( "thefloatpro" );
			//alert( curparent );
			if( curparent.childNodes.length > 0 ) {
				curchar = curparent.firstChild.nodeValue;
				curparent.innerHTML = pronounciation;
			} else {
				curparent.innerHTML = pronounciation;
			}



} else {
 			//alert( "Data on character composition missing." );
         }

       }
    }
   theURL = escape( theword );
   if( theURL.charAt(0) == "%" ) {
	theURL = theURL.substr( 1, theURL.length - 1 );
   }
   theURL += ".xml";
   //alert( theURL );
   xmlhttp.open("GET",theURL,true);
   xmlhttp.send(null);
}
