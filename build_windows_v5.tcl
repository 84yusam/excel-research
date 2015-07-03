proc build_window { maze id_folder } {
  set folderName [file tail $id_folder]
  set id [split_id $folderName]

  toplevel .$id$maze
  wm title .$id$maze "HeatMaps for $id_folder $maze"

  set t1 ".$id$maze"

  frame $t1.f1 -width 0
  pack  $t1.f1 -side top -anchor nw -fill x

  button $t1.f1.b1 -text "Save all drawings in one image"
  pack   $t1.f1.b1 -side left -anchor nw -fill x -expand true

  set  maincanvas [canvas $t1.f1.maincan]
  pack $maincanvas -side top -anchor nw -fill x -expand true

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
proc process_trial_canvas { maincan num_trials } {

}
