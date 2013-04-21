#!/bin/perl  

open(SURVEY,"HSK_Vocabulary_List.html") || die "no vocabulary list";
$sep = "\t";
$ordinal = 1;
$total = 0;
$argc = @ARGV;
$section = "";
$containedin{ "a" } = [ "a" ];
$contains{ "a" } = [ "a" ];
$alternatechars{ "%uF9D1" } = "%u516D";
$alternatechars{ "%u784F" } = "%u7814";
$alternatechars{ "%uF9E0" } = "%u6613";
$alternatechars{ "%u67FB" } = "%u67E5";
$alternatechars{ "%u7575" } = "%u753B";
$alternatechars{ "%u7501" } = "%u74F6";
$alternatechars{ "%u6DF8" } = "%u6E05";
$alternatechars{ "%u9751" } = "%u9752";
$alternatechars{ "%u9EBD" } = "%u4E48";
$alternatechars{ "%u654E" } = "%u6559";
$alternatechars{ "%u8C4A" } = "%u4E30";
$alternatechars{ "%u69EA" } = "%u6982";
$alternatechars{ "%u771E" } = "%u771F";
$alternatechars{ "%u5F8C" } = "%u540E";
$alternatechars{ "%u5436" } = "%u54EA";
$alternatechars{ "%u6669" } = "%u665A";
$alternatechars{ "%uF966" } = "%u590D";
$alternatechars{ "%uF92F" } = "%u52B3";
$alternatechars{ "%u5E47" } = "%u5E2E";
$alternatechars{ "%uF997" } = "%u8054";
$alternatechars{ "%uF9B4" } = "%u9886";
$alternatechars{ "%uF9B5" } = "%u4F8B";
$alternatechars{ "%u5B34" } = "%u8D62";
$alternatechars{ "%uF9D3" } = "%u9646";
$alternatechars{ "%uF9DB" } = "%u7387";
$alternatechars{ "%uF9E4" } = "%u7406";
$alternatechars{ "%uF9FE" } = "%u8336";
$alternatechars{ "%u63F7" } = "%u63D2";
$alternatechars{ "%u9ED9" } = "%u9ED8";
$alternatechars{ "%u537D" } = "%u5373";
$alternatechars{ "%u751B" } = "%u751C";
$alternatechars{ "%u7523" } = "%u4EA7";
$alternatechars{ "%u7D76" } = "%u7EDD";
$alternatechars{ "%u5024" } = "%u503C";
$alternatechars{ "%u7DD6" } = "%u7EEA";
$alternatechars{ "%u8EB1" } = "%u8EB2";
$alternatechars{ "%u5861" } = "%u586B";
$alternatechars{ "%u65E3" } = "%u65E2";
$alternatechars{ "%u9B2A" } = "%u6597";
$alternatechars{ "%u514E" } = "%u5154";
$alternatechars{ "%u9115" } = "%u4E61";
$alternatechars{ "%u8070" } = "%u806A";
$alternatechars{ "%u9920" } = "%u997C";
$alternatechars{ "%uF92C" } = "%u90CE";
$alternatechars{ "%uF934" } = "%u8001";
$alternatechars{ "%uF943" } = "%u5F04";
$alternatechars{ "%uF94F" } = "%u7D2F";
$alternatechars{ "%uF95C" } = "%u4E50";
$alternatechars{ "%uF973" } = "%u62FE";
$alternatechars{ "%uF99C" } = "%u5217";
$alternatechars{ "%uF99F" } = "%u70C8";
$alternatechars{ "%u5E77" } = "%u5E76";
$alternatechars{ "%uF9B6" } = "%u793C";
$alternatechars{ "%u6736" } = "%u6735";
#
$alternatechars{ "%u9E7B" } = "%u78B1";
$alternatechars{ "%u8276" } = "%u8273";
$alternatechars{ "%u5BC3" } = "%u51A4";
$alternatechars{ "%u5C19" } = "%u5C1A";
$alternatechars{ "%u613C" } = "%u614E";
#
$alternatechars{ "%u7232" } = "%u4E3A";
$alternatechars{ "%u5451" } = "%u541E";
$alternatechars{ "%u6231" } = "%u620F";
$alternatechars{ "%u98DB" } = "%u98DE";
$alternatechars{ "%u98EE" } = "%u996E";
#
$alternatechars{ "%u8846" } = "%u4F17";
$alternatechars{ "%uF90A" } = "%u91D1";
$alternatechars{ "%uF965" } = "%u4FBF";
$alternatechars{ "%uF968" } = "%u6CCC";
$alternatechars{ "%uF98C" } = "%u5386";
#
$alternatechars{ "%uF99A" } = "%u8FDE";
$alternatechars{ "%uF99D" } = "%u52A3";
$alternatechars{ "%u6F11" } = "%u6FC0";
$alternatechars{ "%uFA04" } = "%u5B85";
$alternatechars{ "%uFA09" } = "%u964D";
#
$alternatechars{ "%u93AD" } = "%u9547";
#D List starts here
$alternatechars{ "%uF9DA" } = "%u6817";
$alternatechars{ "%uF9FA" } = "%u72B6";
$alternatechars{ "%u8987" } = "%u9738";
$alternatechars{ "%u9EDE" } = "%u70B9";
#
$alternatechars{ "%u938C" } = "%u9570";
$alternatechars{ "%u5C5B" } = "%u5C4F";
$alternatechars{ "%u6961" } = "%u6986";
$alternatechars{ "%u7AC8" } = "%u7076";
$alternatechars{ "%u90DE" } = "%u90CE";
$alternatechars{ "%u985A" } = "%u98A0";
$alternatechars{ "%u6273" } = "%u6500";
$alternatechars{ "%u663B" } = "%u6602";
$alternatechars{ "%u55A9" } = "%u55BB";
#
$alternatechars{ "%u59AC" } = "%u5992";
$alternatechars{ "%uF901" } = "%u66F4";
$alternatechars{ "%uF929" } = "%u90CE";
$alternatechars{ "%uF948" } = "%u8D42";
$alternatechars{ "%uF94B" } = "%u5C61";
$alternatechars{ "%uF96B" } = "%u53C2";
$alternatechars{ "%uF990" } = "%u604B";
$alternatechars{ "%uFA08" } = "%u884C";






