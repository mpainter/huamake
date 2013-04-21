/* Copyright 2009, 2010 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included.

Definition and pronounciation data is from CC-CEDICT (http://usa.mdbg.net/chindict/chindict.php?page=cedict) which is licensed under a Creative Commons Attribution Share-Alike 3.0 License.  So, anyone may use data I have derrived under that same license, provided attribution is given, and the resulting work uses the same license. 
*/


var theChar = "行";
var theCharList = "街行衡";
var theCharIndex = 1;
var theInputList = "行";
var theInputIndex = 0;
var theCommonElement = "行";
var theCommonElementId = "u884C";
var otherElements = "<div class=\"otherElement\"><p>step</p></div><div class=\"otherElement\"><p>top</p></div>";
var globalelementid = null;
var allOtherElements = "";

function checkSubmit() 
{
	//alert( "submitting" );
	document.userinput.theChar.value = escape(theInputList);
	return (false);
}


function mycheck( event ) 
{
	var boxname;
	var mydef = null;

	if( event ) {
		boxname = event.name;
		if( boxname && boxname == "chardef" ) {
			mydef = document.getElementById( "definition" );
			
		}
		if( boxname && boxname == "charpro" ) {
			mydef = document.getElementById( "pronounciation" );
		}
		if( mydef ) {
			if( event.checked ) {
				mydef.style.visibility = "visible";
				//alert( "visible" );
			} else {
				mydef.style.visibility = "hidden";
				//alert( "hidden" );
			}
		}
	}
}

function fetchTheCharList( elementid )
{
	var textNode = null;
	var xmlhttp;


	if( elementid ) {
		// we have the id for the radical
		//alert( elementid );
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
          			//txtResponse= xmlhttp.responseText;
				//alert( xmlhttp.status );
	  			if( xmlhttp.status == 200 ) {
					//ok, to proceed, parse XML
					var xmlDoc; 															var meat = null;


					theCharList = "";
					xmlDoc = xmlhttp.responseXML;
					//alert( xmlDoc );
					if( xmlDoc ) {
						meat = xmlDoc.getElementsByTagName( "elementchar" );
					}
					//alert( meat );
					//alert( meat.length );
					for( i = 0 ;meat && i < meat.length ; ++i ) {
						///alert( "theCharList: " + theCharList );
						if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
							theCharList += unescape( meat[i].childNodes[0].nodeValue );
						}
					}
					theCharIndex = theCharList.indexOf( unescape( elementid ) );
					if( theCharIndex < 0 ) {
 	    					theCharIndex = 0;
					}
					oldtheChar = theChar;
 					theChar = theCharList.charAt( theCharIndex);
					nextlink = document.getElementById( "curnext" );
					prevlink = document.getElementById( "curprev" );

					if( theCharList && theCharList.length > 1 ) {
						tmpstr = "";
						for( i = 0 ; i < theCharList.length ; ++i ) {
							ch = theCharList.charAt( i );
							chuni = escape( ch );

							if( ch != theChar ) {
								tmpstr += "<span class=\"listchar\" onClick=\"javascript:skipto(this)\" id=\"" + chuni.substr(1,chuni.length -1) + "_li\" />" + ch + "</span>";
							} else {
								tmpstr += "<span class=\"curchar\" onClick=\"javascript:skipto(this)\" id=\"" + chuni.substr(1,chuni.length -1) + "_li\" />" + ch + "</span>";
							}
						}
						changecur( "charlist", tmpstr );  // tmpstr
						nextlink.style.visibility = "visible";
						prevlink.style.visibility = "visible";
					} else {
						changecur( "charlist", "" );
						nextlink.style.visibility = "hidden";
						prevlink.style.visibility = "hidden";
					}

					//alert( otherelements );
        			} else {
 					//alert( "Data on other characters missing." );
         			}
       			}
    		}
   		theURL = elementid;
		theExtension = ".xml";
   		if( theURL.charAt(0) == "%" ) {
			theURL = theURL.substr( 1, theURL.length - 1 );
			theExtension =  "_l" + ".xml";
   		}
		theCommonElementId = theURL;
		//alert( theURL );
  		theURL += theExtension;
   		//alert( theURL );
   		xmlhttp.open("GET",theURL,true);
   		xmlhttp.send(null);
	}
}

