proc split_trial_dir { str } {

  global current_trial_dir

  # puts $str
  
  if {[ regexp "^(.+)\_(.+)\_(.+)$" $str match trial_year trial_time trial_iteration ]} {

    # puts $trial_year
    # puts $trial_time
    # puts $trial_iteration

    set current_trial_dir(year)      $trial_year
    set current_trial_dir(time)      $trial_time
    set current_trial_dir(iteration) $trial_iteration

    return 1

  } else {

    return 0

  }
}

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