sub byarraysize {
	@tmparry1 = split( ":", $containedin{ $a });
	@tmparry2 = split( ":", $containedin{ $b });
	#print "$#tmparry1 $#tmparry2\n";
	return( $#tmparry2 <=> $#tmparry1 );
}

sub substitutechars {
	my( $chin, $chout );

	$chin = $_[0];
	$chout = $chin;
	if( length( $alternatechars{ $chin } ) > 0 ) {
		$chout = $alternatechars{ $chin };
		#print "sub: $chin -> $chout";
	}
	return( $chout );
}

sub substituteallchars {
	my( @str, $i );

	@str = split( "", $_[0] );
	for( $i = 0 ; $i <= $#str ; ++$i ) {
		$str[$i] = substitutechars( $str[$i] );
	}
	return( join( "", @str ) );
}

sub addusagedata {
	my( $i, $key, @tmparry, $tmpstr, $xmlstr );

	$key = $_[0];
	$xmlstr = "<usage>";
	@tmparry = split( ":", $occursin{ $key } );
	for( $i = 0 ; $i <= $#tmparry ; ++$i ) {
		$xmlstr .= "<usageel>";
		$tmpstr = uniencodetourlencode( unitogbstr(  $tmparry[$i] ) );
		if( length( $tmpstr ) > 0 ) {
			$xmlstr .= "<gb>$tmpstr</gb>";
		}
		$xmlstr .= "<uni>$tmparry[$i]</uni>"; 
		$xmlstr .= "</usageel>";
	}
	$xmlstr .= "</usage>";
	#now, should add xml string to character description
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . substr($key,1,length($key)) . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . substr($key,1,length($key)) . ".xml") ) {
		$str = "";
		while (<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
		#check if usage section already exists
		if( !($str =~ /<usage>/ ) ) {
			if( open( XMLFILE, "> c:\\mark\\tmp\\" . substr($key,1,length($key)) . ".xml") ) {
				$str =~ s/<\/pro><elementid>/<\/pro>$xmlstr<elementid>/;
				print XMLFILE $str;
				close( XMLFILE );
			}

		}
	} else {
		#print unescape( $uni ) . " $uni.xml missing\n";
	}
}

sub unitogbstr {
	my( $instr, $outstr, $str, $str1, $tmp );

	$instr = $_[0];
	#print "in string:$instr\n";
	$outstr = "";
	$str1 = $instr;
	$str = $str1;
	$str1 =~ s/(%u[A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9])//;
	$tmp = $1;
	while( $str1 ne $str ) {
		$outstr .= $unicodetogb2312{ $tmp };
		#print "$tmp:$outstr:$str1\n";
		$str = $str1;
		$str1 =~ s/(%u[A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9][A-Fa-f0-9])//;
		$tmp = $1;
	}
	return( $outstr );
	
}