function resetinput()
{

	theInputList = theChar;
	theInputIndex = 0;
	changecur( "charhead", "" );
	changecur( "chartail", "" );
}

function setinput( anode ) 
{
	//alert( anode.childNodes[0].textContent );
	if( anode && anode.childNodes.length > 0 ) {
		if( anode.childNodes[0].textContent ) {
			vstr = anode.childNodes[0].textContent;
		} else if( anode.childNodes[0].text ) {
			vstr = anode.childNodes[0].text;
		}
		i = vstr.indexOf( theChar );
		if( i >= 0 ) {
			theInputIndex = i;
			theInputList = vstr;
			charHead = displayInput( 0 );
			charTail = displayInput( theInputIndex + 1 );
			changecur( "charhead", charHead );
			changecur( "thechar", theChar );
			changecur( "chartail", charTail );
		}
	}
}

function inputto( fromIndex )
{
	if( fromIndex < theInputList.length ) {
		theInputIndex = fromIndex;
		if ( theInputList.charAt(0) == "i" && theInputList.charAt(1) == "_" ) {
			theChar = theInputList;
		} else {
			theChar = theInputList.charAt( theInputIndex );
		}
		theCharList = theChar;
		theCharIndex = 1;
		theCommonElement =  theChar ;
		theCharCode = escape( theChar );
		if( theCharCode.charAt(0) == "%" && theCharCode.charAt(1) == "u" ) {
			//alert( theCharCode );
			theCommonElementId = theCharCode.substr(1,theCharCode.length - 1);
			changecur( "thecharcode", "Unicode: " + theCharCode.substr(2) );
			fetchotherelements( theCharCode, "otherelements", "" );
			fetchTheCharList( theCharCode );
			charHead = displayInput( 0 );
			charTail = displayInput( theInputIndex + 1 );
			changecur( "charhead", charHead );
			changecur( "thechar", theChar );
			changecur( "chartail", charTail );
			changecur( "commonelement", theCommonElement );
		} else if ( theCharCode.charAt(0) == "i" && theCharCode.charAt(1) == "_" ) {
			globalelementid = theCharCode;
			followotherelement( null );
		} else {
			theCommonElementId = theCharCode;
		}
	}

}

function displayInput( fromIndex )
{
	var rstring = "";

	if( fromIndex < theInputIndex ) {
		rstring = theInputList.substr( fromIndex, theInputIndex );
	} else if ( fromIndex > theInputIndex ) {
		rstring = theInputList.substr( fromIndex, theInputList.length - 1 );
	}
	if( rstring.length > 0 ) {
		tstring = "";
		for( i = 0 ; i < rstring.length ; ++i ) {
			tchar = rstring.charAt( i );
			tchare = escape( tchar );
			tstring += "<span class=\"listchar\" onClick=\"javascript:inputto(" + ( fromIndex + i ) + ")\" id=\"" + tchare.substr(1,tchare.length -1) + "_inp\" />" + tchar + "</span>";
		}
		rstring = tstring;
	}
	return( rstring );
}

function mygetKey( event )
{
   var key;

     if(window.event)
          key = window.event.keyCode;     //IE
     else
          key = event.which;     //firefox

     if(key == 13) {
	  //alert( "<CR>" );
          //return( false );
	}

	//alert( event.value );
	if( event.value != "" && event.value != theChar && escape(event.value).indexOf( "%u" ) >= 0 ) {
		theInputList = event.value;
		//inputto( 0 );
		document.userinput.theChar.value=escape(event.value);
		document.userinput.submit();
		//event.value = "";
		//alert( event.value );
	} else if (event.value != "" && event.value != theChar ) {
		event.value = "";
	}

	return( true );
}

