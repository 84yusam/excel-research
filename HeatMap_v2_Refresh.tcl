proc refresh_all_drawings {} {

	global loadedFileVis
	global loadedFile_trial
	global orderedNames

	global canT
	global canD
	global canP

	global drawingWindow

	foreach ref $orderedNames {
		if { $loadedFileVis($ref) eq "true" } {

			set trial $loadedFile_trial($ref)

			refresh_drawing $ref $drawingWindow($trial\_canT)                 \
				$trial "drawgrid" "drawouterwalls" "drawinnerwalls" "ztime"
			refresh_drawing $ref $drawingWindow($trial\_canD)                 \
				$trial "drawgrid" "drawouterwalls" "drawinnerwalls" "zdist"
			refresh_drawing $ref $drawingWindow($trial\_canP)                 \
				$trial "drawgrid" "drawouterwalls" "drawinnerwalls" "pesky_eff"

			$drawingWindow($trial\_canT) \
				create text 150 300        \
				-text "Trial $trial"       \
				-anchor nw
			$drawingWindow($trial\_canD) \
				create text 150 300        \
				-text "Trial $trial"       \
				-anchor nw
			$drawingWindow($trial\_canP) \
				create text 150 300        \
				-text "Trial $trial"       \
				-anchor nw
		}
	}
}
 
proc refresh_drawing {ref can trial item1 item2 item3 item4} {

	global currentMaze
	global loadedFileVis
	global loadedFile_data
	global loadedFile_trial
	global zscore_time

	$can delete all

	if { $item1 eq "drawgrid"       } { draw_grid        $can }
	if { $item2 eq "drawouterwalls" } { draw_outer_walls $can }
	if { $item3 eq "drawinnerwalls" } { draw_inner_walls $currentMaze $can }

	switch -exact $item4 {
		"ztime"     { draw_path_ztime  $ref $can $trial }
		"zdist"     { draw_path_zdist  $ref $can $trial }
		"pesky_eff" { draw_path_PE     $ref $can $trial }
	}
}
