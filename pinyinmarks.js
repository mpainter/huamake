/* Copyright 2009 Mark Painter, permission to use for non-commercial purposes granted, provided this notice is included.

Definition and pronounciation data is from CC-CEDICT (http://usa.mdbg.net/chindict/chindict.php?page=cedict) which is licensed under a Creative Commons Attribution Share-Alike 3.0 License.  So, anyone may use data I have derrived under that same license, provided attribution is given, and the resulting work uses the same license. 
*/

var pinyin_map = new Array();
pinyin_map[ "a" ] ="aāáǎàa";
pinyin_map[ "e" ] ="eēéěèe";
pinyin_map[ "i" ] = "iīíǐìi";
pinyin_map[ "o" ] = "oōóǒòo";
pinyin_map[ "u" ] = "uūúǔùu";
pinyin_map[ "v" ] = "üǖǘǚǜü";
pinyin_map[ "A" ] = pinyin_map[ "a" ];
pinyin_map[ "E" ] = pinyin_map[ "e" ];
pinyin_map[ "I" ] = pinyin_map[ "i" ];
pinyin_map[ "0" ] = pinyin_map[ "o" ];
pinyin_map[ "U" ] = pinyin_map[ "u" ];
pinyin_map[ "V" ] = pinyin_map[ "v" ];

function wordtopinyin( word )
{
	if( word.length < 1 ) {
		return "";
	}
	tone = 0;
	lastcharpos = word.length;
	lastchar = word.charAt( lastcharpos - 1 );
	if( lastchar == "1" ) {
		tone = 1;
		--lastcharpos;
	} else if ( lastchar == "2" ) {
		tone = 2;
		--lastcharpos;
	} else if ( lastchar == "3" ) {
		tone = 3;
		--lastcharpos;
	} else if ( lastchar == "4" ) {
		tone = 4;
		--lastcharpos;
	} else if ( lastchar == "5" ) {
		tone = 5;
		--lastcharpos;
	}
	rval = "";
	tonemapped = 0;
	//alert( "chin:" + word )
	for( k=0 ; k < lastcharpos ; ++k ) {
		chin = word.charAt( k );
		if( (pinyin_map[ chin ] != undefined ) && (tonemapped == 0) ) {
			//alert( tonemapped + chin );
			if( k != 0 || tone != 0 ) {
				//don't alter v, if it is the first character
				chout = pinyin_map[ chin ].charAt( tone );
			} else {
				chout = chin;
			}
			tonemapped = 1;
		} else {
			chout = chin;
		}
		rval += chout;
	}
	//alert( "chout:" + rval );
	return( rval );
}

function strtopinyin( mystr )
{
	//alert( "strtopinyin" );
	if( mystr.length < 1 ) {
		return "";
	}
	nextalpha = 0;
	nextwhite = 0;
	current = 0;
	rval = "";
	max = mystr.length;
	for( ; current < max ; ) {
		chin = mystr.charAt( current );
		if( ( chin >= 'a' && chin <= 'z' ) || ( chin >= 'A' && chin <= 'Z' ) ) {
			nextalpha = current;
			for( ; current < max && (( chin >= 'a' && chin <= 'z' ) || ( chin >= 'A' && chin <= 'Z' )) ;  ) {
				++current;
				chin = mystr.charAt( current );
			}
			if( chin >= '0' && chin <= '5' ) {
				++current;
			}
			nextwhite = current;
			//alert( mystr.substr( nextalpha, nextwhite - nextalpha - 1 ) );
			//alert( mystr.charAt( current ) );
			rval += wordtopinyin( mystr.substr( nextalpha, nextwhite - nextalpha ) );
		} else {
			rval += chin;
			++current;
		}
	}
	return( rval );

}