function followotherelement( event )
{
	var textNode = null;
	var elementid = null;
	var xmlhttp;

	//alert( "another path" );
	//alert( event.innerHTML );
	//alert( event.firstChild );
	if( event == null ) {
		elementid = globalelementid;
	} else {
		for( textNode = event.firstChild ; textNode &&  !(elementid); textNode = textNode.firstChild) {
			if( textNode.nodeValue ) {
				elementid = escape(textNode.nodeValue);
			}
			if( textNode.tagName == "IMG" && textNode.src ) {
				str1 = textNode.src;
				i1 = str1.lastIndexOf( "/" );
				i2 = str1.lastIndexOf( "\." );
				//alert ( str1 + " " + i1 + " " + i2 );
				if( i1 != -1 && i2 != -1 && i2 > i1 + 2 ) {
					str1 = str1.substr( i1 + 1, i2 - i1 - 1 );
				}
				elementid = str1;
				 
			}
			//alert( textNode.tagName );
		}
	}
	if( elementid ) {
		// we have the id for the radical
		//alert( elementid );
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
          			//txtResponse= xmlhttp.responseText;
				//alert( xmlhttp.status );
	  			if( xmlhttp.status == 200 ) {
					//ok, to proceed, parse XML
					var xmlDoc; 															var meat = null;


					theCharList = "";
					xmlDoc = xmlhttp.responseXML;
					//alert( xmlDoc );
					if( xmlDoc ) {
						meat = xmlDoc.getElementsByTagName( "elementchar" );
					}
					//alert( meat );
					//alert( meat.length );
					for( i = 0 ;meat && i < meat.length ; ++i ) {
						///alert( "theCharList: " + theCharList );
						if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
							theCharList += unescape( meat[i].childNodes[0].nodeValue );
						}
					}
					theCharIndex = theCharList.indexOf( theChar );
					if( theCharIndex < 0 ) {
 						theCharIndex = theCharList.indexOf( unescape( elementid ) );
						if( theCharIndex < 0 ) {
 	    						theCharIndex = 0;
						}
					}
 					oldtheChar = theChar;
 					theChar = theCharList.charAt( theCharIndex);
					nextlink = document.getElementById( "curnext" );
					prevlink = document.getElementById( "curprev" );

					if( theCharList && theCharList.length > 1 ) {
						tmpstr = "";
						for( i = 0 ; i < theCharList.length ; ++i ) {
							ch = theCharList.charAt( i );
							chuni = escape( ch );

							if( ch != theChar ) {
								tmpstr += "<span class=\"listchar\" onClick=\"javascript:skipto(this)\" id=\"" + chuni.substr(1,chuni.length -1) + "_li\" />" + ch + "</span>";
							} else {
								tmpstr += "<span class=\"curchar\" onClick=\"javascript:skipto(this)\" id=\"" + chuni.substr(1,chuni.length -1) + "_li\" />" + ch + "</span>";
							}
						}
						changecur( "charlist", tmpstr );  // tmpstr
						nextlink.style.visibility = "visible";
						prevlink.style.visibility = "visible";
					} else {
						changecur( "charlist", "" );
						nextlink.style.visibility = "hidden";
						prevlink.style.visibility = "hidden";
					}
					resetinput();
					changecur( "thechar", theChar );
					changecur( "commonelement", theCommonElement );
					fetchotherelements( escape( theChar ), "otherelements", "" );
					theCharCode = escape( theChar );
					changecur( "thecharcode", "Unicode: " + theCharCode.substr(2) );
					//alert( otherelements );
        			} else {
 					alert( "Data on other characters missing." );
         			}
       			}
    		}
   		theURL = elementid;
		theExtension = ".xml";
   		if( theURL.charAt(0) == "%" ) {
			theURL = theURL.substr( 1, theURL.length - 1 );
			theExtension =  "_l" + ".xml";
   		}
		theCommonElementId = theURL;
		//alert( theURL );
 		if( theCommonElementId.indexOf( "i_" ) == 0 ) {
			theCommonElement = "<b class=\"commonElement\" ><img src=\"" + theCommonElementId + ".bmp" + "\" /></b>";
		} else {
			theCommonElement = "<b class=\"commonElement\" >" + unescape(elementid) + "</b>";
		}
  		theURL += theExtension;
   		//alert( theURL );
   		xmlhttp.open("GET",theURL,true);
   		xmlhttp.send(null);

	} else {
		alert( "no id for radical" );
	}
}

