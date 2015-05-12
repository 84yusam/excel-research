proc build_drawing_windows {} {

	build_zTime_drawing_window
	build_zDist_drawing_window
	build_PeskyEff_drawing_window
	build_color_spectrum
}


proc build_zTime_drawing_window {} {

	global loadedFileVis
	global loadedFile_trial
	global canT
	global drawingWindow

	set canT 0
	array set drawingWindow {}

	global drawingFileType
	global fileSaveLocation
	global currentMaze
	global can_width
	global can_height
	global num_of_trials
	global orderedNames

	set num_of_trials 0
	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {
			incr num_of_trials
		}
	}

	toplevel .zTimeWindow
	wm title .zTimeWindow "Heat Map using z-Scores for Time"

	set t2 ".zTimeWindow"

	#--- frame one (button to source outside files for data)
	frame $t2.f1 -width 0
	pack  $t2.f1 -side top -anchor nw -fill x

	set fileSaveLocation "choose output file location"
	button $t2.f1.b3 -command set_drawing_location -textvar fileSaveLocation
	pack   $t2.f1.b3 -side left -anchor nw -fill x -expand 1

	#--- frame two (button to save drawing)
	frame $t2.f2 -width 0
	pack  $t2.f2 -side top -anchor nw -fill x

	button $t2.f2.b2 -command save_all_drawing -text "save drawing" -width 20
	pack   $t2.f2.b2 -side left -anchor nw  -fill x

	set combolist  [list ps jpg png]
	set drawingFileType [lindex $combolist 0 ]
	ttk::combobox $t2.f2.cb1 -values $combolist -textvar drawingFileType
	pack     $t2.f2.cb1 -side left -anchor nw  -fill x

	#--- frame three (refresh button and what maze number the
	#--- data is from / should be shown)
	frame $t2.f3 -width 0
	pack  $t2.f3 -side top -anchor nw -fill x

	button $t2.f3.b1                  \
		-command refresh_all_drawings   \
		-text "refresh drawing"         \
		-width 20
	pack   $t2.f3.b1 -side left -anchor nw -fill x

	set combolist2  [list                                      \
		"Maze 1" "Maze 2" "Maze 3" "Maze 4"  "Maze 5"  "Maze 6"  \
		"Maze 7" "Maze 8" "Maze 9" "Maze 10" "Maze 11" "Maze 12"  ]
	set currentMaze [lindex $combolist2 0 ]
	ttk::combobox $t2.f3.cb2 -values $combolist2 -textvar currentMaze
	pack     $t2.f3.cb2 -side left -anchor nw  -fill x

	#--- frame four (display all maze maps)
	frame $t2.f4 -width 0 -relief groove -borderwidth 0
	pack  $t2.f4 -side top -expand 0 -pady 20

	frame $t2.f5 -width 0 -relief groove -borderwidth 0
	pack  $t2.f5 -side bottom -expand 0 -pady 20

	foreach ref $orderedNames {

		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)
			if { $num_of_trials <= 5} {

				set drawingWindow($trial\_canT)              \
					[canvas $t2.f4.drawingWindow($trial\_canT) \
							-width $can_width                      \
							-height $can_height                      ]

			} else {

				if { $trial <= ($num_of_trials / 2) } {

					set drawingWindow($trial\_canT) [           \
						canvas $t2.f4.drawingWindow($trial\_canT) \
							-width $can_width                       \
							-height $can_height]

				} elseif { $trial > ($num_of_trials / 2) } {

					set drawingWindow($trial\_canT) [            \
						canvas $t2.f5.drawingWindow($trial\_canT)  \
						-width $can_width                          \
						-height $can_height]
				}
			}

			pack $drawingWindow($trial\_canT) -side left -anchor nw
		}
	}
}

