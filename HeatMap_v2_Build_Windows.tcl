proc build_drawing_windows {} {

	global maze_and_trial

	for {set i 1} {$i <= 12} {incr i 1} {
		for {set j 1} {$j <= 6} {incr j 1} {

			if {[info exists maze_and_trial($i$j)] == 1} {
				build_zTime_drawing_window $maze_and_trial($i$j)
				#build_zDist_drawing_window
				#build_PeskyEff_drawing_window
			}
		}
	}

	#build_zTime_drawing_window
	#build_zDist_drawing_window
	#build_PeskyEff_drawing_window
	#build_color_spectrum
}


proc build_zTime_drawing_window { fileList } {

	global loadedFileVis
	global loadedFile_trial
	global loadedFile_mazenum
	global loadedFile_id
	global canT
	global drawingWindow

	set canT 0
	array set drawingWindow {}

	global fileSaveLocation
	global can_width
	global can_height
	global num_of_imgs
	global numAdded
	global orderedNames
	global numFrames
	global t2
	global listMaze
	global listTrial

	set num_of_imgs 0
	#foreach ref [array names loadedFileVis]
	foreach ref $fileList {
		if { $loadedFileVis($ref) eq "true" } {
			incr num_of_imgs
			set listMaze $loadedFile_mazenum($ref)
			set listTrial $loadedFile_trial($ref)
		}
	}

	toplevel .zTime$listMaze$listTrial
	wm title .zTime$listMaze$listTrial "Heat Map using z-Scores for Time"

	set t2 ".zTime$listMaze$listTrial"

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

	#--- frame three (refresh button and what maze number the
	#--- data is from / should be shown)
	frame $t2.f3 -width 0
	pack  $t2.f3 -side top -anchor nw -fill x

	button $t2.f3.b1                  \
		-command refresh_all_drawings   \
		-text "refresh drawing"         \
		-width 20
	pack   $t2.f3.b1 -side left -anchor nw -fill x

	#--- frame four (display all maze maps)
	#calculate the number of frames needed & create them
	global unrounded
	set unrounded [expr [expr $num_of_imgs + 0.0] / 5]
	set numFrames [expr ceil($unrounded)]
	for {set i 0} {$i < $numFrames} {incr i 1} {
		global currentNum
		set currentNum [expr int([expr 4 + $i])]
		frame $t2.f$currentNum -width 0 -relief groove -borderwidth 0
		pack  $t2.f$currentNum -side top -expand 0 -pady 20
	}

	set numAdded 0

	# foreach ref $orderedNames
	foreach ref $fileList {

		if { $loadedFileVis($ref) eq "true" } {

			incr numAdded

			set trial   $loadedFile_trial($ref)
			set mazenum $loadedFile_mazenum($ref)
			set id      $loadedFile_id($ref)

			global unrounded2
			set unrounded2 [expr [expr $numAdded + 0.0] / 5]
			global frames
			set frames [expr ceil($unrounded2)]
			global frameNum
			set frameNum [expr int([expr $frames + 3])]

			set drawingWindow($mazenum$trial$id\_canT)                        \
				[canvas $t2.f$frameNum.drawingWindow($mazenum$trial$id\_canT) \
					-width $can_width -height $can_height]

			pack $drawingWindow($mazenum$trial$id\_canT) -side left -anchor nw
		}
	}
}

proc build_zDist_drawing_window {} {

	global loadedFileVis
	global loadedFile_trial
	global loadedFile_mazenum
	global loadedFile_id
	global canD
	global drawingWindow

	set canD 0

	array set drawingWindow {}

	global prevTD

	set prevTD 0

	global fileSaveLocation
	global currentMaze
	global can_width
	global can_height
	global num_of_imgs
	global orderedNames
	global t3

	set num_of_imgs 0
	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {
			incr num_of_imgs
		}
	}

	toplevel .zDist
	wm title .zDist "Heat Map using z-Scores for Distance"

	set t3 ".zDist"

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

	#--- frame three (refresh button and what maze number the data is from / should be shown)
	frame $t3.f3 -width 0
	pack  $t3.f3 -side top -anchor nw -fill x

	button $t3.f3.b1                \
		-command refresh_all_drawings \
		-text "refresh drawing"       \
		-width 20
	pack   $t3.f3.b1 -side left -anchor nw -fill x


	#--- frame four (display all maze maps)
	#calculate the number of frames needed & create them
	global unrounded
	set unrounded [expr [expr $num_of_imgs + 0.0] / 5]
	set numFrames [expr ceil($unrounded)]
	for {set i 0} {$i < $numFrames} {incr i 1} {
		global currentNum
		set currentNum [expr int([expr 4 + $i])]
		frame $t3.f$currentNum -width 0 -relief groove -borderwidth 0
		pack  $t3.f$currentNum -side top -expand 0 -pady 20
	}

	set numAdded 0

	foreach ref $orderedNames {

		if { $loadedFileVis($ref) eq "true" } {

			incr numAdded

			set trial   $loadedFile_trial($ref)
			set mazenum $loadedFile_mazenum($ref)
			set id      $loadedFile_id($ref)

			global unrounded2
			set unrounded2 [expr [expr $numAdded + 0.0] / 5]
			global frames
			set frames [expr ceil($unrounded2)]
			global frameNum
			set frameNum [expr int([expr $frames + 3])]

			set drawingWindow($mazenum$trial$id\_canD)                        \
				[canvas $t3.f$frameNum.drawingWindow($mazenum$trial$id\_canD) \
					-width $can_width -height $can_height]

			pack $drawingWindow($mazenum$trial$id\_canD) -side left -anchor nw
		}
	}
}

