/* Copyright 2010 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included.
*/

var commentsloaded = 0;

/* 
Purpose - get querystringvalue
*/
function getqstringvalue( key )
{
	var tmpStr;
	var tmpInt;
	var theValue = "";

	tmpStr = window.location.search.substring(1);
	tmpInt = tmpStr.indexOf( key );
	if( tmpInt != -1 ) {
		tmpStr = tmpStr.substr( tmpInt + 8 );
		pend = tmpStr.indexOf( "&" );
		if( pend >= 0 ) {
			theValue = tmpStr.substr( 0, pend );
		} else {
			theValue = tmpStr;
		}
	} 
	return( theValue );
}

/* 
Purpose - assign different styles to different levels in the tree
	sectionno: something like 3.2.4; indicates position in tree
	dotcnt: sometimes the caller needs to make an adjustment, for example, when
		painting a header for the succeeding level

Method - just count the dots in the section number.
*/
function pickstyle ( sectionno, dotcnt ) {
	var i, rval;
	
	if( sectionno == undefined ) {
		sectionno = "0";
		--dotcnt;
	}
	while((i = sectionno.indexOf( "." ) ) > 0 ) {
		dotcnt++;
		sectionno = sectionno.substr( i + 1 );
	}
	switch (dotcnt) {
		case 0:
			rval = "tt-level1"
			break;
		case 1: 
			rval = "tt-level2"
			break;
		case 2:
			rval = "tt-level3"
			break;
		default:
			rval = "tt-level4"
			break;
	}
	return( rval );

}

/* 
Purpose - place an appropriate icon for expanding or contracting the tree, at each row. 
	The treetable widget should do this, but it didn't work in all cases.

Method - remove any old icon, then insert the correct one.  Using a style with a background image 
doesn't seem to work on IE 8.
*/
function styleexpanders ( ) {
// only seems to be necessary on IE8 and related browsers, but it seems more universal than
// the original TreeTable stylesheet method.
	/*
	$( ".collapsed" ).find( ".expander" ).removeClass( "expanderdown" );
	$( ".collapsed" ).find( ".expander" ).addClass( "expanderup" );
	$( ".expanded" ).find( ".expander" ).removeClass( "expanderup" );
	$( ".expanded" ).find( ".expander" ).addClass( "expanderdown" );
	*/
	$( ".collapsed" ).find( ".expander" ).empty();
	$( ".collapsed" ).find( ".expander" ).append( '<img src="./images/toggle-expand-dark.png" />' );
	$( ".expanded" ).find( ".expander" ).empty();
	$( ".expanded" ).find( ".expander" ).append( '<img src="./images/toggle-collapse-dark.png" />' );
}

/* 
Purpose - expand a node of the tree-table and the ancestor nodes of that node.  This is necessary to display the newly inserted data after re-initializing the tree-table.
	node - the node that is to be expanded, basically make all of the "child-of-*" nodes for that node visible.

Method - get the parent node's selector from the "descendent-of-*" class for the current node, recursively call expandup for that node, and then process the current node.  The recursion terminates at the top level nodes.
*/
function expandup( node ) {
	var classlist = $( node ).attr( "class" );
	var i;
	var j;
	var pnode;

	if( node == "#commentbox" ) {
		return;
	}
	i = classlist.indexOf( "descendent-of-" );
	if( i >= 0 ) {
		pnode = classlist.substr( i );
		j = pnode.indexOf ( " " );
		if( j > 0 ) {
			pnode = pnode.substr( 0, j );
		}
		pnode = "#" + pnode;
		pnode = pnode.replace( "descendent-of-", "" );
		expandup( pnode );
	}
	$( node ).expand();
}

/* 
Purpose - get the numerical id of a parent node from a class name of the form "child-of-cb-node-X", where X is the desired number.  The parent ID is used to communicate with the backend, when sending new comments, or obtaining lists of child nodes.
	pid - a class name.

Method - just string parsing.
*/

