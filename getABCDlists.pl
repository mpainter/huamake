#!/bin/perl  

open(SURVEY,"HSK_Vocabulary_List.html") || die "no vocabulary list";
$sep = "\t";
$ordinal = 1;
$total = 0;
$argc = @ARGV;
$section = "";

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
	$tmp = convertutf8($_);
	$tmp =~ s/^<BR>(\d\d\d\d) (%u[A-F0-9]*) (%u.*)//;
	if( length( $tmp ) < length( $_ ) ) {
		$itemno = $1;
		$list = $2;
		$chars = $3;
		#$lists{ $list } = 1;
		#print "Item number: $itemno List: $list Word: $chars\n";
		while( length( $chars ) > 0 ) {
			$tmp = $chars;
			$tmp =~ s/(%u[A-F0-9][A-F0-9][A-F0-9][A-F0-9])//;
			if( length($tmp) < length($chars) ) {
				#print "$1\n";
				$tmp2 = $charlist{ $1 };
				$tmp3 = $1;
				if( length( $tmp2  ) <= 0 || $list eq "%u7532" ) {
					$charlist{ $tmp3 } = $list;
					#print "1 $tmp2 $list\n";
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
				$chars = $tmp;
			} else {
				#print "unexpected: $chars\n";
				$chars = "";
			}
		}
	} else {
		#print "$lines: $tmp\n";
	}
}
foreach $val (keys %lists ) {
	print unescape("<h2>$val ($lists{ $val }):</h2>\n");
	$cnt = 0;
	foreach $char (keys %charlist ) {
		if( $lists{$val} eq $charlist{$char} ) {
			print "<a href=\"web2_0.htm?theChar=$char\">" . unescape("<span class=\"hskchar\">$char</span>") . "</a>\n";
			$cnt++;
		}
	}
	print "<p>Count: $cnt</p>\n";
}
close( SURVEY );
print "</body></html>\n";

