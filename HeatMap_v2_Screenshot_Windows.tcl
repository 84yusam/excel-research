proc set_drawing_location {} {
  
	global fileSaveLocation

	set fileSaveLocation \
		[tk_chooseDirectory -title "Where should the files be saved?" ]

	if {$fileSaveLocation eq ""} {
		set fileSaveLocation "choose output file location"
	}
}

proc save_all_drawing {} {

	global loadedFileVis
	global loadedFile_trial
	global loadedFile_timedata
	global orderedNames

	global t2 
	global t3 
	global t4

	foreach ref $orderedNames {
		if { $loadedFileVis($ref) eq "true" } {

			set id [lindex [split $ref "-"] 0]
			set mazenum [lindex [split $ref "-"] 1]
			set trial [lindex [split $ref "-"] 2]
		}
	}

	windowToFile $t2 "z_time\-$id\-$mazenum"
	windowToFile $t3 "z_dist\-$id\-$mazenum"
	windowToFile $t4 "Pesky_eff\-$id\-$mazenum"

	puts "all drawings are saved"
}

proc captureWindow { win } {

	package require Img

	regexp {([0-9]*)x([0-9]*)\+([0-9]*)\+([0-9]*)} [winfo geometry $win] - w h x y

	set image [image create photo -format window -data $win]

	foreach child [winfo children $win] {
		captureWindowSub $child $image 0 0
	}

	return $image
}

proc captureWindowSub { win image px py } {

	if {![winfo ismapped $win]} {
		return
	}

	regexp {([0-9]*)x([0-9]*)\+([0-9]*)\+([0-9]*)} [winfo geometry $win] - w h x y

	incr px $x
	incr py $y

	set tempImage [image create photo -format window -data $win]

	$image copy $tempImage -to $px $py
	image delete $tempImage

	foreach child [winfo children $win] {
		captureWindowSub $child $image $px $py
	}
}

proc windowToFile { win fileInfo} {

	global fileName

	set image [captureWindow $win]

	global fileSaveLocation
	global can_width
	global can_height

	if {$fileSaveLocation eq "choose output file location"} {
		tk_messageBox -message "You must first select a location and file name."
		return
	}

	set fileSaveName "$fileSaveLocation/$fileInfo.gif"
 
	if {[llength $fileSaveName]} {
		$image write -format gif $fileSaveName
		puts "Written to file: $fileSaveName"
	} else {
		puts "Write cancelled"
	}

	image delete $image
}