proc build_zDist_drawing_window {} {

	global loadedFileVis
	global loadedFile_trial
	global canD
	global drawingWindow

	set canD 0

	array set drawingWindow {}

	global prevTD

	set prevTD 0

	global drawingFileType
	global fileSaveLocation
	global currentMaze
	global can_width
	global can_height
	global num_of_trials
	global orderedNames

	set num_of_trials 0

	foreach ref [array names loadedFileVis] {

		if { $loadedFileVis($ref) eq "true" } {

			incr num_of_trials
		}
	}

	toplevel .zDistWindow
	wm title .zDistWindow "Heat Map using z-Scores for Distance"

	set t3 ".zDistWindow"

	#--- frame one (button to source outside files for data)
	frame $t3.f1 -width 0
	pack  $t3.f1 -side top -anchor nw -fill x

	set fileSaveLocation "choose output file location"
	button $t3.f1.b3 -command set_drawing_location -textvar fileSaveLocation
	pack   $t3.f1.b3 -side left -anchor nw -fill x -expand 1

	#--- frame two (button to save drawing)
	frame $t3.f2 -width 0
	pack  $t3.f2 -side top -anchor nw -fill x

	button $t3.f2.b2 -command save_all_drawing -text "save drawing" -width 20
	pack   $t3.f2.b2 -side left -anchor nw  -fill x

	set combolist  [list ps jpg png]
	set drawingFileType [lindex $combolist 0 ]

	ttk::combobox $t3.f2.cb1 -values $combolist -textvar drawingFileType

	pack $t3.f2.cb1 -side left -anchor nw  -fill x

	#--- frame three (refresh button and what maze number
	#--- the data is from / should be shown)
	frame $t3.f3 -width 0
	pack  $t3.f3 -side top -anchor nw -fill x

	button $t3.f3.b1                \
		-command refresh_all_drawings \
		-text "refresh drawing"       \
		-width 20
	pack   $t3.f3.b1 -side left -anchor nw -fill x

	set combolist2  [list                                      \
		"Maze 1" "Maze 2" "Maze 3" "Maze 4"  "Maze 5"  "Maze 6"  \
		"Maze 7" "Maze 8" "Maze 9" "Maze 10" "Maze 11" "Maze 12"  ]
	set currentMaze [lindex $combolist2 0 ]

	ttk::combobox $t3.f3.cb2 -values $combolist2 -textvar currentMaze
	pack     $t3.f3.cb2 -side left -anchor nw  -fill x

	#--- frame four (display all maze maps)
	frame $t3.f4 -width 0 -relief groove -borderwidth 0
	pack  $t3.f4 -side top -expand 0 -pady 20

	frame $t3.f5 -width 0 -relief groove -borderwidth 0
	pack  $t3.f5 -side bottom -expand 0 -pady 20

	foreach ref $orderedNames {

		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)

			if { $num_of_trials <= 5} {

				set drawingWindow($trial\_canD) [            \
					canvas $t3.f4.drawingWindow($trial\_canD)  \
						-width $can_width -height $can_height      ]

			} else {

				if { $trial <= ($num_of_trials / 2) } {
					set drawingWindow($trial\_canD) [canvas $t3.f4.drawingWindow($trial\_canD)  -width $can_width -height $can_height]
				} elseif { $trial > ($num_of_trials / 2) } {
					set drawingWindow($trial\_canD) [canvas $t3.f5.drawingWindow($trial\_canD)  -width $can_width -height $can_height]
				}
			}

			pack $drawingWindow($trial\_canD) -side left -anchor nw
		}
	}
}

