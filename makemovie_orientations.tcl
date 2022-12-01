set VMD_PICTURES "./"
proc take_picture {args} {
  global take_picture

  # when called with no parameter, render the image
  if {$args == {}} {
	  puts "$take_picture(vpts)  $take_picture(frame)  $take_picture(format)"
    set f [format $take_picture(format) $take_picture(vpts) $take_picture(frame)]
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
  # VMD_PICTURES is an environment variable
  if {$arg1 == "reset"} {
    set take_picture(frame)  0
    set take_picture(vpts) 0
    set take_picture(format) "${VMD_PICTURES}/img_vpts.%01d.%04d.tga" 
    set take_picture(method) Tachyon
    set take_picture(modulo) 1
    set take_picture(exec)    {"/usr/local/lib/vmd/tachyon_LINUXAMD64" -aasamples 12 %s -format TARGA -o %s.tga}
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
  method  | modulo ]}
}
# to complete the initialization, this must be the first function
# called.  Do so automatically.
take_picture reset
proc make_trajectory_movie_files {name} {
	set num [molinfo top get numframes]
	take_picture format "${VMD_PICTURES}/${name}.orient_%02d.frame_%02d.tga"
	# loop through the frames
	for {set i 0} {$i < $num} {incr i} {
		take_picture frame $i
		animate goto $i
		display update
		foreach j [ ::VCR::list_vps ] {
			# go to the given frame
			# take the picture
			take_picture vpts $j
			take_picture 
			::VCR::goto_next
	                # force display update
	                display update
		}
        }
}