sub uniencodetourlencode {
	my( $str, $i );
	$str = $_[0];
	$str1 = $str;
	$str1 =~ s/%u([A-Fa-f0-9][A-Fa-f0-9])([A-Fa-f0-9][A-Fa-f0-9])/%$1%$2/;
	while( $str1 ne $str ) {
		$str = $str1;
		$str1 =~ s/%u([A-Fa-f0-9][A-Fa-f0-9])([A-Fa-f0-9][A-Fa-f0-9])/%$1%$2/;
	}
	
	return( $str1 );
}
	

sub setoccursin {
	my( $thechar, $theword, $str );
	$thechar = $_[0];
	$theword = $_[1];
	$str = $occursin{ $thechar };
	if( length( $str ) > 0 ) {
		$str .= ":$theword";
	} else {
		$str = $theword;
	}
	#print "setoccursin: $thechar, $theword\n";
	$occursin{ $thechar } = $str;
}


sub hextobin {
	my( $rval, $curchar );
	$rval = -1;
	$curchar = substr( $_[0], 0, 1 );
	if ( $curchar =~ /[A-F]/ ) {
		$rval = ord( $curchar ) - ord( "A" ) + 10;
	} elsif ( $curchar =~ /[a-f]/ ) {
		$rval = ord( $curchar ) - ord( "a" ) + 10;
	} elsif ( $curchar =~ /[0-9]/ ) {
		$rval = ord( $curchar ) - ord( "0" ) + 0;
	} else {
	}
	return( $rval );
	
}

sub unescape {
	my( $strin, $strout, $state, $curchar, @nibbles );
	$strin = $_[0];
	$strout = "";
	$state = 0;
	while( length( $strin ) > 0 ) {
		$curchar = substr( $strin, 0, 1 );
		$strin = substr( $strin, 1, length( $strin ) );
		if ( $state == 0 ) {
			if( $curchar eq "%" ) {
				$state = 1;
			} else {
				$strout .= $curchar;
			}
		} elsif ( $state == 1 ) {
			if( $curchar eq "u" ) {
				$state = 2;
			} else {
				$state = 0;
				$strout .= "%" . $curchar;
			}
		} elsif ( $state == 2 ) {
			$nibbles[0] = $curchar;
			if( $curchar =~ /[A-Fa-f0-9]/ ) {
				$state = 3;
			} else {
				$state = 0;
				$strout .= "%u" . $curchar;
			}
		} elsif ( $state == 3 ) {
			$nibbles[1] = $curchar;
			if( $curchar =~ /[A-Fa-f0-9]/ ) {
				$state = 4;
			} else {
				$state = 0;
				$strout .= "%u" . $nibbles[0] . $curchar;
			}
		} elsif ( $state == 4 ) {
			$nibbles[2] = $curchar;
			if( $curchar =~ /[A-Fa-f0-9]/ ) {
				$state = 5;
			} else {
				$state = 0;
				$strout .= "%u" . $nibbles[0] . $nibbles[1] . $curchar;
			}
		} elsif ( $state == 5 ) {
			$nibbles[3] = $curchar;
			if( $curchar =~ /[A-Fa-f0-9]/ ) {
				$y = (hextobin( $nibbles[0] ) << 4) | hextobin( $nibbles[1]);
				$x = (hextobin( $nibbles[2] ) << 4) | hextobin( $nibbles[3]);
				$b1 = 0xe0 | ( (0xf0 & $y ) >> 4 );
				$b2 = 0x80 | ( (0x0f & $y ) << 2 ) | ( (0xc0 & $x) >> 6 );
				$b3 = 0x80 | ( (0x3f & $x ) ); 
				$strout = sprintf( "%s%c", $strout, $b1);
				$strout = sprintf( "%s%c", $strout, $b2);
				$strout = sprintf( "%s%c", $strout, $b3);
				$state = 0;
			} else {
				$state = 0;
				$strout .= "%u" . $nibbles[0] . $nibbles[1] . $nibbles[2] . $curchar;
			}
		} else {
			print "Logic error!\n";
		} 
	}
	return( $strout );
}

