#!/bin/tclsh
proc dotted_bond {molid mat col a b} {
set SEGS [list]
set segs [list 0 1 2 3 4 5 6 7 8 9 10]
	set sel [atomselect top all]
set coord1 [lindex [$sel get {x y z}] $a]
set coord2 [lindex [$sel get {x y z}] $b]
#set COORDS2 [list $x2 $y2 $z2]
set LENGTH [veclength [vecsub $coord1 $coord2]]
draw material $mat
draw color $col

foreach seg $segs {
set newpos [vecsub $coord1 [vecscale [vecsub $coord1 $coord2] [expr $seg * 0.1 ]]]
draw sphere $newpos radius 0.1
}
}
