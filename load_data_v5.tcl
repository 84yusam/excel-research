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
