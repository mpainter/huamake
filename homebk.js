/* Copyright 2010 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included.

Definition and pronounciation data is from CC-CEDICT (http://usa.mdbg.net/chindict/chindict.php?page=cedict) which is licensed under a Creative Commons Attribution Share-Alike 3.0 License.  So, anyone may use data I have derrived under that same license, provided attribution is given, and the resulting work uses the same license. 
*/

var huamake = {
	initedPages : {
		"home" : 1
	},
	ajaxcalls : 0,
	oldajaxcalls : 0,
	loadingpage : "",
	fetchedscripts : {
		"home.js" : 1
	},
	watchdog : function () {
		if( huamake.ajaxcalls > 0 && huamake.ajaxcalls == huamake.oldajaxcalls ) {
			huamake.sequence();
		}
		huamake.oldajaxcalls = huamake.ajaxcalls;
		setTimeout( huamake.watchdog, 1000 );
	},
	fetchscript : function ( myscript ) {
		if( huamake.fetchedscripts[ myscript ] == undefined ) {
			$.getScript( myscript, function ( myscript ) { huamake.fetchedscripts[ myscript ] = 1; } );
		} else {
			huamake.sequence();
			return false;
		}
		return( true );
	},
	sequence : function () {
		var thePage = huamake.loadingpage;
		if( huamake.loadingpage == "web2_0new" ) {
				huamake.ajaxcalls -= 1;
				if( huamake.ajaxcalls == 2 ) {
					huamake.fetchscript( "./web2_0.js" ); 
				}
				if( huamake.ajaxcalls == 1 ) {
					$( "#onechar" ).load( "./" + thePage + ".htm" );
				}
				if( huamake.ajaxcalls == 0 && huamake.initedPages[ "web2_0new" ]  == undefined && initpage != undefined ) { 
					$( ".othercomplist").css( "height", "600px" );
					initpage(); 
					huamake.initedPages[ "web2_0new" ] = 1;
				} 
		} else if ( huamake.loadingpage == "hancharconvertnew" ) {
				huamake.ajaxcalls -= 1;
				//alert( huamake.ajaxcalls );
				if( huamake.ajaxcalls == 1 ) {
					$( "#hancharconvert" ).load( "./" + thePage + ".htm" );
				}
				if( huamake.ajaxcalls == 0 && huamake.initedPages[ "hancharconvertnew" ]  == undefined  ) { 
					inithanconvert();
					huamake.initedPages[ "hancharconvertnew" ] = 1;
				} 

		} else if ( huamake.loadingpage == "baseindexnew" ) {
				huamake.ajaxcalls -= 1;
				//alert( huamake.ajaxcalls );
				if( huamake.ajaxcalls == 1 ) {
					$( "#baseindex" ).load( "./" + thePage + ".htm" );
				}
				if( huamake.ajaxcalls == 0 && huamake.initedPages[ "baseindexnew" ]  == undefined  ) { 
					//$("button").button();
					$( "#fragpick" ).buttonset();
					// kind of a kludge, but IE seems to have timing problems
					setTimeout( function() {$( "#fragpick" ).buttonset();}, 1000 ); 
					huamake.initedPages[ "baseindexnew" ] = 1;
					var pos = $("#fragpick").position();
					var fpwidth = $(".fragpicker").width() + 10;
					$( "#bicharlist" ).css( { position:'absolute', top : pos.top, left : fpwidth } );
					$( "#fragback" ).button( "disable" );
				} 
		} else if ( huamake.loadingpage == "1to6Listsnew" ) {
				huamake.ajaxcalls -= 1;
				//alert( huamake.ajaxcalls );
				if( huamake.ajaxcalls == 1 ) {
					$( "#newhsk" ).load( "./" + thePage + ".htm" );
				}
				if( huamake.ajaxcalls == 0 && huamake.initedPages[ "1to6Listsnew" ]  == undefined  ) { 
					huamake.initedPages[ "1to6Listsnew" ] = 1;
				} 
		} else if ( huamake.loadingpage == "huamakefaqnew" ) {
				huamake.ajaxcalls -= 1;
				//alert( huamake.ajaxcalls );
				if( huamake.ajaxcalls == 1 ) {
					$( "#faq" ).load( "./" + thePage + ".htm" );
				}
				if( huamake.ajaxcalls == 0 && huamake.initedPages[ "huamakefaqnew" ]  == undefined  ) { 
					huamake.initedPages[ "huamakefaqnew" ] = 1;
				} 
		} else if ( huamake.loadingpage == "ABCDListsnew" ) {
				huamake.ajaxcalls -= 1;
				//alert( huamake.ajaxcalls );
				if( huamake.ajaxcalls == 1 ) {
					$( "#oldhsk" ).load( "./" + thePage + ".htm" );
				}
				if( huamake.ajaxcalls == 0 && huamake.initedPages[ "ABCDListsnew" ]  == undefined  ) { 
					huamake.initedPages[ "ABCDListsnew" ] = 1;
				} 
		} else if ( huamake.loadingpage == "radicalfrequencyDnew" ) {
				huamake.ajaxcalls -= 1;
				//alert( huamake.ajaxcalls );
				if( huamake.ajaxcalls == 1 ) {
					$( "#components" ).load( "./" + thePage + ".htm" );
				}
				if( huamake.ajaxcalls == 0 && huamake.initedPages[ thePage ]  == undefined  ) { 
					huamake.initedPages[ thePage ] = 1;
				} 
		}
		return true;

	},
			
	changetab : function ( event, ui) {
		var thePage;
		switch ( ui.index ) {
			case 0:
				thePage = "baseindexnew";
				if( huamake.initedPages[ thePage ] == undefined ) {
					huamake.loadpage( thePage );
				} 
				$( ".pagecontainer" ).hide();
				$( "#baseindex" ).show();
				break;
			case 1:
				thePage = "web2_0new";
				if( huamake.initedPages[ thePage ] == undefined ) {
					huamake.loadpage( thePage );
				} else {
					$( ".othercomplist").css( "height", "600px" );
					initpage();
				}
				$( ".pagecontainer" ).hide();
				$( "#onechar" ).show();
				break;
			case 2:
				thePage = "1to6Listsnew";
				//alert( huamake.initedPages[ thePage ] );
				if( huamake.initedPages[ thePage ] == undefined ) {
					//alert( "here" );
					huamake.loadpage( thePage );
				}
				$( ".pagecontainer" ).hide();
				$( "#newhsk" ).show();
				break;
			case 3:
				thePage = "ABCDListsnew";
				//alert( huamake.initedPages[ thePage ] );
				if( huamake.initedPages[ thePage ] == undefined ) {
					//alert( "here" );
					huamake.loadpage( thePage );
				}
				$( ".pagecontainer" ).hide();
				$( "#oldhsk" ).show();
				break;
			case 4:
				thePage = "radicalfrequencyDnew";
				//alert( huamake.initedPages[ thePage ] );
				if( huamake.initedPages[ thePage ] == undefined ) {
					//alert( "here" );
					huamake.loadpage( thePage );
				}
				$( ".pagecontainer" ).hide();
				$( "#components" ).show();
				break;
			case 5:
				thePage = "hancharconvertnew";
				//alert( huamake.initedPages[ thePage ] );
				if( huamake.initedPages[ thePage ] == undefined ) {
					//alert( "here" );
					huamake.loadpage( thePage );
				}
				$( ".pagecontainer" ).hide();
				$( "#hancharconvert" ).show();
				break;
			case 6:
				thePage = "huamakefaqnew";
				//alert( huamake.initedPages[ thePage ] );
				if( huamake.initedPages[ thePage ] == undefined ) {
					//alert( "here" );
					huamake.loadpage( thePage );
				}
				$( ".pagecontainer" ).hide();
				$( "#faq" ).show();
				break;
			default:
				return false;
		}
		return true;
	},
	loadpage : function ( thePage ) {
		huamake.loadingpage = thePage;
		if( thePage == "web2_0new" ) {
			huamake.ajaxcalls = 5;
			huamake.fetchscript( "./web2_0util.js" );
                	huamake.fetchscript( "./pinyinmarks.js" );
			huamake.fetchscript( "./hancharfunc.js" );
		} else if ( thePage == "hancharconvertnew" ) {
			//alert( "there" );
			huamake.ajaxcalls = 2;
			huamake.fetchscript( "./hancharfunc.js" ); 
		} else if ( thePage == "baseindexnew" ) {
			huamake.ajaxcalls = 3;
			huamake.fetchscript( "./web2_0util.js" );
                	huamake.fetchscript( "./baseindex.js" );
		} else if ( thePage == "1to6Listsnew" ) {
			/* no-op, use iframe instead
			huamake.ajaxcalls = 3;
			huamake.fetchscript( "./pinyinmarks.js" );
                	huamake.fetchscript( "./floatingdef.js" );
			*/
			$( '<iframe src="./1to6Listsnew.htm" width="100%" scrolling="auto" height="600">可惜你没有iframe阿.</iframe>' ).appendTo( "#newhsk" );
			huamake.initedPages[ thePage ] = 1;
		} else if ( thePage == "huamakefaqnew" ) {
			huamake.ajaxcalls = 2;
			huamake.fetchscript( "./pinyinmarks.js" );
		} else if ( thePage == "ABCDListsnew" ) {
			/* no-op, use iframe instead
			huamake.ajaxcalls = 2;
			huamake.fetchscript( "./pinyinmarks.js" );
			*/
			$( '<iframe src="./ABCDListsnew.htm" width="100%" scrolling="auto" height="600">可惜你没有iframe阿.</iframe>' ).appendTo( "#oldhsk" );
			huamake.initedPages[ thePage ] = 1;
		} else if ( thePage == "radicalfrequencyDnew" ) {
			/* no-op, use iframe instead
			huamake.ajaxcalls = 2;
			huamake.fetchscript( "./pinyinmarks.js" );
			*/
 			$( '<iframe src="./radicalfrequencyDnew.htm" width="100%" scrolling="auto" height="600">可惜你没有iframe阿.</iframe>' ).appendTo( "#components" );
			huamake.initedPages[ thePage ] = 1;
		} else {
			return;
		}

	}
};

function texttosimp()
{

	textnode = document.getElementById( "usertext" );
	if( textnode ) {
		textnode.value = converttrad( textnode.value );
	}
}

function texttotrad()
{

	textnode = document.getElementById( "usertext" );
	if( textnode ) {
		textnode.value = convertsimp( textnode.value );
	}
}
