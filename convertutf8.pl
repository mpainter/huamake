#!/bi/perl
# http://www.roth.net/perl/odbc/docs/object/

sub convertutf8 {
	my( $lnout, $lnin, $i, $ch );
	$lnin = $_[0];
	$lnout = "";
	$ch = 0;
	for( $i = 0 ; $i < length( $lnin ) ; ++$i ) {
		$ch = ord( substr( $lnin, $i, 1 ) );
		$str = "";
		if( $ch & 0x80 ne 0 ) {
			if( $ch & 0xf0 eq 0xf0 ) {
				# four byte character
				$str = "\%u" . sprintf( "%x", $ch & 0xf ) ;
				$i++;
				$ch = ord( substr( $lnin, $i, 1 ) );
				$str .= sprintf( "%x", $ch ) ;
				$i++;
				$ch = ord( substr( $lnin, $i, 1 ) );
				$str .= sprintf( "%x", $ch ) ;
				$i++;
				$ch = ord( substr( $lnin, $i, 1 ) );
				$str .= sprintf( "%x", $ch ) ;
			} elsif( $ch & 0xe0 eq 0xe0 ) {
				# three byte character
				$str = "\%u";
				$tmp1 = $ch & 0xf << 4;
				$i++;
				$ch = ord( substr( $lnin, $i, 1 ) );
				$tmp1 |= $ch & 0x3c >> 2;
				$tmp2 = $ch & 3 << 6;
				$str .= sprintf( "%x", $tmp1 );
				$i++;
				$ch = ord( substr( $lnin, $i, 1 ) );
				$str .= sprintf( "%x", $ch | $tmp2 );
			} elsif ( $ch & 0xc0 eq 0xc0 ) {
				# two byte character
				$str = "\%u";
				$tmp1 = $ch & 0x1c >> 2;
				$tmp2 = $ch & 3 << 6;
				$str .= sprintf( "%x", $tmp1 );
				$i++;
				$ch = ord( substr( $lnin, $i, 1 ) );
				$str .= sprintf( "%x", $ch | $tmp2 );
			} 
			#printf "%x" hex($ch);
		} else { 
			$str = substr( $lnin, $i, 1 );
		}
		$lnout .= $str; 
		#print $i. ":" . $lnout . "\n";
	}
	
	return $lnout;
}

sub loadfile {
	open( DATAFILE, $_[0] ) || return "no input\n";
	print sprintf( "%x", 255 );


	while( <DATAFILE> ) {
		#print $_;
		$outln = convertutf8( $_ );
		print $outln;
		
	}

}


loadfile( $ARGV[0] );





