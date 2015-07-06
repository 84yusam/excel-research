proc build_window { maze id_folder num_trials } {
  global can_width
  global can_height

  set folderName [file tail $id_folder]
  set id [split_id $folderName]

  toplevel .$id$maze
  wm title .$id$maze "HeatMaps for $id $maze"

  set t1 ".$id$maze"

  frame $t1.f1 -width 0
  pack  $t1.f1 -side top -anchor nw -fill x

  button $t1.f1.b1 -text "Save all drawings in one image"
  pack   $t1.f1.b1 -side top -anchor nw -fill x -expand true

  frame $t1.f2 -width 0
  pack  $t1.f2 -side top -anchor nw -fill both -expand true

  if {$num_trials == 1} {
    set maincanwidth $can_width
  } elseif {$num_trials == 2} {
    set maincanwidth [expr 2*$can_width]
  } else {
    set maincanwidth  [expr 3*$can_width]
  }

  if {$num_trials > 3} {
    set maincanheight [expr 2*$can_height]
  } else {
    set maincanheight [expr $can_height]
  }

  set  maincanvas [canvas $t1.f2.maincan -bg black -width $maincanwidth -height $maincanheight]
  pack $maincanvas -side top -anchor nw -expand false

  $t1.f1.b1 configure -command [list save_all_drawings $maincanvas $maincanheight $maincanwidth $id $maze]

  return $maincanvas
}


#--draws in the canvases for each trial
proc process_trial_canvas { maincan num_trials trial_cnt file_name } {
  global can_width
  global can_height
  global current_maze_dir

  split_data_file [file tail $file_name]

  set subcan($trial_cnt) [canvas $maincan.can$trial_cnt -height $can_height -width $can_width]

  #choose row based on the trial number of the canvas
  if {$current_maze_dir(maze_iteration) <= 3} {
    set xLoc [expr [expr $current_maze_dir(maze_iteration) - 1]*$can_width]
    set yLoc 0
  } else {
    set xLoc [expr [expr $current_maze_dir(maze_iteration) - 4]*$can_width]
    set yLoc $can_height
  }

  set win$trial_cnt [$maincan create window $xLoc $yLoc -width $can_width -height $can_height -anchor nw -window $subcan($trial_cnt)]
  $subcan($trial_cnt) create text 125 300 \
                      -text "ID: $current_maze_dir(dir_date)$current_maze_dir(dir_time)$current_maze_dir(dir_iteration) \
                      $current_maze_dir(maze) Trial $current_maze_dir(maze_iteration)"

  return $subcan($trial_cnt)

}
