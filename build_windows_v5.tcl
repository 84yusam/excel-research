proc build_window { maze id_folder num_trials } {
  global can_width

  set folderName [file tail $id_folder]
  set id [split_id $folderName]

  toplevel .$id$maze
  wm title .$id$maze "HeatMaps for $id $maze"

  set t1 ".$id$maze"

  frame $t1.f1 -width 0
  pack  $t1.f1 -side top -anchor nw -fill x

  button $t1.f1.b1 -text "Save all drawings in one image"
  pack   $t1.f1.b1 -side top -anchor nw -fill x -expand true

  if {$num_trials == 1} {
    set maincanwidth $can_width
  } elseif {$num_trials ==2} {
    set maincanwidth [expr 2*$can_width]
  } else {
    set maincanwidth  [expr 3*$can_width]
  }

  set  maincanvas [canvas $t1.f1.maincan -bg black -width $maincanwidth]
  pack $maincanvas -side top -anchor nw -fill both -expand true

  #set contents [glob -directory $id_folder *]
  #foreach item $contents {
  #  if {[file isdirectory $item] == 1} {
  #    set logs $item
  #  }
  #}

  #set maze_list [select_maze $maze $logs]
  #iterate_trials $maze_list $t1

  return $maincanvas
}


#--draws in the canvases for each trial
proc process_trial_canvas { maincan num_trials trial_cnt file_name } {
  global can_width
  global can_height
  global current_maze_dir

  split_data_file $file_name

  set subcan($trial_cnt) [canvas $maincan.can$trial_cnt -height $can_height -width $can_width]

  #choose row based on the trial number of the canvas
  if {$current_maze_dir(maze_iteration) <= 3} {
    set xLoc [expr $current_maze_dir(maze_iteration)*$can_width]
    set yLoc 0
  } else {
    set xLoc [expr [expr $current_maze_dir(maze_iteration) - 1]*$can_width]
    set yLoc $can_height
  }

  set win$trial_cnt [$maincan create window $xLoc $yLoc -width $can_width -height $can_height -window $subcan($trial_cnt)]

  #TEMP
  set tmp [expr $can_width / 2]
  $subcan($trial_cnt) create rect $tmp $tmp [expr $tmp + 10] [expr $tmp + 10] -fill blue

}
