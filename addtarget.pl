#!/bin/perl

while( <> ) {
	s/<[aA]\s+/<a target="_parent" /g;
	print;
}