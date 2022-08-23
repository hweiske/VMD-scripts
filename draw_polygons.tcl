#!/bin/tclsh
proc draw_polygons {molid mat col atoms} {
puts "creating plane between $atoms"
set triangles [list 0]
foreach a $atoms {
      foreach b $atoms {
	      if {$b != $a} {
	      foreach c $atoms {
		      if {$c != $b} {
			      if {$c != $a} {
				if {[lsearch -exact $triangles [list $a $b $c]] == -1} {
				if {[lsearch -exact $triangles [list $a $c $b]] == -1} {
				if {[lsearch -exact $triangles [list $b $a $c]] == -1} {
				if {[lsearch -exact $triangles [list $b $c $a]] == -1} {
                                if {[lsearch -exact $triangles [list $c $a $b]] == -1} {
                                if {[lsearch -exact $triangles [list $c $b $a]] == -1} {
				  	puts "triangle between $a $b $c"
					set sel [atomselect top all]
					set coords [$sel get x]
					set x1 [lindex $coords $a]
					set x2 [lindex $coords $b]
					set x3 [lindex $coords $c]
					set coords [$sel get y]
                                        set y1 [lindex $coords $a]
                                        set y2 [lindex $coords $b]
                                        set y3 [lindex $coords $c]
					set coords [$sel get z]
                                        set z1 [lindex $coords $a]
                                        set z2 [lindex $coords $b]
                                        set z3 [lindex $coords $c]
					draw material $mat
					draw color $col
					draw triangle "$x1 $y1 $z1" "$x2 $y2 $z2" "$x3 $y3 $z3"
				      lappend triangles [list $a $b $c]
			      }}}}}}
}}}}}}
}
