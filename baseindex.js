
/* Copyright 2010, 2011 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included.

Definition and pronounciation data is from CC-CEDICT (http://usa.mdbg.net/chindict/chindict.php?page=cedict) which is licensed under a Creative Commons Attribution Share-Alike 3.0 License.  So, anyone may use data I have derrived under that same license, provided attribution is given, and the resulting work uses the same license. 
*/


var tclosecount = 0;
var tclosedata;
var tclosedbcount = 6;

var demoanimationsteps = new Array();
demoanimationsteps[0] = { id1: "#noelement", id1class: "animtext", id2: "#catanim1", id2cont: ".fragpicker"};
demoanimationsteps[1] = { id1: "#i_5343_1", id1class: "animtext", id2: "#catanim2", id2cont: ".fragpicker" };
demoanimationsteps[2] = { id1: "#u5341", id1class: "animtext", id2: "#catanim3", id2cont: ".fragpicker" };
demoanimationsteps[3] = { id1: "#u53E3", id1class: "animtext", id2: "#catanim4", id2cont: ".fragpicker" };

var demo2animationsteps = new Array();
demo2animationsteps[0] = { id1: "#u53E3", id1class: "animtext", id2: "#demoanim1", id2cont: ".fragpicker",
action: function () { demoanimationsteps.active = false; }};
demo2animationsteps[1] = { id1: "#noelement", id1class: "animtext", id2: "#demoanim1", id2cont: ".fragpicker",
action: function () { getcomponentdetails( relcomp_u53E3 ); }};
demo2animationsteps[2] = { id1: "#fragback", id1class: "animtext", id2: "#demoanim2", id2cont: ".fragpicker" };
demo2animationsteps[3] = { id1: "#u5341", id1class: "animtext", id2: "#demoanim3", id2cont: ".fragpicker"};
demo2animationsteps[4] = { id1: "#noelement", id1class: "animtext", id2: "#demoanim4", id2cont: "#bicharlist",
action: function() {getcomponentdetails( relcomp_u5341 );}  };
demo2animationsteps[5] = { id1: "#u7530_li", id1class: "animtext", id2: "#demoanim4", id2cont: "#bicharlist" };
demo2animationsteps[6] = { id1: "#u7530_li", id1class: "animtext", id2: "#demoanim4", id2cont: "#bicharlist",
action: function() {window.location='http:./home.htm?thePage=web2_0new&godeep=on&theChar=%u7530&demo=1';} };


function tclosemark( cname, node ) 
{
	var nodeid = node.attr( 'id' ).replace( /u/, "%u" ).replace( /_li/, "" );
	if( tclosedbcount == 2 ) {
		alert( "1:" + nodeid + ":" + cname );
		++tclosedbcount;
	}
	if( tclosedata[ nodeid ] != undefined ) {
		if( tclosedbcount == 3 ) {
			alert( "2" + nodeid + ":" + cname );
			++tclosedbcount;
		}
		node.addClass( cname );
		if( tclosedbcount == 4 ) {
			alert( "3" + nodeid + ":" + cname );
			++tclosedbcount;
		}
	}
}

function tcloseloaddata( cname, node )
{
	if( tclosedbcount == 0 ) {
		alert( node.text() + ":" + cname );
		++tclosedbcount;
	}
	tclosedata[ node.text() ] = cname;
	if( tclosedbcount == 1 ) {
		alert( "after tclosedata" );
		++tclosedbcount;
	}
}

function tcloseerror()
{
	--tclosecount;
}

function getpossiblecharlist( cname, ctofetch )
{
	var myurl;
	++tclosecount;
	myurl = ctofetch;
	if( myurl.charAt( 0 ) == '%' ) {
		myurl = myurl.substr( 1 );
	}
	myurl = "./" + myurl + "_c.xml";
	$.ajax( {
		url: myurl,
		error: tcloseerror,
		success: function (data) {
				--tclosecount;
				$( data )
				.find( "elementcharlist" )
				.children()
				.each( function () { tcloseloaddata( cname, $(this) ); } );
				if( true ) { //tclosecount == 0 ) {
					$( "#bicharlist" ).find( ".listchar").hide();
					$( "#bicharlist" ).find( ".listchar").each( function () {
						tclosemark( cname, $(this) )
					});
					$( "." + cname ).show();

				}
			}
		});
}

function gotocomp( cm )
{
	window.location = "./web2_0.htm?theChar=" + cm + "&godeep=on";
}

function getcomponentdetails( relcomp ) {
	demoanimationsteps.active = false;  // turn off demo
	$( "#workingonit" ).show();
	if(  $( "#bicharlist" ).find( ".listchar").length  > 0 ) {
		// compute the intersection with current characters
		tclosedata = new Array();
		tclosecount = relcomp.length;
		for( i = 0 ; i < relcomp.length ; ++i ) {
			getpossiblecharlist( relcomp[0].replace( /_/g, "-").replace( /%/g, ""), relcomp[i] );
		}
		setTimeout( function(){ $("#workingonit").hide() }, 5000 );
		return true;
	}
var hdr = new Array();
var endtag = new Array();
var targ = new Array();
placeholders = "<span>";
//alert( relcomp.length );
for( i = 0 ; i < relcomp.length ; ++i ) {
	etag = '<span id="charlist' + (i + 1) + '" ></span>';
	placeholders += etag;
	hdr[i] = "";
}
placeholders += "</span>";
//alert( placeholders );
changecur( "bicharlist", placeholders );
hdr[0] = '&nbsp;&nbsp;<b>If it is, or contains, one of these, click on it and explore:</b>&nbsp;';
for( ix = 0 ; ix < relcomp.length ; ++ix ) {
	targ[ix] = "charlist" + (ix + 1);
	endtag[ix] = "<br/>";
	//alert( targ );
	safename = relcomp[ix];
	if( safename.charAt( 0 ) == '%' ) {
		safename = safename.substr( 1 );
		imgn = unescape( relcomp[ix] );
	} else {
		imgn = '<img src="./' + relcomp[ix] + '.bmp" />';
	}
	hdr[ix] += '<button dojoType="dijit.form.ToggleButton" unchecked iconClass="digitCheckBoxIcon" id="' + relcomp[ix] + '2" onClick="gotocomp( \'' + relcomp[ix] + '\' )"><span class="hskchar">'+ imgn + '</span></button>';
	getcontainedinlinks( relcomp[ix], hdr[ix], endtag[ix], targ[ix] );
	//alert( relcomp[ix] + ":" + relcomp.length );


}
	$( ".huaheading" ).replaceWith( '<h1 class="huaheading" >Click on another graphic element to refine your search:</h1>' );
	// kind of a kludge, but IE seems to have timing problems
	setTimeout( function() {$( "#fragpick" ).buttonset();}, 1000 ); 

	setTimeout( function(){ $("#workingonit").hide() }, 5000 );
}

function bireset() 
{
	window.location = "./home.htm";
}

function starthuademo()
{

	//getcomponentdetails( relcomp_u53E3 );
	demo2animationsteps.active = true;
	animatedemo( -1, demo2animationsteps, 5000 );
}
