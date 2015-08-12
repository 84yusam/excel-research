#-- builds the window for displaying the images for a particular maze
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

  #-- set the size of the main canvas based on the number of trials
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

  #--choose row based on the trial number of the canvas
  if {$current_trial <= 3} {
    set xLoc [expr $trial_cnt*$can_width]
    set yLoc 0
  } else {
    set xLoc [expr [expr $trial_cnt - 3]*$can_width]
    set yLoc $can_height
  }

  #-- creates a canvas within a canvas to allow user to save indiv. and grouped images
  set win$current_trial [$maincan create window $xLoc $yLoc -width $can_width -height $can_height -anchor nw -window $subcan($current_trial)]
  $subcan($current_trial) create text 125 300 \
                      -text "ID: $current_maze_dir(dir_date)$current_maze_dir(dir_time)$current_maze_dir(dir_iteration) \
                      $current_maze_dir(maze) Trial $current_maze_dir(maze_iteration)"

  return $subcan($current_trial)

}

#-- builds the window prompting the user to choose the mazes to show the aggregate for
proc choose_aggs { dirname type id_list } {
  global choice

  toplevel .chooseaggs$dirname$type
  wm title .chooseaggs$dirname$type "Choose Aggregate Mazes $dirname $type"

  set ca ".chooseaggs$dirname$type"

  set mazeoptions [lsort [get_aggregate_list $id_list]]

  frame $ca.f1 -width 0
  pack  $ca.f1 -side top -anchor nw -fill x -expand true
  label $ca.f1.instructions -height 1 -width 50 -text "$dirname $type\: Choose up to 6 mazes to compare."
  pack  $ca.f1.instructions -side top -anchor nw

  set framenum 2
  foreach option $mazeoptions {
    frame       $ca.f$framenum -width 0
    pack        $ca.f$framenum -side top -anchor nw -fill x -expand true
    checkbutton $ca.f$framenum.$option -variable choice($dirname$type$option) \
                                       -command [list check_num_selected $dirname $type $option $mazeoptions $ca.f$framenum.$option]
    pack        $ca.f$framenum.$option -side left -anchor nw
    label       $ca.f$framenum.txt$option -height 1 -width 7 -text $option
    pack        $ca.f$framenum.txt$option -side left -anchor nw

    incr framenum
  }

  frame  $ca.f8 -width 0
  pack   $ca.f8 -side top -anchor nw -fill x -expand true
  button $ca.f8.b1 -text "Build Aggregate Images" -command [list build_agg_windows $dirname $type $mazeoptions]
  pack   $ca.f8.b1 -side top -anchor nw -fill x -expand true -pady 10
}

#-- builds the window for displaying the aggregate mazes
proc build_agg_windows {dirname type mazeoptions} {
  global choice
  global can_width
  global can_height

  set agg_mazes {}

  foreach option $mazeoptions {
    if {$choice($dirname$type$option)} {
      lappend agg_mazes $option
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

  set choicenum 1
  foreach maze $agg_mazes {
    set subcan [process_agg_canvas $dirname $type $choicenum $maincanvas $maze]
    process_agg_paths $subcan $maze
    incr choicenum
  }

  $aw.f1.b1 configure -command [list save_all_agg $maincanvas $maincanheight $maincanwidth $dirname $type]
  $aw.f2.b1 configure -command [list save_individual_agg $maincanvas $agg_mazes $dirname $type]
}

#--checks how many mazes have been selected for the aggregate window
proc check_num_selected { dirname type maze optionslist currbutton } {
  global choice

  set count 0
  foreach option $optionslist {
    if {$choice($dirname$type$option)} {
      incr count
    }
  }
  if {$count > 6} {
    tk_messageBox -message "Please only choose up to 6 mazes to compare."
    $currbutton deselect
  }
}

#-- creates the subcanvases for the aggregate maze images
proc process_agg_canvas { dirname type choicenum maincan maze } {
  global agg_maze_files
  global can_width
  global can_height

  set subcan($dirname$type$maze) [canvas $maincan.can$dirname$type$maze -height $can_height -width $can_width]
  if {$choicenum <= 3} {
    set xLoc [expr [expr $choicenum - 1]*$can_width]
    set yLoc 0
  } else {
    set xLoc [expr [expr $choicenum - 4]*$can_width]
    set yLoc $can_height
  }

  $maincan create window $xLoc $yLoc -width $can_width -height $can_height -anchor nw -window $subcan($dirname$type$maze)
  $subcan($dirname$type$maze) create text 125 300 -text "$dirname $type aggregate $maze"
  return $subcan($dirname$type$maze)
}

#-- draws in paths for aggregate images
proc process_agg_paths {canvas maze} {
  global agg_maze_files
  foreach item $agg_maze_files($maze) {
    set retval [process_trial_data $item]
    lappend path_list [lindex $retval 0]
  }
  create_draw_aggregate_maze $canvas $maze $path_list
}
