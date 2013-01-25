
$outputfilename = "graph.tex";

$w = 10.0; # Width  of main graph area, in centimeters.
$h = 6.0;  # Height of main graph area, in centimeters.

$title = "A Test Graph";

#@series = ("data-random.csv","data-sin.csv","data-line.csv","data-parabola.csv");
#@colors = ("1,1,0"          ,"1,0,0"       ,"0,1,0"        ,"0,0,1"            ); # r,g,b, each channel from 0 to 1.
#@curved = (1                ,1             ,1              ,1                  ); # 0: connect the lines with straight segments, 1: bezier curved segments.
#@drops  = (1                ,2             ,0              ,0                  ); # 0: no drop-shading, 1: to the bottom of the graph, 2: to y = 0.
#@points = (1                ,0             ,1              ,1                  ); # 1: mark data points, 0: don't.

@series = ("data-exp.csv","data.csv");
@colors = ("1,0,0"       ,"0,0,1"   );
@curved = (1             ,1         );
@drops  = (1             ,2         );
@points = (1             ,1         );

#$xrotate      = 1; # 1: rotate the labels on the x axis,
#$xlabels      = 1;
#$xlabeltype   = 0; # 0: auto-numeric, filename string: read newline separated labels from filename. 
#$xlabelprefix = "\\small \$\\mathdollar\$"; # For non-pixellated $, use "\$\\mathdollar\$".
#$xlabelsuffix = ".00";
#$xlog         = 2; # 0: linear, any other number: the base of the log.
#$xmin         = -4;
#$xmax         = 5;
#$xmajor       = 1;
#$xmajoroff    = 0;
#$xminor       = .25;
#$xminoroff    = 0;

#$ylabels      = 1;
#$ylabeltype   = 0;
#$ylabelprefix = "\\small ";
#$ylabelsuffix = "\\%";
#$ymin         = -500;
#$ymax         = 1000;
#$ymajor       = 250;
#$ymajoroff    = 0;
#$yminor       = 50;
#$yminoroff    = 0;

$xrotate      = 1; # 1: rotate the labels on the x axis,
$xlabels      = 1; # 0: no labels, 1: labels according to intervals defined below, 2: interval lines defined by first column of $xlabeltype file
$xlabeltype   = 0; # 0: auto-numeric, filename string: read newline separated labels from filename. 
$xlabelprefix = "\\small "; # For non-pixellated $, use "\$\\mathdollar\$".
$xlabelsuffix = "";
$xlog         = 0; # 0: linear, any other number: the base of the log.
$xloglabels   = 1; # 0: label with exponent, 1: label with value
$xmin         = 0;
$xmax         = 1;
$xmajor       = .1;
$xmajoroff    = 0;
$xminor       = 0;
$xminoroff    = 0;

$ylabels      = 1;
$ylabeltype   = 0;
$ylabelprefix = "\\small ";
$ylabelsuffix = "";
$ylog         = 0;
$yloglabels   = 0;
$ymin         = -1;
$ymax         = 1;
$ymajor       = 1;
$ymajoroff    = 0;
$yminor       = .2;
$yminoroff    = 0;