proc build_PeskyEff_drawing_window {} {

	global loadedFileVis
	global loadedFile_trial
	global loadedFile_mazenum
	global loadedFile_id
	global canP
	global drawingWindow

	set canP 0
	array set drawingWindow {}

	global prevTP
	set prevTP 0

	global fileSaveLocation
	global currentMaze
	global can_width
	global can_height
	global num_of_imgs
	global orderedNames

	set num_of_trials 0

	foreach ref [array names loadedFileVis] {
		if { $loadedFileVis($ref) eq "true" } {
			incr num_of_imgs
		}
	}

	toplevel .peskyEff
	wm title .peskyEff "Heat Map using Pesky Efficiency Scores"

	set t4 ".peskyEff"

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

	#--- frame three (refresh button and what maze number the data is from / should be shown)
	frame $t4.f3 -width 0
	pack  $t4.f3 -side top -anchor nw -fill x

	button $t4.f3.b1 -command refresh_all_drawings -text "refresh drawing" -width 20
	pack   $t4.f3.b1 -side left -anchor nw -fill x


	#--- frame four (display all maze maps)
	#calculate the number of frames needed & create them
	global unrounded
	set unrounded [expr [expr $num_of_imgs + 0.0] / 5]
	set numFrames [expr ceil($unrounded)]
	for {set i 0} {$i < $numFrames} {incr i 1} {
		global currentNum
		set currentNum [expr int([expr 4 + $i])]
		frame $t4.f$currentNum -width 0 -relief groove -borderwidth 0
		pack  $t4.f$currentNum -side top -expand 0 -pady 20
	}

	set numAdded 0

	foreach ref $orderedNames {

		if { $loadedFileVis($ref) eq "true" } {

			incr numAdded

			set trial   $loadedFile_trial($ref)
			set mazenum $loadedFile_mazenum($ref)
			set id      $loadedFile_id($ref)

			global unrounded2
			set unrounded2 [expr [expr $numAdded + 0.0] / 5]
			global frames
			set frames [expr ceil($unrounded2)]
			global frameNum
			set frameNum [expr int([expr $frames + 3])]

			set drawingWindow($mazenum$trial$id\_canP)                        \
				[canvas $t4.f$frameNum.drawingWindow($mazenum$trial$id\_canP) \
					-width $can_width -height $can_height]

			pack $drawingWindow($mazenum$trial$id\_canP) -side left -anchor nw
		}
	}
}

# proc build_color_spectrum {} {

	# set can_w 857
	# set can_h 120

	# global canC

	# toplevel .s
	# wm title .s "Color Spectrum"

	# set t5 ".s"

	# frame $t5.f1 -width 0
	# pack  $t5.f1 -side left -anchor nw  -fill x -expand 0

	# set canC [canvas $t5.f1.canC  -width $can_w -height $can_h]
	# pack $t5.f1.canC -side left -anchor nw

	# for {set cg 200} {$cg >= 0} {incr cg -1} {

		# set c         [expr $cg/100.0]
		# set redVal    [expr int( 65535 - (abs($c / 2) * 65535) )]
		# set cgreenVal [expr int( 65535 - (abs($c / 2) * 45535) )]
		# set blueVal   29
		# set colorVal  [format "#%04x%04x%04x" $redVal $cgreenVal $blueVal ]

		# $t5.f1.canC  create rectangle [expr 2*(215 - $cg)] 0 [expr 2*(200 - ($cg-10))] 100  -fill $colorVal -outline $colorVal
		# if {$cg % 25 == 0 && $cg != 0} {
			# $t5.f1.canC  create text [expr 2*(210 - $cg)] 100 -text "[expr -1 * $c]" -anchor nw
		# }
	# }

	# for {set cr 0} {$cr <= 200} {incr cr 1} {

		# set d         [expr $cr/100.0]
		# set redVal    65535
		# set greenVal  [expr {int( 65535.0 - (1.0 * $d)  / 2 * 65535.0 )}]
		# set blueVal   29
		# set colorVal  [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]

		# $t5.f1.canC  create rectangle [expr 2*($cr + 215)] 0 [expr 2*($cr + 220)] 100 -fill $colorVal -outline $colorVal

		# if {$cr % 25 == 0} {
			# $t5.f1.canC  create text [expr 2*($cr +213)] 100 -text  "$d" -anchor nw
		# }
	# }
# }
