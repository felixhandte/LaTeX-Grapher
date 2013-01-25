#!/usr/bin/perl

use Math::Trig;

$o = 0;
for($i = 0; $i <= 1; $i += .0078125){
	$o = sin($i * 16 * pi) * 0.5;
	printf("%f,%f\n", $i, $o);
}
