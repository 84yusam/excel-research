
source globals_v3.tcl
source directory_tools.tcl
source grid_info_v3.tcl
source grid_draw_v3.tcl
source load_data_v3.tcl

source zscore_time_v3.tcl
source zscore_distance_v3.tcl
source zscore_pe_v3.tcl
source create_draw_mazes_v3.tcl

set src_directory   "../AW1"
set dest_directory  "../AW1_imgs"
set start_directory [pwd]

proc process_trial_data {trial} {

  global current_maze_dir
  
  set canvas_list {}
  
  if {![regexp {^(.+)\_(.+)\_(.+)\-(.+)\-(.+)\-(\d+)\.(\d+)\.txt$} $trial match \
      dir_date dir_time dir_iteration\
      maze_number maze_trial \
      file_date file_time ]} {
    puts "Error in process_trial_data"
    puts "dest  $dest_parent"
    puts "trial $trial"
  }
  
  # determine data source
  set source       "[pwd]/$trial"

  # load trial data
  set data      [load_data $source]
  set path_list [lindex $data 0]
  set time_data [lindex $data 1]

  # return generated information
  return [list $path_list $time_data]
}

proc process_trial_canvas {dest_parent trial win path_list time_data} {

  global current_maze_dir
  
  set canvas_list {}
  puts "Trial $trial"
  if {![regexp {^(.+)\_(.+)\_(.+)\-(.+)\-(.+)\-(\d+)\.(\d+)\.txt$} $trial match \
      dir_date dir_time dir_iteration\
      maze_number maze_trial \
      file_date file_time ]} {
    puts "Error in process_trial_canvas"
    puts "dest  $dest_parent"
    puts "trial $trial"
  }
  
  # determine image destination
  set destination "$dest_parent/$maze_number-$maze_trial-$file_date\.$file_time"

  # create directory where maze will be drawn
  file mkdir $destination

  # generate a group identifier for the single maze
  set group "$maze_trial-[string map {\. ""} $file_date]-[string map {\. ""} $file_time]"

  set tl [toplevel "$win-$group"]

  # create basic canvas
  set f [frame "$tl.fbasic"]
  pack $f -expand true -fill both -side left -anchor nw
  set can [create_draw_base_maze \
             $f $maze_number [expr {$maze_trial - 1}] $path_list]
  lappend canvas_list [list $destination $can "basicgraph.ps"]

  # create zscore time canvas
  set f [frame "$tl.fztime"]
  pack $f -expand true -fill both -side left -anchor nw
  set can [create_draw_zscore_time_maze \
             $f $maze_number [expr {$maze_trial - 1}] $path_list $time_data]
  lappend canvas_list [list $destination $can "zscore_time.ps"]

  # create zscore dist canvas
  set f [frame "$tl.fzdist"]
  pack $f -expand true -fill both -side left -anchor nw
  set can [create_draw_zscore_distance_maze \
             $f $maze_number [expr {$maze_trial - 1}] $path_list $time_data]
  lappend canvas_list [list $destination $can "zscore_dist.ps"]

  # create pesky canvas
  set f [frame "$tl.fzpe"]
  pack $f -expand true -fill both -side left -anchor nw
  set can [create_draw_pesky_maze \
             $f $maze_number [expr {$maze_trial - 1}] $path_list $time_data]
  lappend canvas_list [list $destination $can "zscore_pe.ps"]

  # return generated information
  return $canvas_list
}

