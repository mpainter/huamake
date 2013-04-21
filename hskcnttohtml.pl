#!/perl/bin/perl

open( MYFILE, $ARGV[0] ) || die "no file to open";

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

sub addlinks {
	my( $instr, $outstr, $tmp );

	$instr = $_[0];
	$outstr = "";
	$oldinstr = "";

	while( $instr ne $oldinstr ) {
		$oldinstr = $instr;
		$instr =~ s/(%u[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z])//;
		if( $instr ne $oldinstr ) {
			$tmp = $1;
			$outstr .= "<a href=\"./web2_0.htm?theChar=$tmp\">" . unescape( $tmp ) . "</a>";
		}
	}
	return( $outstr );
}

$linecnt = 0;

print "<html><head><META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\"><title>$ARGV[1]</title>\n<link href=\"./web2_0.css\" rel=\"stylesheet\" type=\"text/css\" />\n";
print "<script type=\"text/javascript\"><!--\ngoogle_ad_client=\"pub-6690138268530140\";\n/* 234x60, created 4/9/10 */\ngoogle_ad_slot = \"2596959366\";\ngoogle_ad_width = 234;\ngoogle_ad_height = 60;\n//-->\n</script>";

print "</head><body background=\"web2_0bkg.JPG\">\n<h1 style=\"text-align:center\">$ARGV[1]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<script type=\"text/javascript\" src=\"http://pagead2.googlesyndication.com/pagead/show_ads.js\"></script></h1>\n";
$wordhead="<span>";
$wordmiddle="&nbsp;";
$wordtail="</span><br/>";
$newhead="<img src=\"newforlevel.jpg\" />";
$newtail="";
while( <MYFILE> ) {
	@FIELDS = split( /\s+/, $_ );
	if( $FIELDS[0] eq "Page" ) {
	} elsif( $FIELDS[0] eq "-" ) {
		#print "Page $FIELDS[1]\n";
	} elsif( length( $FIELDS[1] ) == 0 ) {
	} elsif( $linecnt < 6000 ) {
		++$linecnt;
		$escaped = convertutf8( $FIELDS[1] );
		$links = addlinks( $escaped );
		$tmp2 = $wordmiddle;
		$tmp2 =~ s/_foo_/$escaped/g;
		print $wordhead . $FIELDS[0] . $tmp2 . $links;
		if( $FIELDS[2] eq "x" ) {
			print $newhead . $newtail;
		} else {
		}
		print $wordtail . "\n";
	}
}
$bodytail = open( BODYTAIL, "newHSKbodytail.txt" );
if( $bodytail ) {
	while( <BODYTAIL> ) {
		print $_;
	}
	close( BODYTAIL );
}
print "</body></html>\n";
close( MYFILE );