function getnumberfrompid( pid ) {
	var parid;

	if( pid == "#commentbox" || pid == "commentbox" ) {
		parid = 0;
	} else {
		parid = pid;
		while( (i = parid.indexOf( "-" )) >= 0 ) {
			parid = parid.substr( i + 1 );
		}
	}
	return( parid );
}

/* 
Purpose - flash an error message on the screen long enough for the user to realize something went wrong, then return to the previous screen to give them a chance to correct the problem.

Method - create a "div" with appropriate background properties and remove it after an interval.
*/
function displayerror ( errstr ) {
	$( "<div id=huaerrorbox>" + errstr + "</div>" ).appendTo( "body" );
	setTimeout( function(){ $( "#huaerrorbox" ).remove(); }, 1000 );
}

/* 
Purpose - POST a user's completed comment to the backend and process the response.

Method - glean required data from tag attributes, use jQuery .post() to perform the mechanics of the operation, and perform the post processing in a call-back function.
*/

function postcomment( node ) {
	var whoami = $(node).attr( "pnode" );
	//alert( whoami );
	var target = "#" + whoami.replace( "descendent-of-", "" );
	var formname= target + "-responseform";
	var parid = target;
	var i;
	parid = getnumberfrompid( target );
	$( '<div id="workingonit" ></div>' ).appendTo( "body" );
	//var mydata = $(formname).serialize();
	$.post( "./app/huamakesend.php", $( formname ).serialize(),function (data){
		if( $(data).find( "error" ).length > 0 ) {
			$( "#workingonit" ).remove();
			displayerror( $(data).text() );
		} else {
			removecommentsubtree( target.substr( 1 ) );
			$(target).attr( "myexpnd", "0" ); 
			loadhuamakecomments( target, parid, 1 );
		}
	} );
	// should re-draw list here
}

/* 
Purpose - When scrolling through a list of elements, extract the first or last node currently displayed from a attribute of the form: cstart-X-cend-Y-.
	key - "cstart", or "cend"
	ctcursor - the attribute string

Method - just simple string parsing.
*/

function getctcursorvalue( key, ctcursor ) {
	var rval = 0;
	var istart;
	var iend;

	if( !ctcursor ) {
		return( rval );
	}
	istart = ctcursor.indexOf( key ) + key.length + 1;
	if( istart < 0 ) {
		return( rval );
	}
	ctcursor = ctcursor.substr( istart );
	iend = ctcursor.indexOf( "-" );
	if( iend < 1 ) {
		return( rval );
	}
	ctcursor = ctcursor.substr( 0, iend );
	rval = parseInt( ctcursor );
	return( rval );
}
	
/* 
Purpose - When a new message is submitted, the list of messages in that thread, needs to be refreshed.  This routine cleans up the old data.
	pid - the DOM id of the node whose descendants are to be cleaned.

Method - use jQuery .each to first clean up the children of children, then remove the children themselves.
*/

function removecommentsubtree( pid ) {
	var myctrclass = ".descendent-of-" + pid;

	$( myctrclass ).each( function () { removecommentsubtree( $(this).attr( "id" ) ); } )
		.remove();
}

/* 
Purpose - display a form for the user to enter a response on a given message thread.
	node - "this" from an event hanlder.

Method - Copy a block of HTML to use as a template and edit attribute values, as required.
*/

function getresponseform( node ) {
	var pid = node.parentNode.id;
	var pid = pid.replace( "-td", "" );
	var target = "#" + pid;
	var myclass;
	var myotherclass;

	pid = pid.replace( "-actionrow", "" );
	var myselector = "#" + pid + "-responserow";
	var sectionno = $( "#" + pid ).attr( "sectionno" );
	var stylestr = pickstyle( sectionno, 1 );
	myclass = "descendent-of-" + pid;
	myotherclass = "child-of-" + pid;
	myotherclass += " " + stylestr;
	//alert( pid );
	if( $(myselector).length > 0 ) return; // only one form per message
	var tdselector = myselector + "-td";

	$( '<tr id="' + myselector.substr(1) + '" class="' + myclass + '" ><td colspan="3" id="' + tdselector.substr(1) + '" ></td></tr>' ).insertAfter( target );
	var captchaq = $( "#" + pid ).find( ".captchaq:last" ).text();

	$( "#response-template" )
		.children()
		.each(function(){ $(this).clone(1).appendTo( tdselector ); } );
	$( "#response-template" ).css( "display", "none" );  // hack
	$( myselector ).find( "form" ).attr( "id", pid + "-responseform" );
	// set parent value
	$( myselector ).find( '[name=parent]' ).attr( "value", getnumberfrompid(pid) );
	$( myselector ).find( '[name=showall]' ).attr( "value", getqstringvalue( "showall" ) );
	$( myselector ).find( ".charlink" ).attr( "pnode", myclass );
	$( myselector ).find( '[name=captcha]' ).after( captchaq );
	$( myselector ).addClass( myotherclass );
}

