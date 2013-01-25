#!/usr/bin/perl

$cf = open(CF, "<$ARGV[0]");
while($line = <CF>){
	eval($line);
}
close(CF);

sub plotcor {
	my($val,$min,$max,$log) = @_;
	if($log){
		if($val <= 0){
			return 0;
		}
		return ((log($val) / log($log)) - $min) / ($max - $min);
	} else {
		return ($val - $min) / ($max - $min);
	}
}

sub init {
	if($outputfilename == "-"){
		$of = STDOUT;
	} else {
		$of = open(OF, ">$outputfilename");
		$of = OF;
	}
	if($xlabeltype){
		$xf = open(XF, "<".$xlabeltype);
	}
	if($ylabeltype){
		$yf = open(YF, "<".$ylabeltype);
	}
	
	print $of "\\begin{tikzpicture}\n";
}

sub axes {
	# Axes
	my $x;
	my $y;
	print $of "\%Begin Axes.\n";
	print $of "\\fill (0,0) rectangle ($w,$h) [black!5];\n";
	if($yminor){
		for($i = $ymin + $yminoroff; $i <= $ymax; $i += $yminor){
			$y = ($i - $ymin) / ($ymax - $ymin) * $h;
			print $of "\\draw (0,$y) -- ($w,$y) [ultra thin,gray!50];\n";
		}
	}
	
	if($xminor){
		for($i = $xmin + $xminoroff; $i <= $xmax; $i += $xminor){
			$x = ($i - $xmin) / ($xmax - $xmin) * $w;
			print $of "\\draw ($x,0) -- ($x,$h) [ultra thin,gray!50];\n";
		}
	}
	
	print $of "\\draw (0,$h) -- ($w,$h) -- ($w,0) [ultra thin,gray!50];\n";
	
	if($ymajor){
		if($ylabels == 2){
			while($line = <YF>){
				$line =~ m/^\ *(-?[0-9\.]*)\ *,(.*)$/;
				$labely = $1 * $h;
				print $of "\\node at (0,$labely) [anchor=east] {{$ylabelprefix$2$ylabelsuffix}};\n";
				print $of "\\draw (0,$labely) -- ($w,$labely) [ultra thin,gray];\n";
				print $of "\\draw (0,$labely) -- (-0.05,$labely) [ultra thin];\n";
			}
		} else {
			for($i = $ymin + $ymajoroff; $i <= $ymax; $i += $ymajor){
				$y = ($i - $ymin) / ($ymax - $ymin) * $h;
				if($i != $ymax){
					print $of "\\draw (0,$y) -- ($w,$y) [ultra thin,gray];\n";
				}
				print $of "\\draw (0,$y) -- (-0.05,$y) [ultra thin];\n";
				if($ylabels){
					if($ylabeltype){
						$line = <YF>;
						chomp($line);
						print $of "\\node at (0,$y) [anchor=east] {{$ylabelprefix$line$ylabelsuffix}};\n";
					} else {
						if($ylog && $yloglabels == 1){
							$loglabel = $ylog ** $i;
							print $of "\\node at (0,$y) [anchor=east] {{$ylabelprefix$loglabel$ylabelsuffix}};\n";
						} else {
							print $of "\\node at (0,$y) [anchor=east] {{$ylabelprefix$i$ylabelsuffix}};\n";
						}
					}
				}
			}
		}
	}
	
	if($xmajor){
		if($xlabels == 2){
			while($line = <XF>){
				$line =~ m/^\ *(-?[0-9\.]*)\ *,(.*)$/;
				$x = $1 * $w;
				if($xrotate){
					$labelx = $x + .125;
					print $of "\\node at ($labelx,-0) [anchor=east,rotate=45] ";
				} else {
					print $of "\\node at ($x,0) [anchor=north] ";
				}
				print $of "{{$xlabelprefix$2$xlabelsuffix}};\n";
				print $of "\\draw ($x,0) -- ($x,$h) [ultra thin,gray];\n";
				print $of "\\draw ($x,0) -- ($x,-0.05) [ultra thin];\n";
			}
		} else {
			for($i = $xmin; $i <= $xmax; $i += $xmajor){
				$x = ($i - $xmin) / ($xmax - $xmin) * $w;
				if($i != $xmax){
					print $of "\\draw ($x,0) -- ($x,$h) [ultra thin,gray];\n";
				}
				print $of "\\draw ($x,0) -- ($x,-0.05) [ultra thin];\n";
				if($xlabels){
					if($xrotate){
						$labelx = $x + .125;
						print $of "\\node at ($labelx,-0.1) [anchor=east,rotate=45] ";
					} else {
						print $of "\\node at ($x,0) [anchor=north] ";
					}
					print $of "{{";
					if($xlabeltype){
						$line = <XF>;
						chomp($line);
						print $of $line;
					} else {
						if($xlog && $xloglabels == 1){
							$loglabel = $xlog ** $i;
							print $of "$xlabelprefix$loglabel$xlabelsuffix";
						} else {
							printf $of "$xlabelprefix$i$xlabelsuffix";
						}
					}
					print $of "}};\n";
				}
			}
		}
	}
	
	if($xmin < 0 && $xmax > 0 && $xlabels != 2){
		$x = (0 - $xmin) / ($xmax - $xmin) * $w;
		print $of "\\draw ($x,0) -- ($x,$h) [ultra thin];\n";
	}
	
	if($ymin < 0 && $ymax > 0 && $ylabels != 2){
		$y = (0 - $ymin) / ($ymax - $ymin) * $h;
		print $of "\\draw (0,$y) -- ($w,$y) [ultra thin];\n";
	}
	
	print $of "\\draw ($w,-0.05) -- ($w,0) -- (-0.05,0) [semithick];\n";
	print $of "\\draw (-0.05,$h) -- (0,$h) -- (0,-0.05) [semithick];\n";
	print $of "\%End Axes.\n";
}

