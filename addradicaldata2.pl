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
	my( $str, $uni, $uni2 );
	$uni = $_[0];
	print $_[0] . " addcontains @ARGV\n";
	@myargv = @ARGV;
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . $_[0] . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . ".xml") ) {
		$str = "";
		while (<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} else {
		print "Definition:";
		$def = <STDIN>;
		print "Pronounciation:";
		$pro = <STDIN>;
		$str = "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementlist><def> $def</def><pro>$pro</pro></elementlist>";
		addcontained( $uni, $uni );
		print "new entry:" . $uni . $str . "\n";
	}
	open( NEWXMLFILE, ">" . "c:\\mark\\tmp\\" . $uni . ".xml" ) || die "open failed.\n";
	foreach $uni ( @myargv ) {
		print ":$uni:";
		if( $uni =~ /^u/ ) {
			$uni2 = "%" . $uni;
		} elsif ( $uni =~ /^i_/ ) {
			$uni2 = $uni;
		} else {
			print "bad name format :$uni:\n";
			return;
		}

		$elem = "<elementid>$uni2</elementid>";
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

sub addonecontains {
# ( u<unicode for containing character>, u<unicode for contained character)
	my( $str, $uni, $uni2 );
	$uni = $_[0];
	print " addonecontains @_\n";
	@myargv = ( $_[1] );
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . $_[0] . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . ".xml") ) {
		$str = "";
		while (<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} else {
		print "Definition:";
		$def = <STDIN>;
		print "Pronounciation:";
		$pro = <STDIN>;
		$str = "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementlist><def> $def</def><pro>$pro</pro></elementlist>";
		addcontained( $uni, $uni );
		print "new entry:" . $uni . $str . "\n";
	}
	open( NEWXMLFILE, ">" . "c:\\mark\\tmp\\" . $uni . ".xml" ) || die "open failed.\n";
	foreach $uni ( @myargv ) {
		print ":$uni:";
		if( $uni =~ /^u/ ) {
			$uni2 = "%" . $uni;
		} elsif ( $uni =~ /^i_/ ) {
			$uni2 = $uni;
		} else {
			print "bad name format :$uni:\n";
			print NEWXMLFILE  $str . "\n";
			close( NEWXMLFILE );
			return;
		}

		$elem = "<elementid>$uni2</elementid>";
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

sub delcontains {
# ( u<unicode for containing character>, u<unicode for contained character)
	my( $str, $uni, $uni2 );
	$uni = $_[0];
	print " addonecontains @_\n";
	@myargv = ( $_[1] );
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . $_[0] . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . ".xml") ) {
		$str = "";
		while (<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} else {
		print "Definition:";
		$def = <STDIN>;
		print "Pronounciation:";
		$pro = <STDIN>;
		$str = "<?xml version=\"1.0\" encoding=\"utf-8\"?><elementlist><def> $def</def><pro>$pro</pro></elementlist>";
		addcontained( $uni, $uni );
		print "new entry:" . $uni . $str . "\n";
	}
	open( NEWXMLFILE, ">" . "c:\\mark\\tmp\\" . $uni . ".xml" ) || die "open failed.\n";
	foreach $uni ( @myargv ) {
		print ":$uni:";
		if( $uni =~ /^u/ ) {
			$uni2 = "%" . $uni;
		} elsif ( $uni =~ /^i_/ ) {
			$uni2 = $uni;
		} else {
			print "bad name format :$uni:\n";
			print NEWXMLFILE  $str . "\n";
			close( NEWXMLFILE );
			return;
		}

		$elem = "<elementid>$uni2</elementid>";
		if( $str =~ /$elem/ ) {
			$str =~ s/$elem//;
		}
	}
	if( length( $str ) > 0 ) {
		#print "here\n";
		print NEWXMLFILE  $str . "\n";
	}
	close( NEWXMLFILE );
}

sub checkcontainer {
# ( u<unicode for containing character> )
	my( $str, $uni, $uni2 );
	$uni = $_[0];
	print " checkcontainer @_\n";
	@myargv = ( $_[1] );
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . $_[0] . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . ".xml") ) {
		$str = "";
		while (<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} 
	return( $str =~ /elementlist>/ );
}




sub addcontained {
	my( $str, $uni, $uni2 );
	print ":$_[0]:$_[1]: addcontained\n";
	$uni = $_[0];
	$ch = $_[1];
	if( $uni =~ /^u/ ) {
		$ext = "_l";
	} elsif ( $uni =~ /^i_/ ) {
		$ext = "";
	} else {
		print "addcontained bad name format :$uni:\n";
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
		print "new list:" . $uni . $str . "\n";
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
	print "here2 $str\n";
	$elem = "<elementchar>$uni2</elementchar>";
	if( !($str =~ /$elem/) ) {
		$str =~ s/<\/elementcharlist>/$elem<\/elementcharlist>/;
		if( $str =~ /$elem/ ) {
			print "here $uni $ext\n";
			open( NEWXMLFILE, ">" . "c:\\mark\\tmp\\" . $uni . $ext . ".xml" ) || die "open failed.\n";
			print NEWXMLFILE  $str . "\n";
			close( NEWXMLFILE );
		}
	}
}

sub getcontained {
	my( $str, $uni, $uni2 );
	#print $_[0] . $_[1] . "contained\n";
	$uni = $_[0];
	$ch = $_[1];
	@rlist = ();
	if( $uni =~ /^u/ ) {
		$ext = "_l";
	} elsif ( $uni =~ /^i_/ ) {
		$ext = "";
	} else {
		print "getcontained bad name format\n";
		return( @rlist );
	}
	if ( open( XMLFILE, "c:\\mark\\tmp\\" . $_[0] . $ext . ".xml") || open( XMLFILE, "c:\\inetpub\\wwwroot\\web20\\" . $_[0] . $ext . ".xml") ) {
		$str = "";
		while(<XMLFILE>) {
			$str .= $_;
		}
		close( XMLFILE );
	} else {
		$str = "";
		print "list missing:" . $uni . "\n";
	}
	$tmpstr = "";
	while( $tmpstr ne $str ) {
		$tmpstr = $str;
		$str =~ s/<elementchar>%([0-9a-zA-Z]+)<\/elementchar>//;
		print "$str:$1\n";
		if( $str ne $tmpstr ) {
			push( @rlist, $1 );
		}
	}
	return( @rlist );
}


$lines = 0;
$skipthis = 0;
$target = "";
if( $ARGV[0] =~ /^i_/ ) {
	#we are replacing a radical with a unicode character
	#check information on unicode character exists
	if( checkcontainer( $ARGV[1] ) ) {
	# retrieve contained list from radical
		@elements = getcontained( $ARGV[0] );
	# for each element of the contained list
		foreach $ele ( @elements ) {
	#     1. remove radical from contains list for the element
			delcontains( $ele, $ARGV[0] );
	#     2. insert replacement unicode into contains list for the element
			addonecontains( $ele, $ARGV[1] );
	#     3. add element to contained list for the unicode character
			addcontained( $ARGV[1], $ele );
		}
	}
} elsif( $ARGV[0] =~ /^u/ ) {
	foreach( @ARGV ) {
		#print $_;
		++$lines;
		if( $lines eq 1 ) {
			$target = $_;
			addcontains( $_ );
		} else {
			addcontained( $_, $target );
		}
		#print "target: $target\n";
	}
} else {
	print "Bad format for first argument, should be uXXXX, or i_XXXX\n";
}
#close( SURVEY );