function testElementLink( elid, oldid )
{
var xmlhttp;

//alert( "testelementlink: " + elid + " oldid:" + oldid);
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
    var newmeat;
    var xmlDoc; 


     if(xmlhttp.readyState==4)
        {
		if( xmlhttp.status == 200 ) {
			//ok, to proceed, parse XML
			var xmlDoc; 															var meat = null;
			var catstr;
			var otherElements;

			//alert( "xmlDoc:" );
			otherElements = allOtherElements;  //oldid
			ootherElements = otherElements;
			xmlDoc = xmlhttp.responseXML;
			//alert( xmlDoc );
			if( xmlDoc ) {
				newmeat = xmlDoc.getElementsByTagName( "elementid" );
			}
			//alert( newmeat );
			//alert( newmeat.length );
			for( i = 0 ;newmeat && i < newmeat.length ; ++i ) {
				//alert( "otherElements: " + otherElements );
				//alert( "newmeat:" +newmeat );
				if( newmeat[i].childNodes[0] && newmeat[i].childNodes[0].nodeValue ) {
					var newelid;
					var newelhtml;
					
					newelhtml = "";

					newelid = newmeat[i].childNodes[0].nodeValue;
					if( allOtherElements.indexOf( newelid ) == -1 ) {
						// this is a component we do not yet have
						allOtherElements += newelid;
						if( newelid.indexOf( "i_" ) == 0 ) {
							newelhtml = "<span class=\"otherElement\" id=\"" + newelid + "\" onclick=\"javascript:followotherelement(this);\" ><img src=\"" + newelid + ".bmp" + "\" /></span>";
						} else {
							newelhtml = "<span class=\"otherElement\" id=\"" + newelid + "\" onclick=\"javascript:followotherelement(this);\" >" + unescape(newelid) + "</span>";
						}
						//alert( newelhtml );
						if( theCommonElementId == newelid || theCommonElementId == newelid.substr(1, newelid.length - 1) || ( otherElements.indexOf( newelid ) != -1 ) || newelhtml.length == 0 ) {
							//alert( otherElements + otherElements.indexOf( newelid )) ;
							//theCommonElement = elhtml;
						} else {
							var oenode = document.getElementById( "otherelements" );
							var newnode = document.createElement( "span" );
							//alert( newnode + oenode + newelhtml );
							newnode.innerHTML = newelhtml;
							if( oenode ) {
								oenode.appendChild( newnode );
								// recurse
								otherElements += newelhtml;
							}
						
						}
						//alert( newelid );
					}
				}
			}
			if( otherElements != ootherElements ) {
				//alert( otherElements  );
				testElementLinks( newmeat, otherElements );
			}
			elhtml = "";
			elnode = document.getElementById( elid );
			if( elnode ) {
				//parent = elnode.parentNode;
				//el = document.createElement(parent.tagName);
				//el.appendChild(elnode);
				//if( parent ) {
					//elhtml = parent.innerHTML;
				//}
				//alert( "oldid:" + oldid + " elid:" + elid  + " elhtml:" + elhtml);
				//if( oldid != elid ) {
					//fetchotherelements( elid, elid, oldid );
				//}
			} else {
				//alert( "no node" );
			}
		} else {
			// alert( elid + " missing" );
			elnode = document.getElementById( elid );
			if( elnode ) {
				elnode.className = "missingOtherElement";
			} else {
				alert( "no node:" + elid );
			}
			elhtml = "";
			//alert( "theCommonElementId 2:" + theCommonElementId + " elid:" + elid );
			if( oldid != elid ) {
				//fetchotherelements( elid, elid, elhtml );
			}
		}
	}
    }
   theURL = elid;
   theExtension = ".xml";
   if( theURL.charAt(0) == "%" ) {
	theURL = theURL.substr( 1, theURL.length - 1 );
	//theExtension =  "_l" + ".xml"; // searching for character composition
   }
   theURL += theExtension;
   //alert( theURL );
   xmlhttp.open("GET",theURL,true);
   xmlhttp.send(null);
}

