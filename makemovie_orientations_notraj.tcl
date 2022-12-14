proc take_picture {args} {
  global take_picture

  # when called with no parameter, render the image
  if {$args == {}} {
#	  puts "$take_picture(vpts)  $take_picture(frame)  $take_picture(format)"
    set f [format $take_picture(format) $take_picture(vpts)]
    # take 1 out of every modulo images
    if { [expr $take_picture(frame) % $take_picture(modulo)] == 0 } {
      render $take_picture(method) $f
      # call any unix command, if specified
      if { $take_picture(exec) != {} } {
        set f [format $take_picture(exec) $f $f $f $f $f $f $f $f $f $f]
        eval "exec $f"
       }
    }
    # increase the count by one
    return
  }
  lassign $args arg1 arg2
  # reset the options to their initial stat
  # (remember to delete the files yourself
  if {$arg1 == "reset"} {
    set take_picture(frame)  0
    set take_picture(vpts) 0
    set take_picture(format) "./img_vpts.%01d.%04d.tga"
    set take_picture(method) "Tachyon"
    set take_picture(modulo) 1
    set take_picture(exec) {}  
    #{"/usr/local/lib/vmd/tachyon_LINUXAMD64" -aasamples 12 %s -format TARGA -o %s.tga}
    return
  }
  # set one of the parameters
  if [info exists take_picture($arg1)] {
    if { [llength $args] == 1} {
      return "$arg1 is $take_picture($arg1)"
    }
    set take_picture($arg1) $arg2
    return
  }
  # otherwise, there was an error
  error {take_picture: [ | reset | frame | format  | \
  method | modulo ]}
}
# to complete the initialization, this must be the first function
# called.  Do so automatically.
take_picture reset

proc make_movie_files {} {
	puts [molinfo list]
	take_picture format "./orient_%02d.frame.tga"
	# loop through the frames
	foreach i [molinfo list] {
		puts $i
		set name [molinfo $i get name]
		take_picture format "./orient_%02d.${name}.dat"
		take_picture frame [expr $i + 1]
		foreach j [molinfo list] {
			molecule off $j
		}
		molecule on $i
		display update
		foreach j [ ::VCR::list_vps ] {
			# go to the given frame
			# take the picture
			take_picture vpts $j
			take_picture 
			::VCR::goto_next
			::display height 10
			scale to 0.15
	                # force display update
	                display update
			molecule on $i

		}
        }
}