sub convertutf8 {
	my( $lnout, $lnin, $i, $ch );
	$lnin = $_[0];
	$lnout = "";
	$ch = 0;
	for( $i = 0 ; $i < length( $lnin ) ; ++$i ) {
		$ch = ord( substr( $lnin, $i, 1 ) );
		$str = "";
		if( ($ch & 0xf8) eq 0xf0 ) {
			# four byte character
			$tmp1 = ($ch & 0x07) << 2;
			$tmp2 = 0;
			$tmp3 = 0;
			$i++;
			$str = $ch . "";
			$ch = ord( substr( $lnin, $i, 1 ) );
			if( ($ch & 0xc0) eq 0x80 ) {
				$tmp1 |= ($ch & 0x30) >> 4;
				$tmp2 = ($ch & 0xf) << 4;
				$i++;
				$str .= $ch;
				$ch = ord( substr( $lnin, $i, 1 ) );
				if( ($ch & 0xc0) eq 0x80 ) {
					$tmp2 |= ($ch & 0x3c) >> 2;
					$tmp3 = ($ch & 3) << 6;
					$i++;
					$str .= $ch;
					$ch = ord( substr( $lnin, $i, 1 ) );
					if( ($ch & 0xc0) eq 0x80 ) {
						$tmp3 |= $ch & 0x3f;
						$str = "\%u" .sprintf( "%X", (($tmp1 << 8) | $tmp2 << 8) | $tmp3 );
					} else {
						$str .= $ch;
					}
				}else{
					$str .= $ch;
				}
			} else {
				$str .=  $ch;
				#print "str: " . sprintf( "%X", $ch ) . "\n";
			}
		} elsif( ($ch & 0xf0) eq 0xe0 ) {
			# three byte character
			$tmp1 = ($ch & 0x0f) << 4;
			$tmp2 = 0;
			$i++;
			$str = $ch . "";
			$ch = ord( substr( $lnin, $i, 1 ) );
			if( ($ch & 0xc0) eq 0x80 ) {
				$tmp1 |= ($ch & 0x3c) >> 2;
				$tmp2 = ($ch & 3) << 6;
				$i++;
				$str .= $ch;
				$ch = ord( substr( $lnin, $i, 1 ) );
				if( ($ch & 0xc0) eq 0x80 ) {
					$tmp2 |= $ch & 0x3f;
					$str = "\%u" .sprintf( "%X", ($tmp1 << 8) | $tmp2 );
					#print sprintf( "%x %x", $tmp1, $tmp2 );
				}else{
					$str .= $ch;
				}
			} else {
				$str .=  $ch;
				#print "str: " . sprintf( "%X", $ch ) . "\n";
			}
		} elsif ( ($ch & 0xe0) eq 0xc0 ) {
			# two byte character
			$tmp1 = ($ch & 0x1c) >> 2;
			$tmp2 = ($ch & 3) << 6;
			$i++;
			$str = $ch . "";
			$ch = ord( substr( $lnin, $i, 1 ) );
			if( ($ch & 0xc0) eq 0x80 ) {
				$tmp2 |= $ch & 0x3f;
				$str = "\%u" .sprintf( "%X", ($tmp1 << 8) | $tmp2 );
			} else {
				$str .=  $ch;
				#print "str: " . sprintf( "%X", $ch ) . "\n";
			}
		} else { 
			#print "ch:" . sprintf( "%X", $ch ) . "\n";
			$str = substr( $lnin, $i, 1 );
		}
		$lnout .= $str; 
		#print $i. ":" . $lnout . "\n";
	}
	
	return $lnout;
}

sub computereach {
	my( $curchar, $curlist, $startchar, $rval, $depth, $newchar, @tmparray, $maxdepth );

	$curchar = $_[0];
	$curlist = $_[1];
	$startchar = $_[2];
	$rval = 0;
	$reached{ $curchar } += 1;
	if( $curchar eq "%u6208" ) {
		#print "$curchar: $curlist\n";
	}
	if( $curlist =~ /$curchar/ ) {
		return $rval; # prevent infinite recursion
	}
	@tmparray = split( ":", $containedin{ $curchar } );
	#print "$curchar: $containedin{ $curchar } @tmparray\n";
	if( $curchar eq "%u6208" ) {
		#print "$rval: @tmparray $#tmparray\n";
	}
	foreach $newchar ( @tmparray ) {
		computereach( $newchar, $curlist . $curchar, $startchar );
		${ $closurelist{ $startchar }}{ $newchar } += 1;
	}
	if( $curchar eq "%u708E" ) {
		#print "$rval: $maxdepth\n";
	}
	return $rval;
}

