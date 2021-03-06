proc compute_data_dist_matrix {} {

	global loadedFileVis
	global loadedFile_timedata
	global loadedFile_trial
  global loadedFile_mazenum
  global loadedFile_id
	global originalSize
	global originalGridSize
	global gridLocName

	global area_cnt_trial_dist
	global xpos
	global ypos
	global prevXPos
	global prevYPos

	set prevXPos 0
	set prevYPos 0

	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {

			set trial   $loadedFile_trial($ref)
      set mazenum $loadedFile_mazenum($ref)
      set id      $loadedFile_id($ref)

			foreach xval [list 0 1 2 3 4 5] {
				foreach yval [list 0 1 2 3 4 5] {
					set area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") 0
				}
			}

			foreach item $loadedFile_timedata($ref) {
				set xpos [lindex $item 0]
				set ypos [lindex $item 1]
				set trial [lindex $item 3]

				set distance [expr                  \
					sqrt( pow($xpos - $prevXPos, 2) + \
					pow($ypos - $prevYPos, 2) )]
				set prevXPos $xpos
				set prevYPos $ypos

				set xval [expr int(($originalSize - $xpos) / $originalGridSize) ]
				set yval [expr int(($originalSize - $ypos) / $originalGridSize) ]
				set area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") [expr $area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") + $distance]
			}

		}
	}

	foreach ref [array names loadedFileVis] {

		if { $loadedFileVis($ref) eq "true" } {
			foreach xval [list 0 1 2 3 4 5] {
				foreach yval [list 0 1 2 3 4 5] {

					if {$area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") != 0} {
						#puts "$xval\_$yval\_$mazenum\_$trial\_$id   >> distance is $area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") <<"
					}
				}
			}
		}
	}
}

proc compute_average_dist_matrix {} {

	global loadedFileVis
	global loadedFile_trial
  global loadedFile_mazenum
  global loadedFile_id
	global area_cnt_trial_dist
	global area_cnt_total_dist
	global dbar
	global num_of_trials
	global xval
	global yval

	set num_of_trials 0

	foreach ref [array names loadedFileVis] {

		if { $loadedFileVis($ref) eq "true" } {
			incr num_of_trials
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {

			set area_cnt_total_dist("$xval\_$yval") 0

			foreach ref [array names loadedFileVis] {

				if { $loadedFileVis($ref) eq "true" } {

          set trial   $loadedFile_trial($ref)
          set mazenum $loadedFile_mazenum($ref)
          set id      $loadedFile_id($ref)

					set area_cnt_total_dist("$xval\_$yval") [expr \
						$area_cnt_total_dist("$xval\_$yval") +      \
						$area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id")]
				}
			}

			set dbar("$xval\_$yval") [expr $area_cnt_total_dist("$xval\_$yval") / ($num_of_trials)]
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$area_cnt_total_dist("$xval\_$yval") != 0} {
				#puts "$xval\_$yval  >> total distance is  $area_cnt_total_dist("$xval\_$yval") <<     >>>> dbar is $dbar("$xval\_$yval") <<<<"
			}
		}
	}
}


proc compute_squares_dist_matrix {} {

	global area_cnt_trial_dist
	global area_cnt_total_dist
	global dbar
	global squares_dist
	global xval
	global yval

	global loadedFile_trial
  global loadedFile_mazenum
  global loadedFile_id
	global loadedFileVis

	foreach ref [array names loadedFileVis] {

		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)
      set mazenum $loadedFile_mazenum($ref)
      set id      $loadedFile_id($ref)

			foreach xval [list 0 1 2 3 4 5] {

				foreach yval [list 0 1 2 3 4 5] {

					set squares_dist("$xval\_$yval\_$mazenum\_$trial\_$id") [expr {      \
						pow ($area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") - \
						$dbar("$xval\_$yval"), 2)}]

					if {$area_cnt_total_dist("$xval\_$yval") != 0} {
						#puts "$xval\_$yval\_$mazenum\_$trial\_$id   >> squares are $squares_dist("$xval\_$yval\_$mazenum\_$trial\_$id") <<"
					}
				}
			}
		}
	}
}


proc compute_sigma_dist_matrix {} {

	global sum_of_dist_squares
	global squares_dist
	global sigma_dist
	global num_of_trials
	global area_cnt_total_dist
	global xval
	global yval

	global loadedFile_trial
  global loadedFile_mazenum
  global loadedFile_id
	global loadedFileVis

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {

			set sum_of_dist_squares("$xval\_$yval") 0

			foreach ref [array names loadedFileVis] {
				if { $loadedFileVis($ref) eq "true" } {

					set trial $loadedFile_trial($ref)
          set mazenum $loadedFile_mazenum($ref)
          set id      $loadedFile_id($ref)

					set sum_of_dist_squares("$xval\_$yval") [ expr \
						$sum_of_dist_squares("$xval\_$yval") +       \
						$squares_dist("$xval\_$yval\_$mazenum\_$trial\_$id") ]
				}
			}

			set sigma_dist("$xval\_$yval") [expr {                          \
				sqrt($sum_of_dist_squares("$xval\_$yval") / $num_of_trials)}]

			if {$area_cnt_total_dist("$xval\_$yval") != 0} {
				#puts "$xval\_$yval   >> sum of squares is $sum_of_dist_squares("$xval\_$yval") <<     >>>> sigma is $sigma_dist("$xval\_$yval") <<<<"
			}
		}
	}
}

proc compute_zscore_dist {} {

	global area_cnt_trial_dist
	global area_cnt_total_dist
	global dbar
	global sigma_dist
	global zscore_dist
	global xval
	global yval

	global loadedFileVis
	global loadedFile_trial
  global loadedFile_mazenum
  global loadedFile_id

	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)
      set mazenum $loadedFile_mazenum($ref)
      set id      $loadedFile_id($ref)

			foreach xval [list 0 1 2 3 4 5] {
				foreach yval [list 0 1 2 3 4 5] {

					if {$sigma_dist("$xval\_$yval") != 0} {
						set zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") [expr          \
							($area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") -      \
							$dbar("$xval\_$yval")) / $sigma_dist("$xval\_$yval")   ]
						#puts "$xval\_$yval\_$mazenum\_$trial\_$id   > zscore is $zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") <"
					}
				}
			}
		}
	}
}

