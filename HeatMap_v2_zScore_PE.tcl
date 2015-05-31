proc compute_PE_matrix {} {

	global pesky_eff
	global zscore_time
	global zscore_dist
	global sigma_time
	global xval
	global yval
	global loadedFileVis
	global loadedFile_trial
	global loadedFile_id
	global loadedFile_mazenum

	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)
			set mazenum $loadedFile_mazenum($ref)
      set id      $loadedFile_id($ref)

			foreach xval [list 0 1 2 3 4 5] {
				foreach yval [list 0 1 2 3 4 5] {

					if {$sigma_time("$xval\_$yval") != 0} {

						set pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id") [expr ($zscore_time("$xval\_$yval\_$mazenum\_$trial\_$id") + $zscore_dist("$xval\_$yval\_$mazenum\_$trial\_$id")) /2 ]
						#puts "The pesky efficiency score for $xval\_$yval\_$mazenum\_$trial\_$id is $pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id")"
					}
				}
			}
		}
	}
}


proc draw_path_PE {reference can mazenum trial id} {

	compute_PE_matrix

	global loadedFile_data
	global loadedFile_timedata
	global originalSize
	global originalGridSize
	global gridLocName
	global loadedFileVis
	global loadedFile_trial
	global orderedNames

	global pesky_eff
	global area_cnt_trial_time
	global sigma_dist
	global sigma_time
	global num_of_trials
	global xval
	global yval

	set prevFiles {}

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

	set maxVal 0
	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$sigma_dist("$xval\_$yval") != 0 && $sigma_time("$xval\_$yval") != 0} {
				if {$pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id") > $maxVal} {
					set maxVal $pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id")
				}
			}
		}
	}

	set minVal 0
	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$sigma_dist("$xval\_$yval") != 0 && $sigma_time("$xval\_$yval") != 0} {
				if {$pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id") < $minVal} {
					set minVal $pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id")
				}
			}
		}
	}

	set firstTrial $num_of_trials
	foreach ref $orderedNames {
		if { $loadedFileVis($ref) eq "true" } {
			set t $loadedFile_trial($ref)
			if {$t < $firstTrial} {
				set firstTrial $t
			}
		}
	}

	if {$trial == $firstTrial} {
		set prevFiles $trial
	} else {

		foreach ref $orderedNames {
			if { $loadedFileVis($ref) eq "true" } {
				set t $loadedFile_trial($ref)
				if {$t < $trial} {
					lappend prevFiles $t
				}
			}
		}
	}

	foreach xval [list 0 1 2 3 4 5] {
		foreach yval [list 0 1 2 3 4 5] {
			if {$sigma_dist("$xval\_$yval") != 0 &&  \
			    $sigma_time("$xval\_$yval") != 0       } {

				if { $num_of_trials == 1 } {
					set  gridLoc "$xval\_$yval"
					set  colorVal white
				}

				foreach previousTrial $prevFiles {

					if {$area_cnt_trial_time("$xval\_$yval\_$mazenum\_$previousTrial\_$id") != 0 || $area_cnt_trial_time("$xval\_$yval\_$mazenum\_$trial\_$id") != 0 } {

						if {$pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id") > 0 } {
							set redVal   65535
							set greenVal [expr {int( 65535.0 - (1.0 * $pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id"))  / $maxVal * 65535.0 )}]
							set blueVal  29
							set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
							set gridLoc "$xval\_$yval"
						} elseif {$pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id") < 0} {
							set redVal [expr int( 65535 - (abs($pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id") / $minVal) * 65535) )]
							set greenVal [expr int( 65535 - (abs($pesky_eff("$xval\_$yval\_$mazenum\_$trial\_$id") / $minVal) * 45535) )]
							set blueVal  1000
							set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
							set gridLoc "$xval\_$yval"
						} else {
							set colorVal yellow
							set gridLoc "$xval\_$yval"
						}
					}
				}

				$can itemconfigure $gridLocName($gridLoc) -fill $colorVal
			}
		}
	}
}