/* 
Purpose - scroll the comments within a given thread.
	node - this from an event handler
	forward - 1 = scroll towards higher cardinality, 0 - scroll towards lower cardinality.

Method - obtain current scroll position from "ctcursor" attribute, add or subtract and increment, save the result back to the attribute, clean out the old data and fetch the data for the new scroll position.
*/

function gonextcomment(node, forward) {
	var pid = node.parentNode.id;
	var target;
	var parid;
	var i;
	var ctcursor;
	var cstart;
	var cend;
	var cinc;

	pid = pid.replace( "-actionrow-td", "" );
	//alert( pid );
	target = "#" + pid;

	// get and set cursor position for this element
	ctcursor = $(target).attr( 'ctcursor' );
	cstart = getctcursorvalue( "cstart", ctcursor );
	cend = getctcursorvalue( "cend", ctcursor );
	if( cstart == 0 || cend == 0 ) {
		//use defaults
		cstart = 1;
		cend = 10;
	}
	cinc = cend - cstart + 1;
	if( !forward ) {
		cinc = -cinc;  // implements previous
	}
	cstart += cinc;
	cend += cinc;
	ctcursor = "cstart-" + cstart + "-cend-" + cend + "-";
	$(target).attr( 'ctcursor', ctcursor );
	if( pid == "commentbox" ) {
		parid = "0";
	} else {
		parid = pid;
		while( (i = parid.indexOf( "-" )) >= 0 ) {
			parid = parid.substr( i + 1 );
		} 
		//$( ".child-of-" + pid ).remove();
	}
	removecommentsubtree( pid );
	$( target ).attr( "myexpnd", "0" );
	loadhuamakecomments( target, parid, 0 );
}

/* 
Purpose - display buttons that allow a given thread to be scrolled, or for the user to add a response.
	target - the selector for the last child of the parent (the buttons follow, this node).
	node - not used.
	pnode - the selector for the parent of the current node.

Method - compose the table elements within the code, and copy an existing HTML block for the buttons.
*/
function paintactionrow( target, node, pnode ) {
	var arid = pnode.substr( 1 ) + "-actionrow";
	var mytrclass = "child-of-" + pnode.substr(1);
	var myselector = "#" + arid;
	var myctrclass = " descendent-of-" + pnode.substr(1);
	var tdid = arid + "-td";
	var threadno = $( pnode ).attr( "sectionno" );
	var stylestr = pickstyle( threadno, 1 );

	myctrclass += " " + stylestr;

	if( target == "#commentbox" ) {
		$( '<tr id="' + arid + '" class="' +  myctrclass +'" ><td id="' + tdid + '"colspan="3">' + "</td></tr>" ).appendTo( "#commentbody" );
	} else {
		$( '<tr id="' + arid + '" class="' + mytrclass + myctrclass +'" ><td colspan="3" id="' + tdid + '">' + "</td></tr>" ).insertAfter( target );
	}
	$( "#actionrow-template" )
		.children()
		.each(function(){ 
			$(this).clone(1).appendTo( "#" + tdid ); 
		} );
	if( target != "#commentbox" ) {
		$( "#" + tdid ).find( ".charlink:last" ).text( "Respond to thread " + threadno );
	}

	$( "#actionrow-template" ).css( "display", "none" );  // hack
	//$( myselector ).css( "display", "inline" );
	return myselector;
}

