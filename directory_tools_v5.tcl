#-- uses the file name to establish information about the maze, trial, and date.
#-- note that dir_iteration is actually the reading type
proc split_data_file { str } {

  global current_maze_dir

  if {[ regexp {^(.+)\_(.+)\_(.+)\-(.+)\-(.+)\-(\d+)\.(\d+)\.txt$} $str match \
            dir_date dir_time dir_iteration\
            maze_number maze_iteration \
            file_date file_time ]} {

    # puts $dir_date
    # puts $dir_time
    # puts $dir_iteration
    # puts $maze_number
    # puts $maze_iteration
    # puts $file_date
    # puts $file_time
    # puts "------"
    set current_maze_dir(dir_date)       $dir_date
    set current_maze_dir(dir_time)       $dir_time
    set current_maze_dir(dir_iteration)  $dir_iteration
    set current_maze_dir(maze)           $maze_number
    set current_maze_dir(maze_iteration) $maze_iteration
    set current_maze_dir(file_date)      $file_date
    set current_maze_dir(file_time)      $file_time

    return 1

  } else {

    return 0

  }
}

#-- given the logs for a particular individual, identify all files that go with a particular maze
proc select_maze {maze logs} {
  global current_maze_dir
  set contents [glob -directory $logs *]
  set maze_list {}
  foreach item $contents {
    if {[split_data_file $item] == 1} {
      if {$current_maze_dir(maze) eq $maze} {
        lappend maze_list $item
      }
    }
  }
  return $maze_list
}

#-- returns the ID without any punctuation
proc split_id { orig_id } {
  set split_1 [split $orig_id _]
  set tmp1 [lindex $split_1 0]
  set tmp2 [lindex $split_1 1]
  set tmp3 [lindex $split_1 2]

  set split_2 [split $tmp1 .]
  set split_3 [split $tmp2 .]

  set tmp4 [lindex $split_2 0]
  set tmp5 [lindex $split_2 1]
  set tmp6 [lindex $split_2 2]

  set tmp7 [lindex $split_3 0]
  set tmp8 [lindex $split_3 1]
  set tmp9 [lindex $split_3 2]

  set final_id $tmp4$tmp5$tmp6$tmp7$tmp8$tmp9$tmp3

  return $final_id
}
