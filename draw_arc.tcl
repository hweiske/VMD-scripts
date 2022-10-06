proc draw_arc {a b c} {
    set sel [atomselect top all]
    set coord1 [lindex [$sel get {x y z}] $a]
    set coord2 [lindex [$sel get {x y z}] $b]
    set coord3 [lindex [$sel get {x y z}] $c]
    set step [expr 1/100]
    set b0 $coord1
    set b1 [vecadd $coord1 [vecscale $coord2 [expr {1.5 /[ veclength $coord2]}]]]
    set b2 [vecadd $coord3 [vecscale $coord2 [expr {1.5 /[ veclength $coord2]}]]]
    set b3 $coord3
    for {set t 0} {$t < 1} {set t [expr $t + $step]} {
    set bezier [ vecadd [ vecscale $b0 [ expr { (1-$t)**3 } ]]  [ vecscale $b1  [expr {3*$t*(1-$t)**2}] ] [ vecscale $b2 [expr {3* $t**2*(1-$t)}]] [ vecscale $b3 [expr {$t**3}]] ]
    graphics top sphere $bezier radius 0.1 resolution 10
    }
    puts done
}
draw_arc 141 143 145
