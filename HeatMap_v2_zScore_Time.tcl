proc compute_data_time_matrix { can } {

	global loadedFileVis
	global loadedFile_timedata
	global loadedFile_trial
	global originalSize
	global originalGridSize
	global gridLocName

	global area_cnt_trial_time
	global xpos
	global ypos
	global prevXPos
	global prevYPos

	set prevTotalTime 0    

	foreach ref [array names loadedFileVis] {

		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)

			foreach xval [list 0 1 2 3 4 5] {
				foreach yval [list 0 1 2 3 4 5] {
					set area_cnt_trial_time("$xval\_$yval\_$trial") 0
				}
			}

			foreach item $loadedFile_timedata($ref) { 

				set xpos        [lindex $item 0]
				set ypos        [lindex $item 1]
				set timeVal     [lindex $item 2]

				set trial       [lindex $item 3]

				set timeVal     [split $timeVal ":"]

				set hourVal     [lindex $timeVal 0]
				set minVal      [lindex $timeVal 1]
				set secSecVal   [lindex $timeVal 2]
				set secSecVal   [split  $secSecVal "."]

				set secVal      [lindex $secSecVal 0]
				set microSecVal [lindex $secSecVal 1]

				#converts everything to microseconds
				set totalTime [expr                \
					($hourVal * 60 * 60 * 1000) +    \
					($minVal  * 60 * 1000) +         \
					($secVal  * 1000) + $microSecVal   ]

				set timeDiff [expr $totalTime - $prevTotalTime]

				set prevTotalTime $totalTime

				set xval [expr int(($originalSize - $xpos) / $originalGridSize) ]
				set yval [expr int(($originalSize - $ypos) / $originalGridSize) ]

				set area_cnt_trial_time("$xval\_$yval\_$trial") [expr {$area_cnt_trial_time("$xval\_$yval\_$trial") + $timeDiff}]
			}
		}
	}

	foreach ref [array names loadedFileVis] {

		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)
 
			foreach xval [list 0 1 2 3 4 5] {
				foreach yval [list 0 1 2 3 4 5] {

					if {$area_cnt_trial_time("$xval\_$yval\_$trial") != 0} {
						#puts "$xval\_$yval\_$trial   >> $area_cnt_trial_time("$xval\_$yval\_$trial") <<"
					}
				}
			}
		}
	}
}

proc compute_average_time_matrix {} { 

	global area_cnt_trial_time
	global area_cnt_total_time
	global tbar
	global num_of_trials
	global xval
	global yval

	global loadedFileVis
	global loadedFile_trial

	set num_of_trials 0
	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {
			incr num_of_trials
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			set area_cnt_total_time("$xval\_$yval") 0 

			foreach ref [array names loadedFileVis] {
				if { $loadedFileVis($ref) eq "true" } {
					set trial $loadedFile_trial($ref)
					set area_cnt_total_time("$xval\_$yval") [expr $area_cnt_total_time("$xval\_$yval") + $area_cnt_trial_time("$xval\_$yval\_$trial")]
				}
			}
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			set tbar("$xval\_$yval") [expr $area_cnt_total_time("$xval\_$yval") / ($num_of_trials)]
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$tbar("$xval\_$yval") != 0} {
				#puts "$xval\_$yval  >> total time is  $area_cnt_total_time("$xval\_$yval") <<     >>>> tbar is $tbar("$xval\_$yval") <<<<"
			}
		}
	}
}

proc compute_squares_time_matrix {} {

	global area_cnt_trial_time
	global area_cnt_total_time
	global tbar
	global squares_time
	global xval
	global yval

	global loadedFile_trial
	global loadedFileVis

	foreach ref [array names loadedFileVis] {

		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)
   
			foreach xval [list 0 1 2 3 4 5] {
				foreach yval [list 0 1 2 3 4 5] {

					set squares_time("$xval\_$yval\_$trial") [expr {      \
						pow ($area_cnt_trial_time("$xval\_$yval\_$trial") - \
						$tbar("$xval\_$yval"), 2)}]	
	        
					if {$area_cnt_total_time("$xval\_$yval") != 0} {
						#puts "$xval\_$yval\_$trial  >>> squares are $squares_time("$xval\_$yval\_$trial") <<<"
					}
				}
			}
		}
	}
}