sub getchardepth {
	my( $curchar, $curlist, $rval, $depth, $newchar, @tmparray, $maxdepth );

	$curchar = $_[1];
	$curlist = $_[0];
	$rval = 0;
	if( $curlist =~ /$curchar/ ) {
		return $rval; # prevent infinite recursion
	}
	@tmparray = split( ":", $contains{ $curchar } );
	#print "$curchar: $contains{ $curchar } @tmparray\n";
	if( $#tmparray > 0 || (length($tmparray[0]) > 0 && $tmparray[0] ne $curchar) ) {
		$rval = 1;
	}
	if( $curchar eq "%u708E" ) {
		#print "$rval: @tmparray $#tmparray\n";
	}
	$maxdepth = 0;
	foreach $newchar ( @tmparray ) {
		if( $newchar =~ /i_/ ) {
			#print "|$newchar|\n";
		} else {
			$depth = getchardepth( $curlist . $curchar, $newchar );
			if( $depth > $maxdepth ) {
				$maxdepth = $depth;
			}
		}
	}
	$rval += $maxdepth;
	if( $curchar eq "%u708E" ) {
		#print "$rval: $maxdepth\n";
	}
	return $rval;
}

sub getcontainedin {
	$uni = $_[0];
	#print $_[0] . " addcontains @ARGV\n";
	#print "getcontainedin $_[0]\n";
	@myargv = @ARGV;
	if( $uni =~ /^i_/ ) {
		$ext = ".xml";
	} else {
		$ext = "_l.xml";
	}
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . substr($_[0],1,length($_[0])) . $ext) || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . substr($_[0],1,length($_[0])) . $ext ) ) {
		$str = "";
		while (<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
		#extract component ids
		$tmpstr = $str;
		$tmpstr2 = $tmpstr;
		$tmpstr =~ s/<elementchar>([%_a-zA-Z0-9]*)<\/elementchar>//;
		$tmpchar = $1;
		#print $str;
		while( length( $tmpstr ) < length( $tmpstr2 ) ) {
			if( $uni ne $tmpchar && !( $contained{ $uni } =~ /$tmpchar/ ) ) {
				#print "$uni $tmpchar\n";
				$containedin{ $uni } .= "$tmpchar:";
				$contains{ $tmpchar } .= "$uni:";
			}
			$tmpstr2 = $tmpstr;
			$tmpstr =~ s/<elementchar>([%_a-zA-Z0-9]*)<\/elementchar>//;
			$tmpchar = $1;
		}
	} else {
		#print unescape( $uni ) . " $uni _l.xml missing\n";
	}
}


sub getcontains {
	$uni = $_[0];
	#print $_[0] . " addcontains @ARGV\n";
	@myargv = @ARGV;
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . substr($_[0],1,length($_[0])) . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . substr($_[0],1,length($_[0])) . ".xml") ) {
		$str = "";
		while (<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
		#extract component ids
		$tmpstr = $str;
		$tmpstr2 = $tmpstr;
		$tmpstr =~ s/<elementid>([%_a-zA-Z0-9]*)<\/elementid>//;
		$tmpchar = $1;
		#print $str;
		while( length( $tmpstr ) < length( $tmpstr2 ) ) {
			
			$containedin{ $tmpchar } .= "$uni:";
			$contains{ $uni } .= "$tmpchar:";
			#print unescape( $tmpchar );
			#@tmparry = [$containedin{ $tmpchar }];
			#push @tmparry, $uni;
			#print "@tmparry, $uni:";
			#$containedin{ $tmpchar } = [@tmparry];
			#@tmparry = [$contains{ $uni }];
			#push @tmparry, $tmpchar;
			#$contains{ $uni } = [@tmparry];
			$tmpstr2 = $tmpstr;
			$tmpstr =~ s/<elementid>([%_a-zA-Z0-9]*)<\/elementid>//;
			$tmpchar = $1;
		}
	} else {
		#print unescape( $uni ) . " $uni.xml missing\n";
	}
}

