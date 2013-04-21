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

open( CDICT, "cedict_ts.u8" ) || die "No dictionary.";

$difcnt = 0;
while( <CDICT> ) {
	$cline = convertutf8( $_ );
	@FIELDS = split( /\s+/, $cline );
	if( $FIELDS[0] =~ /%u/ && $FIELDS[0] ne $FIELDS[1] ) {
		if( length( $FIELDS[0] ) < 7 && length( $FIELDS[1] ) < 7 ) {
			++$difcnt;
			#print "$FIELDS[0]:$FIELDS[1]\n";
			$simptotrad{ $FIELDS[1] } = $FIELDS[0];
			$tradtosimp{ $FIELDS[0] } = $FIELDS[1];
		}
	} elsif ( length( $FIELDS[0] ) < 7 && $FIELDS[0] eq $FIELDS[1] ) {
		$simpequal{ $FIELDS[1] } = 1;
	}
}
close( CDICT );
print "var simptotrad = new Array();\n";
foreach $key (sort (keys %simptotrad)) {
	if( $simpequal{ $key } != 1 ) {
		print unescape( "simptotrad[ \"$key\" ] = \"$simptotrad{ $key }\";\n" );
	}
}
print "var tradtosimp = new Array();\n";
foreach $key (sort (keys %tradtosimp)) {
	print unescape( "tradtosimp[ \"$key\" ] = \"$tradtosimp{ $key }\";\n" );
}

print "// Differences: $difcnt\n";