/* 
Purpose - display buttons that allow a given thread to be scrolled, or for the user to add a response.
	target - the selector for the last child of the parent (the node being painted will follow it).
	node - a block of XML representing the contents of this node.
	pnode - the selector for the parent of the current node.
	sectionno - a textual description of this nodes place in the tree-table (e.g. "3.2.4" )

Method - compose the table elements within the code.
*/
function paintcommentrow( target, node, pnode, sectionno ) {
	var cid = node.find( "id" ).text();
	var uid = node.find( "userid" ).text();
	var uname = node.find( "username" ).text();
	var subject = node.find( "subject" ).text();
	var cbody = node.find( "commentbody" ).text();
	var captchaq = node.find( "captcha" ).text();
	if( cbody == "-long-" ) {
		var dsrc = './app/huamakecbodyout.php?id=' + cid;  // get from PHP code
		var dsrc = './cache/file/' + cid + ".htm"; // get from cache
		cbody = '<iframe src ="' + dsrc
			+ '" width="100%" height="80" scrolling="auto" ><p>Your browser does not support iframes.</p></iframe>';
	}
	var timeentered = node.find( "enteredwhen" ).text();
	cbody = "[" + timeentered + " ]<b> " + subject + "</b> - " + cbody;
	var trid = "cb-node-" + cid; //(target == "#commentbox")? "cb-node-" + cid : pnode.substr(1) + "-" + cid;
	var trcid = trid + "-100";
	var trclass = "child-of-" + trid; // attach to responses
	var mytrclass = "child-of-" + pnode.substr(1);
	var myctrclass = " descendent-of-" + pnode.substr(1);
	var c1heading = "Sub-thread";
	var c2heading = "";
	var c3heading = "Response";
	var stylestr = pickstyle( sectionno, 0 );
	var stylestr2 = pickstyle( sectionno, 1 );
	myctrclass += " " + stylestr;
	var rval;

	//alert( cid + ":" + uid + ":" + cbody );
	if( target == "#commentbox" ) {
		$( '<tr id="' + trid + '" class="' + myctrclass + 
		'" sectionno="' + sectionno + 
		'"> <td>' + sectionno + "</td><td>" + uname + '</td><td width="100%" >' + cbody + "</td></tr>" ).appendTo( "#commentbody" );
		myctrclass = myctrclass.replace( stylestr, stylestr2 );
		$( '<tr id="' + trcid + '" class="' + trclass + myctrclass + '" ><td>' + c1heading + "</td><td>" + c2heading + "</td><td>" + c3heading + "</td></tr>" ).appendTo( "#commentbody" );
		rval = target;
	} else {
		$( '<tr id="' + trid + '" class="' + mytrclass + myctrclass +'" sectionno="' + sectionno +'" ><td>' + sectionno + "</td><td>" + uname + "</td><td>" + cbody + "</td></tr>" ).insertAfter( target );
		myctrclass = myctrclass.replace( stylestr, stylestr2 );
		$( '<tr id="' + trcid + '" class="' + trclass + myctrclass + '" ><td>' + c1heading + "</td><td>" + c2heading + "</td><td>" + c3heading + "</td></tr>" ).insertAfter( "#" + trid );
		rval = "#" + trcid;
	}
	$( '<span class="captchaq" style="display:none">' + captchaq + '</span>' ).appendTo( "#" + trid  );
	return( rval );

}