function testElementLinks( meat, oldid )
{
	for( i = 0 ;meat && i < meat.length ; ++i ) {
				//alert( "otherElements: " + otherElements );
		if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
			var elid;
			var elhtml;

			elid = meat[i].childNodes[0].nodeValue;
			testElementLink( elid, oldid );
		}
	}
}

function fetchotherelements( theCode, theElementId, initStr )
{
var xmlhttp;
var meat;
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


			otherElements = initStr;
			xmlDoc = xmlhttp.responseXML;
			if( xmlDoc ) {
				meat = xmlDoc.getElementsByTagName( "elementid" );
			}
			//alert( meat );
			//alert( meat.length );
			allOtherElements = "";
			for( i = 0 ;meat && i < meat.length ; ++i ) {
				//alert( "otherElements: " + otherElements );
				if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
					var elid;
					var elhtml;

					elid = meat[i].childNodes[0].nodeValue;
					if( elid.indexOf( "i_" ) == 0 ) {
						elhtml = "<span class=\"otherElement\" id=\"" + elid + "\" onclick=\"javascript:followotherelement(this);\" ><img src=\"" + elid + ".bmp" + "\" /></span>";
					} else {
						elhtml = "<span class=\"otherElement\" id=\"" + elid + "\" onclick=\"javascript:followotherelement(this);\" >" + unescape(elid) + "</span>";
					}
					if( theCommonElementId == elid || theCommonElementId == elid.substr(1, elid.length - 1) || ( otherElements.indexOf( elid ) != -1 )) {
						//alert( otherElements + otherElements.indexOf( elid )) ;
						//theCommonElement = elhtml;
					} else {
						otherElements += elhtml;
						allOtherElements += elid;
					}
				}
			}
			changecur( theElementId, otherElements );
			testElementLinks( meat, otherElements );
 			changecur( "commonelement", theCommonElement );
 			if( xmlDoc ) {
				meat = xmlDoc.getElementsByTagName( "def" );
			}
			//alert( meat );
			//alert( meat.length );
			catstr = "<b>Definition: </b>";
			for( i = 0 ;meat && i < meat.length ; ++i ) {
				//alert( "otherElements: " + otherElements );
				if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
					var elid;
					var elhtml;

					catstr += unescape(meat[i].childNodes[0].nodeValue);
				}
			}
			catstr = strtopinyin( catstr );
  			changecur( "definition", catstr );
 			if( xmlDoc ) {
				meat = xmlDoc.getElementsByTagName( "pro" );
			}
			//alert( meat );
			//alert( meat.length );
			catstr = "<b>Pronounciation: </b>";
			for( i = 0 ;meat && i < meat.length ; ++i ) {
				//alert( "otherElements: " + otherElements );
				if( meat[i].childNodes[0] && meat[i].childNodes[0].nodeValue ) {
					var elid;
					var elhtml;

					catstr += meat[i].childNodes[0].nodeValue;
				}
			}
			catstr = strtopinyin( catstr );
  			changecur( "pronounciation", catstr );
    		 	if( xmlDoc ) {
				meat = xmlDoc.getElementsByTagName( "usageel" );
			}
			//alert( meat );
			//alert( meat.length );
			catstr = "<b>Usage: </b>";
			cpodstr = "";
			for( i = 0 ;meat && i < meat.length ; ++i ) {
				//alert( "usageel: " + otherElements );
				if( meat[i].childNodes[0] ) {
					uninode = null;
					gbnode = null;
					cpodstr = "";
					
					uni_1 = 0;

					//alert( meat[i].childNodes[0].localName );
					//alert( meat[i].childNodes[1].localName );
					if(  meat[i].childNodes[0].nodeName == "gb" && meat[i].childNodes[0].childNodes[0] ) {
						//alert( "found gb" );
						gbnode = meat[i].childNodes[0];
						uni_1 = 1;
						celement = theCommonElementId;
						//alert( celement + theCode );
						if( celement.charAt(0) == "u" ) {
							//alert( "0" );
							celement = "%" + celement;
						}
						//alert( "0.5" );
						catstr += "<a  target=\"usageexamples\" onmouseover=\"javascript:setinput(this);\" href=\"http://www.learn-chinese-words.com/cgi-bin/external.cgi?extsrc=dictcn&charstring=";
						//alert( "1" );
						catstr += gbnode.childNodes[0].nodeValue; // + "&inturl=" ;
						//alert( "2" );
						//catstr += escape( "http://huamake.com/web2_0.htm?theChar=" ) ;
						//alert( "3" );
						//catstr += escape( celement ) + escape( "&thePlace=") + escape( theCode );
						//alert( "4" ); 
						catstr +=  /*"&title=" + escape( "Character Structures" ) + */ "  \" >";
						//alert( "5" );

						//alert( gbnode.childNodes[0].nodeValue );
					}
					if( meat[i].childNodes[1] && meat[i].childNodes[1].nodeName == "uni" ) {
						//alert( "found uni" );
						catstr += unescape( meat[i].childNodes[1].childNodes[0].nodeValue );
						cpodstr = "<a href=\"javascript:findcpodlesson(\'" + meat[i].childNodes[1].childNodes[0].nodeValue + "\')\" >"  + "<img src=\"http://chinesepod.com/images/icons/favicon.ico\" class=\"imglink\" ></a>";
						//alert( "boo2" );
					} else if ( meat[i].childNodes[0] && meat[i].childNodes[0].nodeName == "uni" ) {
						catstr += unescape( meat[i].childNodes[0].childNodes[0].nodeValue );
						cpodstr = "<a href=\"javascript:findcpodlesson(\'" + meat[i].childNodes[0].childNodes[0].nodeValue + "\')\" >"  + "<img src=\"http://chinesepod.com/images/icons/favicon.ico\" class=\"imglink\" ></a>";
					
					}
					if( gbnode ) {
						catstr += "</a>";
						//alert( "</a>" );
					}
					catstr += cpodstr;
					catstr += ", ";
				}
			}
  			changecur( "usage", catstr );
			catstr = "<b>Etomology: ";
			if( theCode.substr( 0, 2 ) == "%u" ) {
				catstr += "</b><a href=\"http://chinese-characters.org/cgi-bin/lookup.cgi?characterInput=" + unescape( theCode ) + "\" target=\"eto\" />chinese-characters.org</a>";
			}
  			changecur( "etomology", catstr );
			catstr = "<b>How to Write: ";
			if( theCode.substr( 0, 2 ) == "%u" ) {
				catstr += "</b><a href=\"http://www.words-chinese.com/character-flash-animation?qstr=" + unitourlencodedutf8( theCode.substr(2,4) ) + "\" target=\"htw\" />words-chinese.com</a>";
			}
  			changecur( "howtodraw", catstr );


} else {
 			changecur( "commonelement", "Data on character composition missing." );
         }

       }
    }
   theURL = theCode;
   if( theURL.charAt(0) == "%" ) {
	theURL = theURL.substr( 1, theURL.length - 1 );
   }
   theURL += ".xml";
   //alert( theURL );
   xmlhttp.open("GET",theURL,true);
   xmlhttp.send(null);
}


