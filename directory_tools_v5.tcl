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
