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
  pack  $t1.f2 -side top -anchor nw -fill x

  button $t1.f2.b1 -text "Save drawings individually"
  pack   $t1.f2.b1 -side left -anchor nw -fill x -expand true

  frame $t1.f3 -width 0
  pack  $t1.f3 -side top -anchor nw -fill both -expand true

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

  set  maincanvas [canvas $t1.f3.maincan -width $maincanwidth -height $maincanheight]
  pack $maincanvas -side top -anchor nw -expand false

  $t1.f1.b1 configure -command [list save_all_drawings $maincanvas $maincanheight $maincanwidth $id $maze]
  $t1.f2.b1 configure -command [list save_individual_drawing $maincanvas $num_trials $id $maze]

  return $maincanvas
}


#--draws in the canvases for each trial
proc process_trial_canvas { maincan num_trials trial_cnt file_name } {
  global can_width
  global can_height
  global current_maze_dir

  set current_trial [expr $trial_cnt + 1]

  split_data_file [file tail $file_name]

  set subcan($current_trial) [canvas $maincan.can$current_trial -height $can_height -width $can_width]

  #choose row based on the trial number of the canvas
  if {$current_trial <= 3} {
    set xLoc [expr $trial_cnt*$can_width]
    set yLoc 0
  } else {
    set xLoc [expr [expr $trial_cnt - 3]*$can_width]
    set yLoc $can_height
  }

  set win$current_trial [$maincan create window $xLoc $yLoc -width $can_width -height $can_height -anchor nw -window $subcan($current_trial)]
  $subcan($current_trial) create text 125 300 \
                      -text "ID: $current_maze_dir(dir_date)$current_maze_dir(dir_time)$current_maze_dir(dir_iteration) \
                      $current_maze_dir(maze) Trial $current_maze_dir(maze_iteration)"

  return $subcan($current_trial)

}

proc choose_aggs { dirname type id_list } {
  global choice
  #set choice "Choose a maze."

  toplevel .chooseaggs$dirname$type
  wm title .chooseaggs$dirname$type "Choose Aggregate Mazes $dirname $type"

  set ca ".chooseaggs$dirname$type"

  set mazeoptions [lsort [get_aggregate_list $id_list]]

  frame $ca.f1 -width 0
  pack  $ca.f1 -side top -anchor nw -fill x -expand true
  label $ca.f1.instructions -height 1 -width 50 -text "$dirname $type\: Choose up to 6 mazes to compare."
  pack  $ca.f1.instructions -side top -anchor nw

  for {set i 1} {$i <= 6} {incr i} {
    set choice($dirname$type$i) "Choose a maze."
    set framenum [expr $i + 1]
    frame $ca.f$framenum -width 0
    pack  $ca.f$framenum -side top -anchor nw -fill x -expand true
    label $ca.f$framenum.txt -height 1 -width 8 -text "Choice $i"
    pack  $ca.f$framenum.txt -side top -anchor nw -padx 10
    ttk::combobox $ca.f$framenum.options -values $mazeoptions -textvar choice($dirname$type$i)
    pack  $ca.f$framenum.options -side top -anchor nw -padx 10
  }

  frame  $ca.f8 -width 0
  pack   $ca.f8 -side top -anchor nw -fill x -expand true
  button $ca.f8.b1 -text "Build Aggregate Images" -command [list build_agg_windows $dirname $type]
  pack   $ca.f8.b1 -side top -anchor nw -fill x -expand true -pady 10
}

proc build_agg_windows {dirname type} {
  global choice
  global can_width
  global can_height

  set agg_mazes {}

  for {set i 1} {$i <= 6} {incr i} {
    if {$choice($dirname$type$i) ne "Choose a maze."} {
      lappend agg_mazes $choice($dirname$type$i)
    }
  }
  set num_agg [llength $agg_mazes]
  set lowerdirname [string tolower $dirname]


  toplevel .$lowerdirname$type
  wm title .$lowerdirname$type "Aggregate Mazes for $dirname $type"

  set aw ".$lowerdirname$type"

  frame $aw.f1 -width 0
  pack  $aw.f1 -side top -anchor nw -fill x

  button $aw.f1.b1 -text "Save all drawings in one image"
  pack   $aw.f1.b1 -side top -anchor nw -fill x -expand true

  frame $aw.f2 -width 0
  pack  $aw.f2 -side top -anchor nw -fill x

  button $aw.f2.b1 -text "Save drawings individually"
  pack   $aw.f2.b1 -side left -anchor nw -fill x -expand true

  frame $aw.f3 -width 0
  pack  $aw.f3 -side top -anchor nw -fill both -expand true

  if {$num_agg == 1} {
    set maincanwidth $can_width
  } elseif {$num_agg == 2} {
    set maincanwidth [expr 2*$can_width]
  } else {
    set maincanwidth  [expr 3*$can_width]
  }

  if {$num_agg > 3} {
    set maincanheight [expr 2*$can_height]
  } else {
    set maincanheight [expr $can_height]
  }

  set  maincanvas [canvas $aw.f3.maincan -width $maincanwidth -height $maincanheight]
  pack $maincanvas -side top -anchor nw -expand false

  return $maincanvas
}

proc process_agg_canvas { maincanvas maze } {
  global agg_maze_files
  global can_width
  global can_height

}