sub title {
	$titlex = $w / 2;
	$titley = $h + 0.25;
	
	print $of "\\node at ($titlex,$titley) [anchor=south] {$title};\n";
}

sub plot {
	my($fn,$color,$curve,$drop,$plotpoints,$plotlines,$psize,$thickness,$bound) = @_;
	my @slopes;
	my @x;
	my @y;
	my $df;
	if($fn eq "-"){
		$df = STDIN;
	} else {
		open($df, "<$fn");
	}
	print $of "\%Begin Plot of \"$fn\".\n";
	
	while($line = <$df>){
		chomp($line);
		$line =~ m/^\ *(-?[0-9\.]*)\ *,\ *(-?[0-9\.]*)\ *$/;
		$cx = plotcor($1,$xmin,$xmax,$xlog) * $w;
		$cy = plotcor($2,$ymin,$ymax,$ylog) * $h;
		#print "($cx,$cy)\n";
		if(!$bound || ($cx > 0 && $cx < $w && $cy > 0 && $cy < $h)){
			push(@x, $cx);
			push(@y, $cy);
		}
	}
	
	$np = scalar(@x);
	
	$y0 = 0;
	
	if($drop == 2){
		if($ymin < 0 && $ymax > 0){
			$y0 = (0 - $ymin) / ($ymax - $ymin) * $h;
		}
		if($ymin >= 0){
			$y0 = 0;
		}
		if($ymax <= 0){
			$y0 = $h;
		}
	}
	
	if($curve == 1){
		
		@slopes[0] = (@y[1] - @y[0]) / (@x[1] - @x[0]);
		
		@slopes[$np - 1] = (@y[$np - 1] - @y[$np - 2]) / (@x[$np - 1] - @x[$np - 2]);
		
		for($i = 1; $i < $np - 1; $i++){
			$px = @x[$i - 1];
			$cx = @x[$i    ];
			$nx = @x[$i + 1];
			$py = @y[$i - 1];
			$cy = @y[$i    ];
			$ny = @y[$i + 1];
			
			$sp = ($cy - $py) / ($cx - $px);
			$sn = ($ny - $cy) / ($nx - $cx);
			$s = ($sn * ($cx - $px) + $sp * ($nx - $cx)) / ($nx - $px);
			
			@slopes[$i] = $s;
			
			#print $of "\\draw ($cx,$cy) to ($nx,$ny);\n";
		}
		
		for($i = 0; $i < $np - 1; $i++){
			$sx  = @x[$i    ];
			$ex  = @x[$i + 1];
			$sy  = @y[$i    ];
			$ey  = @y[$i + 1];
			$cx1  = $sx + ($ex - $sx) / 4;
			$cx2  = $ex - ($ex - $sx) / 4;
			$cy1 = $sy + @slopes[$i    ] * ($ex - $sx) / 4;
			$cy2 = $ey - @slopes[$i + 1] * ($ex - $sx) / 4;
			if($drop){
				printf $of "\\fill (%f,%f) .. controls\n\t(%f,%f) and\n\t(%f,%f) ..\n\t(%f,%f) --\n\t(%f,%f) --\n\t(%f,%f) --\n\tcycle [opacity=.25,$color];\n",
					$sx,$sy,$cx1,$cy1,$cx2,$cy2,$ex,$ey,$ex,$y0,$sx,$y0;
			}
			if($plotlines){
				printf $of "\\draw (%f,%f) .. controls\n\t(%f,%f) and\n\t(%f,%f) ..\n\t(%f,%f) [$thickness,$color];\n",
					$sx,$sy,$cx1,$cy1,$cx2,$cy2,$ex,$ey;
			}
			#printf $of "\\draw (%f,%f) -- (%f,%f) [ultra thin];\n", $sx,$sy,$cx1,$cy1;
			#printf $of "\\draw (%f,%f) -- (%f,%f) [ultra thin];\n", $ex,$ey,$cx2,$cy2;
			#printf $of "\\fill (%f,%f) circle (0.025cm);\n", $cx1,$cy1;
			#printf $of "\\fill (%f,%f) circle (0.025cm);\n", $cx2,$cy2;
		}
	} else {
		for($i = 0; $i < $np - 1; $i++){
			if($drop){
				printf $of "\\fill(%f,%f) -- (%f,%f) -- (%f,%f) -- (%f,%f) -- cycle [opacity=.25,$color];\n",
					@x[$i],@y[$i],@x[$i + 1],@y[$i + 1],@x[$i + 1],$y0,@x[$i],$y0;
			}
			if($plotlines){
				printf $of "\\draw (%f,%f) -- (%f,%f) [$thickness,$color];\n",
					@x[$i],@y[$i],@x[$i + 1],@y[$i + 1];
			}
		}
	}
	
	if($plotpoints){
		for($i = 0; $i < $np; $i++){
			printf $of "\\fill (%f,%f) circle (%f cm) [$color];\n",@x[$i],@y[$i],$psize;
		}
	}
	
	close($df);
	
	print $of "\%End Plot of \"$fn\".\n";
}

sub uninit {
	print $of "\\end{tikzpicture}\n";
}

init();
axes();
title();
$numseries = scalar(@series);
for($seriesi = 0; $seriesi < $numseries; $seriesi++){
	print $of "\\definecolor{color$seriesi}{rgb}{@colors[$seriesi]}\n";
	plot(@series[$seriesi],"color$seriesi",@curved[$seriesi],@drops[$seriesi],@points[$seriesi],@lines[$seriesi],@pointsize[$seriesi],@linethickness[$seriesi],@boundaries[$seriesi]);
}
uninit();