proc build_PeskyEff_drawing_window {} {

	global loadedFileVis
	global loadedFile_trial
	global canP
	global drawingWindow

	set canP 0
	array set drawingWindow {}

	global prevTP
	set prevTP 0

	global drawingFileType
	global fileSaveLocation
	global currentMaze
	global can_width
	global can_height
	global num_of_trials
	global orderedNames

	set num_of_trials 0

	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {
			incr num_of_trials
		}
	}

	toplevel .peskyEffWindow
	wm title .peskyEffWindow "Heat Map using Pesky Efficiency Scores"

	set t4 ".peskyEffWindow"

	#--- frame one (button to source outside files for data)
	frame $t4.f1 -width 0
	pack  $t4.f1 -side top -anchor nw -fill x

	set fileSaveLocation "choose output file location"
	button $t4.f1.b3 -command set_drawing_location -textvar fileSaveLocation
	pack   $t4.f1.b3 -side left -anchor nw -fill x -expand 1

	#--- frame two (button to save drawing)
	frame $t4.f2 -width 0
	pack  $t4.f2 -side top -anchor nw -fill x

	button $t4.f2.b2 -command save_all_drawing -text "save drawing" -width 20
	pack   $t4.f2.b2 -side left -anchor nw  -fill x

	set combolist  [list ps jpg png]
	set drawingFileType [lindex $combolist 0 ]
	ttk::combobox $t4.f2.cb1 -values $combolist -textvar drawingFileType
	pack     $t4.f2.cb1 -side left -anchor nw  -fill x

	#--- frame three (refresh button and what maze number the data is from / should be shown)
	frame $t4.f3 -width 0
	pack  $t4.f3 -side top -anchor nw -fill x

	button $t4.f3.b1 -command refresh_all_drawings -text "refresh drawing" -width 20
	pack   $t4.f3.b1 -side left -anchor nw -fill x

	set combolist2  [list "Maze 1" "Maze 2" "Maze 3" "Maze 4"  "Maze 5"  "Maze 6" \
	                      "Maze 7" "Maze 8" "Maze 9" "Maze 10" "Maze 11" "Maze 12"  ]
	set currentMaze [lindex $combolist2 0 ]
	ttk::combobox $t4.f3.cb2 -values $combolist2 -textvar currentMaze
	pack     $t4.f3.cb2 -side left -anchor nw  -fill x

	#--- frame four (display all maze maps)
	frame $t4.f4 -width 0 -relief groove -borderwidth 0
	pack  $t4.f4 -side top -expand 0 -pady 20

	frame $t4.f5 -width 0 -relief groove -borderwidth 0
	pack  $t4.f5 -side bottom -expand 0 -pady 20

	foreach ref $orderedNames {

		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)

			if { $num_of_trials <= 5} {

				set drawingWindow($trial\_canP) [            \
					canvas $t4.f4.drawingWindow($trial\_canP)  \
						-width $can_width                        \
						-height $can_height]

			} else {

				if { $trial <= ($num_of_trials / 2) } {

					set drawingWindow($trial\_canP) [            \
						canvas $t4.f4.drawingWindow($trial\_canP)  \
							-width $can_width                        \
							-height $can_height]

				} elseif { $trial > ($num_of_trials / 2) } {

					set drawingWindow($trial\_canP) [            \
						canvas $t4.f5.drawingWindow($trial\_canP)  \
							-width $can_width                        \
							-height $can_height]
				}
			}

			pack $drawingWindow($trial\_canP) -side left -anchor nw
		}
	}
}

proc build_color_spectrum {} {

	set can_w 857
	set can_h 120

	global canC

	toplevel .s
	wm title .s "Color Spectrum"

	set t5 ".s"

	frame $t5.f1 -width 0
	pack  $t5.f1 -side left -anchor nw  -fill x -expand 0

	set canC [canvas $t5.f1.canC  -width $can_w -height $can_h]
	pack $t5.f1.canC -side left -anchor nw

	for {set cg 200} {$cg >= 0} {incr cg -1} {

		set c         [expr $cg/100.0]
		set redVal    [expr int( 65535 - (abs($c / 2) * 65535) )]
		set cgreenVal [expr int( 65535 - (abs($c / 2) * 45535) )]
		set blueVal   29
		set colorVal  [format "#%04x%04x%04x" $redVal $cgreenVal $blueVal ]

		$t5.f1.canC  create rectangle [expr 2*(215 - $cg)] 0 [expr 2*(200 - ($cg-10))] 100  -fill $colorVal -outline $colorVal
		if {$cg % 25 == 0 && $cg != 0} {
			$t5.f1.canC  create text [expr 2*(210 - $cg)] 100 -text "[expr -1 * $c]" -anchor nw
		}
	}

	for {set cr 0} {$cr <= 200} {incr cr 1} {

		set d         [expr $cr/100.0]
		set redVal    65535
		set greenVal  [expr {int( 65535.0 - (1.0 * $d)  / 2 * 65535.0 )}]
		set blueVal   29
		set colorVal  [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]

		$t5.f1.canC  create rectangle [expr 2*($cr + 215)] 0 [expr 2*($cr + 220)] 100 -fill $colorVal -outline $colorVal

		if {$cr % 25 == 0} {
			$t5.f1.canC  create text [expr 2*($cr +213)] 100 -text  "$d" -anchor nw
		}
	}
}