sub addcontained {
	#print $_[0] . $_[1] . "contained\n";
	$uni = $_[0];
	$ch = $_[1];
	if( $uni =~ /^u/ ) {
		$ext = "_l";
	} elsif ( $uni =~ /^i_/ ) {
		$ext = "";
	} else {
		print "bad name format\n";
		return;
	}
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . $_[0] . $ext . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . $ext . ".xml") ) {
		$str = "";
		while(<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} else {
		$str = "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementcharlist></elementcharlist>";
		#print "new list:" . $uni . $str . "\n";
	}
	#print "contained:" . $ch;
	if( $ch =~ /^u/ ) {
		$uni2 = "%" . $ch;
	} elsif ( $ch =~ /^i_/ ) {
		$uni2 = $ch;
	} else {
		print "bad name format\n";
		return;
	}
	#print "here2\n";
	$elem = "<elementchar>$uni2</elementchar>";
	if( !($str =~ /$elem/) ) {
		$str =~ s/<\/elementcharlist>/$elem<\/elementcharlist>/;
		if( $str =~ /$elem/ ) {
			#print "here\n";
			open( NEWXMLFILE, ">" . "c:\\mark\\tmp\\" . $uni . $ext . ".xml" ) || die "open failed.\n";
			print NEWXMLFILE  $str . "\n";
			close( NEWXMLFILE );
		}
	}
}
$lines = 0;
$skipthis = 0;
print "<html><head><META http-equiv=Content-Type content=\"text/html; charset=utf-8\"><title>HSK A, B, C and D lists</title><link href=\"./web2_0.css\" rel=\"stylesheet\" type=\"text/css\" />
</head><body background=\"web2_0bkg.JPG\">\n";
$lists{ "A List" } = "%u7532";
$lists{ "B List" } = "%u4E59";
$lists{ "C List" } = "%u4E19";
$lists{ "D List" } = "%u4E01";
while( <SURVEY> ) {
	++$lines;
        #@Fields = split( /\[/, $_);
        #for( $i = 0 ; $i < @Fields ; ++$i ) {
               #print $i . ": " . $Fields[$i] . "\n";
        #}
	$remline = convertutf8($_);
	$remline =~ s/<BR>(\d\d\d\d) (%u[A-F0-9]*) (%u[a-zA-Z0-9%]*)//;
	$oline = $_;
	while( length( $remline ) < length( $oline ) ) {
		$itemno = $1;
		$list = $2;
		$chars = $3;
		$ochars = substituteallchars( $chars );
		#$lists{ $list } = 1;
		#print "Item number: $itemno List: $list Word: $chars\n";
		while( length( $chars ) > 0 ) {
			$tmp = $chars;
			$tmp =~ s/(%u[A-F0-9][A-F0-9][A-F0-9][A-F0-9])//;
			if( length($tmp) < length($chars) ) {
				#print "$1\n";
				$tmp3 = substitutechars( $1 );
				$tmp2 = $charlist{ $tmp3 };
				setoccursin( $tmp3, $ochars );
				if( length( $tmp2 ) <= 0 ) {
					getcontains( $tmp3 );
				}
				if( $list ne "%u7532" && $list ne "%u4E19" && $list ne "%u4E59" && $list ne "%u4E01" ) {
					print unescape( $tmp3 ) . ":$tmp3, $list:";
				}
				if( $tmp3 eq "%u9E26" ) { 
					#print "here1 $itemno $list:";
				} 
				if( length( $tmp2  ) <= 0 || $list eq "%u7532" ) {
					$charlist{ $tmp3 } = $list;
					#print "1 $tmp2 $list\n";
					if( $tmp3 eq "%u51D6" ) { 
						#print "here3 $list:";
					} 

				} elsif ( (($tmp2 eq "%u4E01") || ($tmp2 eq "%u4E19")) && ($list eq "%u4E59") ) {
					$charlist{ $tmp3 } = $list;
					#print "2 $tmp2 $list\n";
				} elsif ( ($tmp2 eq "%u4E01") && ($list eq "%u4E19")) {
					$charlist{ $tmp3 } = $list;
					#print "3 $tmp2 $list\n";
				}  else {
					#print "$charlist{ $tmp3 }\n";
					#print "4 $tmp2 $list\n";
				}
				if( $tmp3 eq "%u51D6" ) { 
					#print "here2 $tmp3 $list:";
				} 
				$chars = $tmp;
			} else {
				#print "unexpected: $chars\n";
				$chars = "";
			}
		}
		$oline = $remline;
		$remline =~ s/<BR>(\d\d\d\d) (%u[A-F0-9]*) (%u[a-zA-Z0-9%]*)//;
	} 
}

