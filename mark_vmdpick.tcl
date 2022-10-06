proc pick_sphere {args} {
      global vmd_pick_atom vmd_pick_mol
mol selection index $vmd_pick_atom
    mol representation VDW 0.35 30
    mol color ColorID 1
    mol material Transparent
    mol addrep $vmd_pick_mol
}

trace variable vmd_pick_atom w pick_sphere
puts "for deleting type: trace vdelete vmd_pick_atom w pick_sphere"