function skipto( event ) 
{
	//alert( "skipto: " + event + event.id );

	if(event && event.id ) {
		new_id = event.id;
		oldch = escape( theChar );
		chuni = "%" + new_id.substr( 0, 5 );
		ch = unescape( chuni );
		for( i=0 ; i < theCharList.length && theCharList.charAt( i ) != ch ; ++i ) {
		}
		if( i < theCharList.length ) {
			theCharIndex = i;
			changecur( "thechar", theCharList.charAt( theCharIndex) );
			theChar = theCharList.charAt( theCharIndex);
			resetinput();
			theCharCode = escape( theChar );
			changecur( "thecharcode", "Unicode: " + theCharCode.substr(2) );
			fetchotherelements( theCharCode, "otherelements", "" );

			old_id = document.getElementById( oldch.substr( 1, oldch.length - 1) + "_li" );
			//alert( "class: " + old_id.className + event.className );
			if( old_id ) {
				old_id.className = "listchar";
			}
			if( event ) {
				event.className = "curchar";
			}
		} else {
			alert( chuni + "not in current list" );
		}
	}
}

function goprev()
{
	--theCharIndex;
	if( theCharIndex < 0 ) {
		theCharIndex = theCharList.length - 1;
	}
	oldch = escape( theChar );
	changecur( "thechar", theCharList.charAt( theCharIndex) );
	theChar = theCharList.charAt( theCharIndex);
	resetinput();
	theCharCode = escape( theChar );
	changecur( "thecharcode", "Unicode: " + theCharCode.substr(2) );
	fetchotherelements( theCharCode, "otherelements", "" );
	//changecur( "otherelements", otherElements );
	newch = escape( theChar );
	old_id = document.getElementById( oldch.substr( 1, oldch.length - 1) + "_li" );
	new_id = document.getElementById( newch.substr( 1, oldch.length - 1) + "_li" );
	//alert( "class: " + old_id.className + event.className );
	if( old_id ) {
		old_id.className = "listchar";
	}
	if( new_id ) {
		new_id.className = "curchar";
	}
}

