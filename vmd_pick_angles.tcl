proc draw_arc {args} {
    global vmd_pick_selection vmd_pick_mol
    set arc [exec python3 VMD-scripts/draw_arc.py [molinfo $vmd_pick_mol get filename] [lindex $vmd_pick_selection 1] [lindex $vmd_pick_selection 2] [lindex $vmd_pick_selection 3] ]
eval $arc
}
trace variable vmd_pick_selection w draw_arc
puts "for deleting type: trace vdelete vmd_pick_selection w draw_dotted_pick"
