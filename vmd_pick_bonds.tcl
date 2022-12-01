proc draw_dotted_pick {args} {
    global vmd_pick_selection vmd_pick_mol
    set SEGS [list]
    set segs [list 0 1 2 3 4 5 6 7 8 9 10]
    set sel [atomselect top all]
    set a [lindex $vmd_pick_selection 1]
    set b [lindex $vmd_pick_selection 2]
    set coord1 [lindex [$sel get {x y z}] $a]
    set coord2 [lindex [$sel get {x y z}] $b]
    set LENGTH [veclength [vecsub $coord1 $coord2]]
    draw material AOChalky
    foreach seg $segs {
	    set newpos [vecsub $coord1 [vecscale [vecsub $coord1 $coord2] [expr $seg * 0.1 ]]]
	    graphics $vmd_pick_mol sphere $newpos radius 0.1 resolution 30
	    label hide Atoms all
	    label hide Bonds all
}
}

trace variable vmd_pick_selection w draw_dotted_pick
puts "for deleting type: trace vdelete vmd_pick_selection w draw_dotted_pick"