#print ":liu " . $charlist{ "%u51D6" } . " liu:";
close( SURVEY );
open(CMAPPING,"CP936.txt") || die "no character mapping";
#load a unicode to BG2312 mapping table
while( <CMAPPING> ) {
	@fields = split( /\s+/, $_ );
	#print "$fields[0]";
	if( ! ($fields[0] =~ /#/ ) ){
		$tmp = $fields[0];
		$tmp2 = $fields[1];
		#print "$tmp2:$tmp\n";
		$tmp =~ s/0x([a-fA-F0-9]+)/%u$1/;
		$tmp2 =~ s/0x([a-fA-F0-9]+)/%u$1/;
		if( $tmp ne $fields[0] && $tmp2 ne $fields[1] ) {
			#print "$tmp2:$tmp\n";
			$unicodetogb2312{ $tmp2 } = $tmp;
		}
	}
}
close( CMAPPING ); 

foreach $val (sort (keys %lists )) {
	print unescape("<h2>$val ($lists{ $val }):</h2>\n");
	$cnt = 0;
	foreach $char (keys %charlist ) {
		if( $char eq "%u51D6" ) {
			#print "xxxxxxx";
		}
		if( $lists{$val} eq $charlist{$char} ) {
			$linkclass = "hskchar";
			@tmparry = split( ":", $containedin{ $char });
			@tmparry2 = split( ":", $contains{ $char });
			if( $#tmparry < 1 && $#tmparry2 < 1 ) {
				$linkclass = "todochar";
			} else {
				addusagedata( $char );
			}
			print "<a href=\"web2_0.htm?theChar=$char\">" . unescape("<span class=\"$linkclass\">$char</span>") . "</a>\n";
			$cnt++;
		}
	}
	print "<p>Count: $cnt</p>\n";
}
open( RADF, "> ../tmp/radicalfrequencyD.htm" ) || die "failed to open rf\n";
print RADF "<html><head><META http-equiv=Content-Type content=\"text/html; charset=utf-8\"><title>HSK Radical Usage Frequency</title><link href=\"./web2_0.css\" rel=\"stylesheet\" type=\"text/css\" />
</head><body background=\"web2_0bkg.JPG\">\n";

print RADF "<h2>Number Times Each Character Occurs as a Radical</h2>";
$linkclass = "hskchar";
$oldcnt = 0;
foreach $key (sort byarraysize (keys %containedin)) {
	@tmparry = split( ":", $containedin{ $key });
	if( $oldcnt != $#tmparry ) {
		print RADF "<BR/>$#tmparry";
	}
	if( $key =~ /^i_/ ) {
		print RADF "<a href=\"web2_0.htm?theChar=$key\">" . unescape("<span class=\"$linkclass\"><img src=\"$key.bmp\"/> </span>") . "</a>\n";
	} else {
		print RADF "<a href=\"web2_0.htm?theChar=$key\">" . unescape("<span class=\"$linkclass\">$key </span>") . "</a>\n";
	}
	$oldcnt = $#tmparry;
}
print RADF "</body></html>\n";
close( RADF );
open( HSKINDEX, "> ../tmp/HSKVocabIndex.htm" ) || die "failed to open index\n";
print HSKINDEX "<html><head><META http-equiv=Content-Type content=\"text/html; charset=utf-8\"><title>HSK Character Index</title><link href=\"./web2_0.css\" rel=\"stylesheet\" type=\"text/css\" />
</head><body background=\"web2_0bkg.JPG\">\n";

print HSKINDEX "<h2>Vocabulary Words By Character</h2>";
foreach $key (sort (keys %occursin)) {
	@tmparry = split( ":", $occursin{ $key } );
	$depth = getchardepth( "", $key );
	if( $key eq "%u708E" ) {
		#print "$key: $depth\n";
	}
	@tmparray = split( ":", $containedin{ $key } );
	print HSKINDEX unescape( "<BR/>$key ($depth,$#tmparray): " );
	for( $i = 0 ; $i <= $#tmparry ; ++$i ) {
		if( $i > 0 ) {
			print HSKINDEX ", ";
		}
		$tmpstr = uniencodetourlencode( unitogbstr(  $tmparry[$i] ) );
		if( length( $tmpstr ) > 0 ) {
			print HSKINDEX unescape( "<a href=\"http://www.learn-chinese-words.com/cgi-bin/external.cgi?extsrc=dictcn&charstring=$tmpstr\" > $tmparry[$i] </a>" );
		} else {
			print HSKINDEX unescape( "$tmparry[$i] " );
		}
	}
	print HSKINDEX "\n";
}
print HSKINDEX "</body></html>\n";
close(HSKINDEX);
print "</body></html>\n";

open( HSKINDEX, "> ../tmp/chardepthhistogram.htm" ) || die "failed to open index\n";
foreach $key (keys %charlist) {
	$depth = getchardepth( "", $key );
	if( $key eq "%u708E" ) {
		#print "$key: $depth\n";
	}
	$chardepth[ $depth ] += 1;
	@tmparray = split( ":", $containedin{ $key } );
	$charusage[ $#tmparray ] += 1;
}
for( $i = 0 ; $i < 10 ; $i++ ) {
	$j = $i + 1;
	print HSKINDEX "$i:\t$chardepth[ $i ]\t$charusage[ $i ]\n";
}
for( ; $i < 3000 ; $i++ ) {
	$sum += $charusage[ $i ];
}
print HSKINDEX "10 or more:\t0\t$sum\n";
close( HSKINDEX );	

#Check if index is complete
#First flush out intermediate characters in containedin
foreach $key (keys %charlist) {
	getcontainedin( $key );
}

open( BINDEX, "baseindex.txt" ) || die "failed to open base index\n";
open( BINDEXOUT, "> ../tmp/baseindexnew.htm" ) || die "failed to open base index output\n";
print BINDEXOUT "<html><head><META http-equiv=Content-Type content=\"text/html; charset=utf-8\"><title>Chinese Character Graphical Index</title><link href=\"./web2_0.css\" rel=\"stylesheet\" type=\"text/css\" />\n";
print BINDEXOUT "</head><body background=\"web2_0bkg.JPG\">\n<h1 class=\"huaheading\" >Click on a graphic element that looks like it belongs to the Chinese character you are looking for:</h1>";
$tablewidth=5;
$tablecols=0;
print BINDEXOUT "<span><div id=\"fragpick\" ><table class=\"fragpicker\"><tbody><tr>\n";
print BINDEXOUT "<td><button id=\"fragback\" onClick=\"bireset()\" ><span class=\"ui-icon ui-icon-arrowreturnthick-1-w\" ></span></button></td>\n";
$tablecols++;
$trailingjs = "<script language=\"javascript\" >\n";
while( <BINDEX> ) {
	@FIELDS = split( /\s/, $_ );
	for( $i = 0 ; $i <= $#FIELDS ; ++$i ) {
		$FIELDS[$i] = convertutf8( $FIELDS[$i] );
	}
	#print "$FIELDS[0]\n";
	if( !($FIELDS[0] =~ /#/ )) {
		getcontainedin( $FIELDS[0] );
		computereach( $FIELDS[0], "", $FIELDS[0] );
		$safename = $FIELDS[0];
		$safename =~ s/%//;
		$tablecols++;
		print BINDEXOUT "<td>\n";
		print BINDEXOUT "<button id=\"$FIELDS[0]\" onClick=\"getcomponentdetails( relcomp_$safename )\">\n";
		#print BINDEXOUT "<a href=\"./web2_0.htm?theChar=$FIELDS[0]&godeep=yes\">";
		if( $FIELDS[0] =~ /^i_/ ) {
			print BINDEXOUT "<span class=\"fragextrainfo\"></span><img src=\"./$FIELDS[0].bmp\" />";
		} else {
			print BINDEXOUT unescape( "<span class=\"fragextrainfo\"></span><span class=\"hskchar\">$FIELDS[0]</span>" );
		}
		print BINDEXOUT "</button></td>\n";
		if( $tablecols == $tablewidth ) {
			print BINDEXOUT "</tr><tr>\n";
			$tablecols = 0;
		}
		$trailingjs .= "relcomp_$safename = new Array();\n"; 
		$j = 0;
		for( $i = 0 ; $i <= $#FIELDS ; ++$i ) {
			@tmparray = split( ":", $containedin{ $FIELDS[$i] } );
			if( length( $tmparray[0] ) > 0 || $i > 0 ) {
				computereach( $FIELDS[$i], "", $FIELDS[$i] );
				$trailingjs .= "relcomp_$safename\[$j\] = \"$FIELDS[$i]\";\n";
				$j++;
			}
		}
	}
}
print BINDEXOUT "</tr></tbody></table></div>\n";
print BINDEXOUT "<div style=\"float:left;width:100%\" ><span id=\"bicharlist\"></span></div></span>\n";
print BINDEXOUT "$trailingjs </script>\n";
print BINDEXOUT "</body></html>\n";
close( BINDEXOUT );
close( BINDEX );
open( NOTINDEXED, "> ../tmp/notindexed.txt" ) || die "failed to open notindexed.txt\n";
foreach $key (keys %charlist) {
	if( $reached{ $key } <= 0 ) {
		print NOTINDEXED unescape( "$key\n" );
	}
}
close( NOTINDEXED );
foreach $bi (keys %closurelist ) {
	%accessable = %{ $closurelist{ $bi } };
	#
	$bi =~ s/%//;
	#
	open( CLIST, "> ../tmp/$bi" . "_c.xml" ) || die "couldn't open: ../tmp/$bi" . "_c.xml\n";
	print CLIST "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementcharlist>";
	foreach $ch (keys %accessable ) {
		print CLIST "<elementchar>$ch</elementchar>";
	}
	print CLIST "</elementcharlist>";
	close( CLIST );
}


