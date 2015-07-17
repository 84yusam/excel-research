#-- goes into the given directory and finds all the IDs (folders) in it
proc get_ids { dir } {
  global folderList

  set folderList($dir) {}
  set contents [glob -directory $dir *]
  foreach item $contents {
    if {[file isdirectory $item] == 1} {
      lappend folderList($dir) $item
    }
  }

  separate_type $dir $folderList($dir)
}

#-- separates the folders based on reading type
proc separate_type { directory folderList } {
  global typical_dirs
  global atypical_dirs

  set typical_dirs($directory) {}
  set atypical_dirs($directory) {}

  foreach item $folderList {
    set type [lindex [split $item _] 2]
    if {$type == 1} {
      lappend typical_dirs($directory) $item
    } else {
      lappend atypical_dirs($directory) $item
    }
  }

  load_ids $directory $typical_dirs($directory) $atypical_dirs($directory)
}

#-- identifies the mazes for each individual
proc get_mazes { folder } {
  global current_maze_dir

  set contents [glob -directory $folder *]
  foreach item $contents {
    if {[file isdirectory $item] == 1} {
      set logs $item
    }
  }

  set list_mazes {}

  set contents [glob -directory $logs *]

  foreach item $contents {
    if {[split_data_file $item]} {
      set repeat "false"
      foreach maze $list_mazes {
        if {$maze eq $current_maze_dir(maze)} {
          set repeat "true"
        }
      }
      if {$repeat eq "false"} {
        lappend list_mazes $current_maze_dir(maze)
      }
    }
  }

  return $list_mazes
}


# loads data into maps, taking note of times,dates, and
# positions as displayed in name
proc load_data { filename } {

  set fh [open $filename r]

  set first 1
  set location   {}
  set timeValues {}

  while {![eof $fh]} {

    set data [gets $fh]

    if {[string length $data] == 0} {

      set data [split $data]
      break
    }

    set dateTime [split [lindex $data 0] "T"]
    set position [split [lindex $data 1] ","]

    set trial [lindex [split $filename "-"] 2]

    set dateVal  [split [lindex $dateTime 0] "-"]
    set timeVal  [lindex [split $dateTime] 1]

    set xval [lindex $position 0]
    set yval [lindex $position 1]
    set zval [lindex $position 2]

    lappend location   $xval
    lappend location   $yval

    lappend timeValues [list $xval $yval $timeVal $trial]

  }

  close $fh

  return [list $location $timeValues]
}

proc iterate_trials { maze id_folder } {

  set contents [glob -directory $id_folder *]
  foreach item $contents {
    if {[file isdirectory $item] == 1} {
      set logs $item
    }
  }

  set file_list [select_maze $maze $logs]

  set path_list {}
  set time_data {}

  foreach trial $file_list {
    set retVal [process_trial_data $trial]
    lappend path_list [lindex $retVal 0]
    lappend time_data [lindex $retVal 1]
  }

  # precompute information for current maze
  compute_ztime     $time_data
  compute_zdist     $time_data
  compute_PE_matrix [llength $time_data]

  #build canvas(es) for current maze
  set maincanvas [build_window $maze $id_folder [llength $file_list]]
  set trial_cnt 0
  foreach trial $file_list {
    set curr_path_list [lindex $path_list $trial_cnt]
    set curr_time_data [lindex $time_data $trial_cnt]

    set newcan [process_trial_canvas $maincanvas [llength $file_list] $trial_cnt $trial]
    create_draw_pesky_maze $newcan $maze $trial_cnt $curr_path_list $curr_time_data

    incr trial_cnt
  }

}

proc process_trial_data {trial} {

  global current_maze_dir

  if {![regexp {^(.+)\_(.+)\_(.+)\-(.+)\-(.+)\-(\d+)\.(\d+)\.txt$} $trial match \
      dir_date dir_time dir_iteration\
      maze_number maze_trial \
      file_date file_time ]} {
    puts "Error in process_trial_data"
    #puts "dest  $dest_parent"
    puts "trial $trial"
  }

  # load trial data
  set data      [load_data $trial]
  set path_list [lindex $data 0]
  set time_data [lindex $data 1]

  # return generated information
  return [list $path_list $time_data]
}

proc get_aggregate_list { id_list } {
  global current_maze_dir
  global agg_maze_files
  set mazelist {}

  foreach folder $id_list {
    set contents [glob -directory $folder *]
    foreach item $contents {
      if {[file isdirectory $item]} {
        set logs $item
      }
    }
    set contents [glob -directory $logs *]
    foreach item $contents {
      if {[split_data_file $item]} {
        lappend agg_maze_files($current_maze_dir(maze)) $item
      }
    }
  }

  #--mazelist is the different mazes that are options
  foreach {maze filelist} [array get agg_maze_files] {
    lappend mazelist $maze
  }
  return $mazelist
}

proc iterate_aggregate { maze } {
  global agg_maze_files

}
