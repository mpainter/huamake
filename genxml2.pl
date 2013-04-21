#!/bin/perl  

open(SURVEY,"cedict_ts.u8.txt") || die "no dictionary";
$sep = "\t";
$ordinal = 1;
$total = 0;
$argc = @ARGV;
$section = "";


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
while( <SURVEY> ) {
	++$lines;
        #@Fields = split( /\[/, $_);
        #for( $i = 0 ; $i < @Fields ; ++$i ) {
               #print $i . ": " . $Fields[$i] . "\n";
        #}
	$tmp = convertutf8($_);
	$tmp =~ s/^(.*)[\s\?](.*)[\s\?]\[([\sa-zA-Z\d]*)\](.*)//;
	if( length( $tmp ) < length( $_ ) ) {
		$charcode = $2;
		$pronounce = $3;
		$def = $4;
		$def =~ s/\//, /g;
		$def =~ s/^\s*,//;
		$def =~ s/,\s*$//;
		$containslist = $charcode;
		if( $counts{ $charcode } > 0 ) {
			$divider = " :: ";
		} else { 
			$divider = "";
		}
		$defs{ $charcode } .= $divider . $def;
		$pros{ $charcode } .= $divider . $pronounce;
		$counts{ $charcode } += 1;
		$containslist =~ s/%//;
		$containedinlist = $containslist . "_l.xml";
		$containslist .= ".xml";
		if( 1 == 0 && length( $charcode ) eq 6 ) {
			open( CONTAINS, ">" . $containslist );
			print CONTAINS "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementlist><def>" . $def . "</def><pro>" . $pronounce . "</pro><elementid>" . $charcode . "</elementid></elementlist>\n\n";
			close( CONTAINS );

			open( CONTIN, ">" . $containedinlist );
			print CONTIN "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementcharlist><elementchar>" . $charcode . "</elementchar></elementcharlist>\n\n";
			#print "Simplified: " . $2 . "\nPronounciation: " . $3 . "\nDefinition: " . $4 . "\n";
			close( CONTIN );
		}
	}
}
close( SURVEY );
$linecnt = 0;
foreach $charcode (keys %counts) {
	if( $counts{ $charcode } > 1 && length( $charcode ) eq 6 ) {
		$linecnt++;
		$uni = $charcode;
		$uni =~ s/%//;
		if ( open( XMLFILE, "c:\\mark\\tmp\\" . $uni . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $uni . ".xml") ) {
			$str = "";
			while (<XMLFILE>) {
				$str .= $_;
			}
			close( XMLFILE );
			open( NEWXMLFILE, ">" . "c:\\mark\\tmp\\" . $uni . ".xml" ) || die "open failed.\n";
			$str =~ s/<def>.*<\/def>/<def>$defs{$charcode}<\/def>/;
			$str =~ s/<pro>.*<\/pro>/<pro>$pros{$charcode}<\/pro>/;
			if( length( $str ) > 0 ) {
				#print "here\n";
				print NEWXMLFILE  $str . "\n";
			}
			close( NEWXMLFILE );
		}
		#print "$charcode <?xml version=\"1.0\" encoding=\"utf-8\"?><elementlist><def>" . $defs{ $charcode } . "</def><pro>" . $pros{ $charcode } . "</pro><elementid>" . $charcode . "</elementid></elementlist>\n\n";

	}
}
print $linecnt;