proc draw_path_zdist {reference can mazenum trial id} {

	compute_data_dist_matrix
	compute_average_dist_matrix
	compute_squares_dist_matrix
	compute_sigma_dist_matrix
	compute_zscore_dist

	global loadedFile_data
	global loadedFile_timedata
	global originalSize
	global originalGridSize
	global gridLocName

	global area_cnt_trial_dist
	global zscore_dist
	global sigma_dist
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

	set maxDistVal 0
	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$sigma_dist("$xval\_$yval") != 0} {
				if {$zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") > $maxDistVal} {
					set maxDistVal $zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id")
				}
			}
		}
	}

	set minDistVal $maxDistVal
	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$sigma_dist("$xval\_$yval") != 0} {
				if {$zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") < $minDistVal} {
					set minDistVal $zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id")
				}
			}
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {

			if { $area_cnt_trial_dist("$xval\_$yval\_$mazenum\_$trial\_$id") == 0 || $num_of_trials == 1 } {

				set  gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill white

			} elseif {  $zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") == 0 } {

				set  gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill yellow

			} elseif {$zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") > 0} {

				set redVal   65535
				set greenVal [expr {int( 65535.0 - (1.0 * $zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id"))  / $maxDistVal * 65535.0 )}]
				set blueVal  29
				set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
				set gridLoc  "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill $colorVal

			} elseif {$zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") < 0} {

				set redVal   [expr int( 65535 - (abs($zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") / $minDistVal) * 65535) )]
				set greenVal [expr int( 65535 - (abs($zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id") / $minDistVal) * 45535) )]
				set blueVal  1000
				set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
				set gridLoc  "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill $colorVal

			} else {

				set  gridLoc "$xval\_$yval"
				$can itemconfigure $gridLocName($gridLoc) -fill white
			}
		}
	}
}