proc iterate_trials {curr lst maze data_dir} {

  global current_trial_dir
  puts "\t\t$curr"
  file mkdir "$data_dir/$curr"
  
  set canvas_list {}
  set path_list   {}
  set time_data   {}

  # create common window naming convension
  set win ".[string map {\. ""} $current_trial_dir(year)]-[string map {\. ""} $current_trial_dir(time)]-$current_trial_dir(iteration)-$maze"

  # pull data for current maze
  set trial_cnt 0
  foreach trial $lst {

    set retVal [process_trial_data $trial]

    lappend path_list [lindex $retVal 0]
    lappend time_data [lindex $retVal 1]

    incr trial_cnt
  }

  # precompute information for current maze
  compute_ztime     $time_data
  compute_zdist     $time_data
  compute_PE_matrix [llength $time_data]

  # build canvas for current maze
  set trial_cnt 0
  foreach trial $lst {

    set curr_path_list [lindex $path_list $trial_cnt]
    set curr_time_data [lindex $time_data $trial_cnt]

    set retVal [process_trial_canvas "$data_dir/$curr" \
                 $trial $win $curr_path_list $curr_time_data]

    foreach canItem $retVal {
      lappend canvas_list $canItem
    }

    incr trial_cnt
  }

  # create aggregate toplevel
  set tl [toplevel $win]
    
  # create aggregate path canvas
  set f1 [frame "$tl.f1"]
  pack $f1 -expand true -fill both -side left -anchor nw
  set can [create_draw_aggregate_maze $f1 $maze $path_list "aggPathCan"]
  lappend canvas_list [list "$data_dir/$curr" $can "aggregate_path.ps"]
    
  return $canvas_list
}

proc iterate_mazes {data_dir} {

  global current_maze_dir
  
  # construct trial file data destination
  # puts $data_dir
  file mkdir $data_dir

  # move into the log file directory
  cd Logs

  set curr_maze "first_time"
  set current_data_files {}
  
  set canvas_list {}

  foreach mazeDir [lsort [glob *]] {

    if {[split_data_file $mazeDir]} {

      if {$current_maze_dir(maze) ne $curr_maze} { # new maze detected

        # dump the current accumulated mazes when not the first time
        if {$curr_maze ne "first_time"} {

          foreach item [iterate_trials $curr_maze $current_data_files $curr_maze $data_dir] {
            lappend canvas_list $item
          }


        }

        # initiate file handling for new maze
        set curr_maze $current_maze_dir(maze)
        set current_data_files $mazeDir
        
      } else {                             # continue processing old mazes

        # puts "\t\t\t$mazeDir"
        lappend current_data_files $mazeDir
        
      }
      # if {[file exists $mazeDir]} {
      #
      #   # move into data directory
      #   puts "\t$mazeDir"
      #   cd $mazeDir
      #
      #   iterate_trials
      #
      #   # move out of data directory
      #   cd ..
      # }
    }
  }
  
  # dump the current accumulated mazes when not the first time
  if {$curr_maze ne "first_time"} {

    foreach item [iterate_trials $curr_maze $current_data_files $curr_maze $data_dir] {
      lappend canvas_list $item
    }

  }
  

  cd ..

  return $canvas_list
}


proc iterate_trial_set {data_dir} {

  set canvas_list {}

  foreach expSet [lsort [glob *]] {

    if {[file isdirectory $expSet]} {

      if {[split_trial_dir $expSet]} {

        # move into data directory
        puts $expSet
        cd   $expSet

        foreach item [iterate_mazes "$data_dir/$expSet"] {
          lappend canvas_list $item
        }

        # move out of data directory
        cd ..
      }
    }
  }
  
  return $canvas_list
}

# ========================================
# === program start ======================
# ========================================


# move into data directory
cd $src_directory

# -- create destination directory
if {[file exists $dest_directory]} {
  file delete -force $dest_directory
}
file mkdir $dest_directory

# process work
set canvas_list [iterate_trial_set "[pwd]/$dest_directory"]

# return to initial directory
cd $start_directory

puts [pwd]
puts "code sourced"

proc process_canvas_list {} {

  global canvas_list

  puts "processing"
  
  foreach item $canvas_list {

    set destination [lindex $item 0]
    set can          [lindex $item 1]
    set name         [lindex $item 2]

    $can postscript -file "$destination/$name"

    puts $item
  }
  
  puts "files saved"
}

set b [button .b -command process_canvas_list -text "Process Canvas List"]
pack $b

# source ./HeatMap_v2_zScore_Time.tcl
# source ./HeatMap_v2_zScore_Dist.tcl
# source ./HeatMap_v2_zScore_PE.tcl

# source ./HeatMap_v2_Save_Drawings.tcl
# source ./HeatMap_v2_Screenshot_Windows.tcl
# source ./HeatMap_v2_Build_Windows.tcl
# source ./HeatMap_v2_Refresh.tcl