proc compute_sigma_time_matrix {} {

	global area_cnt_trial_time
	global tbar
	global squares_time
	global sum_of_time_squares
	global sigma_time
	global num_of_trials
	global xval
	global yval
	global loadedFile_trial
	global loadedFileVis
    
	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {

			set sum_of_time_squares("$xval\_$yval") 0

			foreach ref [array names loadedFileVis] {
				if { $loadedFileVis($ref) eq "true" } {
					set trial $loadedFile_trial($ref)
					set sum_of_time_squares("$xval\_$yval") [ expr $sum_of_time_squares("$xval\_$yval") + $squares_time("$xval\_$yval\_$trial")]
				}
			}

			set sigma_time("$xval\_$yval") [expr {sqrt($sum_of_time_squares("$xval\_$yval") / $num_of_trials)}]

			if {$tbar("$xval\_$yval") != 0} {
				#puts "$xval\_$yval\_$trial   >> sum of squares is $sum_of_time_squares("$xval\_$yval") <<     >>>> sigma is $sigma_time("$xval\_$yval") <<<<"
			}
	
		}
	}
}

proc compute_zscore_time {} {

	global area_cnt_trial_time
	global area_cnt_total_time
	global tbar
	global sigma_time
	global zscore_time
	global xval
	global yval
	global loadedFile_trial
	global loadedFileVis

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {

			foreach ref [array names loadedFileVis] {
				if { $loadedFileVis($ref) eq "true" } {
					set trial $loadedFile_trial($ref)

					if {$sigma_time("$xval\_$yval") != 0} {
						set zscore_time("$xval\_$yval\_$trial") [expr ($area_cnt_trial_time("$xval\_$yval\_$trial") - $tbar("$xval\_$yval")) / $sigma_time("$xval\_$yval")]
						#puts "$xval\_$yval\_$trial   > zscore is $zscore_time("$xval\_$yval\_$trial") <"
					} else {
						set zscore_time("$xval\_$yval\_$trial") 0
					}
				}
			}
		}
	}
}

proc draw_path_ztime {reference can trial} {

	compute_data_time_matrix $can
	compute_average_time_matrix
	compute_squares_time_matrix 
	compute_sigma_time_matrix
	compute_zscore_time

	global loadedFile_data
	global originalSize
	global originalGridSize
	global gridLocName

	global area_cnt_trial_time
	global zscore_time
	global sigma_time
	global num_of_trials
	global xval
	global yval

	set first 1
  
	foreach {xpos ypos} $loadedFile_data($reference) {

		if {$first} {
			set first 0
		} else {

			$can create line                          \
			[ rawPos $prevXPos ] [ rawPos $prevYPos ] \
			[ rawPos $xpos     ] [ rawPos $ypos     ]

		}

		set prevXPos $xpos
		set prevYPos $ypos

	}

	set maxTimeVal 0

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$sigma_time("$xval\_$yval") != 0} {
				if {$zscore_time("$xval\_$yval\_$trial") > $maxTimeVal} {
					set maxTimeVal $zscore_time("$xval\_$yval\_$trial")
				}
			}
		}
	}

	set minTimeVal $maxTimeVal
	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$sigma_time("$xval\_$yval") != 0} {
				if {$zscore_time("$xval\_$yval\_$trial") < $minTimeVal} {
					set minTimeVal $zscore_time("$xval\_$yval\_$trial")
				}
			}
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {

			if { $area_cnt_trial_time("$xval\_$yval\_$trial") == 0 || $num_of_trials == 1} {
				set  gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill white
			} elseif {  $zscore_time("$xval\_$yval\_$trial") == 0 } {
				set  gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill yellow
			} elseif {$zscore_time("$xval\_$yval\_$trial") > 0} {      
				set redVal   65535
				set greenVal [expr {int( 65535.0 - (1.0 * $zscore_time("$xval\_$yval\_$trial"))  / $maxTimeVal * 65535.0 )}]
				set blueVal  29
				set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]     
				set gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill $colorVal    
			} elseif {$zscore_time("$xval\_$yval\_$trial") < 0} {    
				set redVal   [expr int( 65535 - (abs($zscore_time("$xval\_$yval\_$trial") / $minTimeVal) * 65535) )]
				set greenVal [expr int( 65535 - (abs($zscore_time("$xval\_$yval\_$trial") / $minTimeVal) * 45535) )]
				set blueVal  1000
				set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ] 
				set gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill $colorVal
			} else {
				set  gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill white
			} 
		}
	}
}