function gonext()
{
	++theCharIndex;
	if( theCharIndex >= theCharList.length ) {
		theCharIndex = 0;
	}
	oldch = escape( theChar );
	
	changecur( "thechar", theCharList.charAt( theCharIndex) );
	theChar = theCharList.charAt( theCharIndex);
	resetinput();
	theCharCode = escape( theChar );
	changecur( "thecharcode", "Unicode: " + theCharCode.substr( 2 ) );
	fetchotherelements( theCharCode, "otherelements", "" );
	//changecur( "otherelements", otherElements );
	newch = escape( theChar );
	old_id = document.getElementById( oldch.substr( 1, oldch.length - 1) + "_li" );
	new_id = document.getElementById( newch.substr( 1, oldch.length - 1) + "_li" );
	//alert( "class: " + old_id.className + event.className );
	if( old_id ) {
		old_id.className = "listchar";
	}
	if( new_id ) {
		new_id.className = "curchar";
	}
}


function delayedskipto( tagId )
{
	//alert( tagId );
	tag = document.getElementById( tagId + "_li" );
	//alert( tag );
	if( tag ) {
		skipto( tag );
	}
}

function initpage() 
{
	//alert( theChar.valueOf() );
	//alert( unitourlencodedutf8( "6BCD" ) );
	var tmpStr;
	var tmpInt;

	tmpStr = window.location.search.substring(1);
	tmpInt = tmpStr.indexOf( "theChar" );
	if( tmpInt != -1 ) {
		tmpStr = tmpStr.substr( tmpInt + 8 );
		pend = tmpStr.indexOf( "&" );
		if( pend >= 0 ) {
			tmpStr = tmpStr.substr( 0, pend );
		}
		theInputList = unescape( unescape( tmpStr ));
		inputto( 0 );
	}   else {
		theCharCode = escape( theChar );
		fetchTheCharList( theCharCode );
	} 
	mybox = document.getElementById( "chardef" );
	if( mybox ) {
		mycheck( mybox );
	}
	mybox = document.getElementById( "charpro" );
	if( mybox ) {
		mycheck( mybox );
	}
	tmpStr = window.location.search.substring(1);
	tmpInt = tmpStr.indexOf( "thePlace" );
	if( tmpInt != -1 ) {
		tmpStr = tmpStr.substr( tmpInt + 9 );
		pend = tmpStr.indexOf( "&" );
		if( pend >= 0 ) {
			tmpStr = tmpStr.substr( 0, pend );
		}
		tagId = tmpStr.substr( 1, 5 );
		setTimeout( "delayedskipto( \"" + tagId + "\" )", 2000 ); 
	}
	changecur( "thechar", theChar );
	document.getElementById('curprev').onclick = goprev;
	document.getElementById('curnext').onclick = gonext;
	changecur( "commonelement", theCommonElement );
	theCharCode = escape( theChar );
	changecur( "thecharcode", "Unicode: " + theCharCode.substr(2) );
	fetchotherelements( theCharCode, "otherelements", "" );
	//changecur( "otherelements", otherElements );
	inithanconvert();
}

function findcpodlesson( thechar ) 
{
		document.forms[ "csform" ].search.value = unescape( thechar ) ;
		document.forms[ "csform" ].submit(); 
}