/* 
Purpose - fetch required data and load the current scroll window of the specified discussion thread.
	target - the selector for the node whose children are to be loaded.
	parid - the database id of the node whose children are to be loaded.
	refresh - 1 = data must be fetched from server directly, because it was just updated.

Method - compute the target URL and use jQuery .ajax function to send the request.  The rendering of the data is handled in the ajax success function.  The error function handles cache misses, and final errors.
*/
function loadhuamakecomments( target, parid, refresh ) {
	var myurl = "./app/huamakecommentsxmlout.php" + "?cstart=0&cend=10&parent=" + parid;
	var pnode = target;
	var expanded = $(target).attr( 'myexpnd' );
	var ctcursor;
	var cstart;
	var cend;
	var cinc;
	var ccurrent;
	var tsectionno = "";
	var urlstotry = new Array();
	var myurl;
	var showall = getqstringvalue( "showall" );

	if( expanded == "1" ) {
		styleexpanders();
		return;
	}
	$(target).attr( 'myexpnd', '1' );
	// get and set cursor position for this element
	ctcursor = $(target).attr( 'ctcursor' );
	cstart = getctcursorvalue( "cstart", ctcursor );
	cend = getctcursorvalue( "cend", ctcursor );
	if( cstart == 0 || cend == 0 ) {
		//use defaults
		cstart = 1;
		cend = 10;
		cinc = 10;
		ctcursor = "cstart-" + cstart + "-cend-" + cend + "-";
		$(target).attr( 'ctcursor', ctcursor );
	}
	ccurrent = cstart;
	tsectionno = $(target).attr( 'sectionno' );
	if( tsectionno == undefined ) {
		tsectionno = "";
	} else {
		tsectionno += ".";
	}
	if( target != "#commentbox" ) {
		target += "-100";
	}
	if( $( "#workingonit" ).length == 0 ) {
		$( '<div id="workingonit" ></div>' ).appendTo( "body" );
	}
	var randomnumber=Math.floor(Math.random()*100001);
	var myversion = "version=" + randomnumber;  // get IE not to cache
	var cachedir = ( showall.length > 4 )? "adminlist" : "list";
	myurl = "./cache/" + cachedir + "/" + parid + "_" + (cstart - 1) + "_" + (cend - 1) + ".xml?" + myversion;
	urlstotry[0] = myurl;
	myurl = "./app/huamakecommentsxmlout.php" + "?cstart=" + cstart + "&cend=" + cend + "&parent=" + parid + "&" + myversion + "&showall=" + showall;
	urlstotry[1] = myurl;
	var i, success;
	var i = 0;
	if( refresh ) {
		i = 1; //skip cache
	}
	success = 0;
	var successfunc = function (data) {
				//alert( data );
				//var tdata = "<r><item>data</item></r>";
				//var itemno = $( tdata ).find( 'item' ).length;
				//var commno = $("comment", data).length;
				$( data )
				.find( "comment" )
				.each( function () { 
					target = paintcommentrow( target, $(this), pnode, tsectionno + ccurrent ); 
					++ccurrent; 
				} );
				target = paintactionrow( target, "", pnode );
				$( "#commentbox" ).treeTable( {initialState:"collapsed"});
				if( parid == 0 ) {
					//loadhuamakecomments("#cb-node-2", 2 );
					var captchaq = $( data ).find( "pcaptcha" ).text();
					$( "#commentbox" ).append('<span class="captchaq" style="display:none">' + captchaq + '</span>' );
				} else {
					expandup (pnode );//toggleBranch();
				}
				$( ".collapsed" ).each( function () {
						var pid = "#" + $(this).attr( 'id' );
						var mid = pid.substr( 9 );
						$(this)
						.find( ".expander" )
						.click( function(){ loadhuamakecomments( pid, mid, 0 ); } ); 
					} );
				styleexpanders();
				$( "#workingonit" ).remove();
				return true;
			};
	var errfunc = function () { 
			if( i < urlstotry.length ) {
				++i;
				// data is not in cache, try to get it from PHP code
				var pthis = this;
				//alert( successfunc );
				$.ajax( {
				url : myurl,  //urlstotry[++i], 
				error: errfunc, 
				success: successfunc } 
					, "xml" );
				// setTimeout( function() { loadhuamakecomments( target, parid, 0) ; }, 60000 ); // hack for cases where call to the success function is missed; try again in a minute
			} else {
				$( "#workingonit" ).remove();
				displayerror( "network error" ); 
			}
			return true;
		};
	$.ajax( {
		url: urlstotry[ i++ ],
		error: errfunc,
		success: successfunc
		}, "xml" );
}
