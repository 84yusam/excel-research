proc refresh_all_drawings {} {

	global loadedFileVis
	global loadedFile_trial
	global loadedFile_mazenum
	global loadedFile_id
	global orderedNames
	global currentMaze

	global canT
	global canD
	global canP

	global drawingWindow

	foreach ref $orderedNames {
		if { $loadedFileVis($ref) eq "true" } {

			set trial   $loadedFile_trial($ref)
			set mazenum $loadedFile_mazenum($ref)
			set id      $loadedFile_id($ref)

			set currentMaze "Maze $mazenum"

			refresh_drawing $ref $drawingWindow($mazenum$trial$id\_canT)                 \
				$trial "drawgrid" "drawouterwalls" "drawinnerwalls" "ztime" $currentMaze
			refresh_drawing $ref $drawingWindow($mazenum$trial$id\_canD)                 \
				$trial "drawgrid" "drawouterwalls" "drawinnerwalls" "zdist" $currentMaze
			refresh_drawing $ref $drawingWindow($mazenum$trial$id\_canP)                 \
				$trial "drawgrid" "drawouterwalls" "drawinnerwalls" "pesky_eff" $currentMaze

			$drawingWindow($mazenum$trial$id\_canT)          \
				create text 150 300                            \
				-text "ID $id $currentMaze Trial $trial"       \
				-anchor nw
			$drawingWindow($mazenum$trial$id\_canD)          \
				create text 150 300                            \
				-text "ID $id $currentMaze Trial $trial"       \
				-anchor nw
			$drawingWindow($mazenum$trial$id\_canP)          \
				create text 150 300                            \
				-text "ID $id $currentMaze Trial $trial"       \
				-anchor nw
		}
	}
}

proc refresh_drawing {ref can trial item1 item2 item3 item4 mazenum} {

	global loadedFileVis
	global loadedFile_data
	global loadedFile_trial
	global zscore_time

	$can delete all

	if { $item1 eq "drawgrid"       } { draw_grid        $can }
	if { $item2 eq "drawouterwalls" } { draw_outer_walls $can }
	if { $item3 eq "drawinnerwalls" } { draw_inner_walls $mazenum $can }

	switch -exact $item4 {
		"ztime"     { draw_path_ztime  $ref $can $trial }
		"zdist"     { draw_path_zdist  $ref $can $trial }
		"pesky_eff" { draw_path_PE     $ref $can $trial }
	}
}
