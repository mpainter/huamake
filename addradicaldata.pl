#!/bin/perl  

#open(SURVEY,"cedict_ts.u8.txt") || die "no dictionary";
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

sub addcontains {
	$uni = $_[0];
	print $_[0] . " addcontains\n";
	if ( open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . ".xml") ) {
		$str = "";
		while(<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} else {
		$str = "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementlist><def> ??</def><pro>??</pro></elementlist>";
		print "new entry:" . $uni . $str . "\n";
	}
	open( NEWXMLFILE, ">" . "c:\\mark\\tmp\\" . $uni . ".xml" ) || die "open failed.\n";
	foreach $Uni ( @ARGV ) {
		$elem = "<elementid>%$uni</elementid>";
		if( !($str =~ /$elem/) ) {
			$str =~ s/<\/elementlist>/$elem<\/elementlist>/;
		}
	}
	if( length( $str ) > 0 ) {
		#print "here\n";
		print NEWXMLFILE  $str . "\n";
	}
	close( NEWXMLFILE );
}

sub addcontained {
	print $_[0] . $_[1] . "contained\n";
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
	if ( open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . $ext . ".xml") ) {
		$str = "";
		while(<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} else {
		$str = "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementcharlist></elementcharlist>";
		print "new list:" . $uni . $str . "\n";
	}
	print "contained:" . $ch;
	if( $ch =~ /^u/ ) {
		$uni2 = "%" . $ch;
	} elsif ( $ch =~ /^i_/ ) {
		$uni2 = $ch;
	} else {
		print "bad name format\n";
		return;
	}
	print "here2\n";
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
$target = "";
foreach( @ARGV ) {
	#print $_;
	++$lines;
	if( $lines eq 1 ) {
		$target = $_;
		addcontains( $_ );
	} else {
		addcontained( $_, $target );
	}
	print "target: $target\n";
 }
#close( SURVEY );

