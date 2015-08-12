package require Tk

#####========= SOURCE FILES ========#####
source load_data_v5.tcl
source directory_tools_v5.tcl
source build_windows_v5.tcl
source grid_info_v5.tcl
source zscore_distance_v5.tcl
source zscore_pe_v5.tcl
source zscore_time_v5.tcl
source create_draw_mazes_v5.tcl
source draw_grid_v5.tcl
source save_images_v5.tcl

#####========= PROGRAM STARTS HERE ========#####

wm title . "HeatMap_v5"
wm minsize . 50 100

global numDirs

set numDirs 0

frame .f1 -width 0
pack  .f1 -side top -anchor nw  -fill x -expand 0

button .f1.b1 -text "Click here to upload a directory." -width 50 -command load_directory
pack   .f1.b1 -side top -anchor nw -expand 0

labelframe .f2 -width 0 -text "Uploaded Directories"
pack       .f2 -side top -anchor nw -fill both -expand 0


#####========= PROCS ========#####

#-- prompts the user to upload a directory
proc load_directory {} {
  global numDirs

  set directory [tk_chooseDirectory -mustexist true -title "Choose a source."]
  set dirname [file tail $directory]

  incr numDirs

  label .f2.dir$numDirs -text "$numDirs) $dirname"
  pack  .f2.dir$numDirs -side top -anchor nw -expand 0

  create_tabs $directory
  get_ids $directory
}

#-- creates a new tab for each additional directory
proc create_tabs { directory } {
  global numDirs
  global new_typical
  global new_atypical
  global ids

  if {$numDirs == 1} {
    toplevel .ids
    wm title .ids "All Individuals"
    set ids  [ttk::notebook .ids.tabs]
    pack .ids.tabs -side top -anchor nw -expand true
  }

  $ids add [frame .ids.tabs.f$numDirs] -text [file tail $directory]

  labelframe .ids.tabs.f$numDirs.typical -width 0 -text "Typical"
  pack       .ids.tabs.f$numDirs.typical -side left -anchor nw -expand true
  labelframe .ids.tabs.f$numDirs.atypical -width 0 -text "Atypical"
  pack       .ids.tabs.f$numDirs.atypical -side left -anchor nw -expand true

  set new_typical  ".ids.tabs.f$numDirs.typical"
  set new_atypical ".ids.tabs.f$numDirs.atypical"

}

#-- goes through the lists of typical and atypical IDs and lists each one with its mazes
proc load_ids { directory typical atypical } {
  global num_ids
  global id
  global new_typical
  global new_atypical

  set num_ids(typical) 0
  set num_ids(atypical) 0

  set dirname [file tail $directory]

  frame $new_typical.agg -width 0
  pack  $new_typical.agg -side top -anchor nw -fill x -expand true
  frame $new_atypical.agg -width 0
  pack  $new_atypical.agg -side top -anchor nw -fill x -expand true

  button $new_typical.agg.b -height 1 -width 9 -text "Aggregate" -command [list choose_aggs $dirname "Typical" $typical]
  pack   $new_typical.agg.b -side right -anchor ne
  button $new_atypical.agg.b -height 1 -width 9 -text "Aggregate" -command [list choose_aggs $dirname "Atypical" $atypical]
  pack   $new_atypical.agg.b -side right -anchor ne

  foreach item $typical {
    incr num_ids(typical)
    set id($item) [file tail $item]
    set frame($item) "$new_typical.id$num_ids(typical)"
    frame $frame($item) -width 0
    pack  $frame($item) -side top -anchor nw -fill x -expand true
    label $frame($item).txt -height 1 -width 25 -text "ID: $id($item)"
    pack  $frame($item).txt -side top -anchor nw -expand true

    load_mazes $frame($item) [get_mazes $item] $item
  }

  foreach item $atypical {
    incr num_ids(atypical)
    set id($item) [file tail $item]
    set frame($item) "$new_atypical.id$num_ids(atypical)"
    frame $frame($item) -width 0
    pack  $frame($item) -side top -anchor nw -fill x -expand true
    label $frame($item).txt -height 1 -width 25 -text "ID: $id($item)"
    pack  $frame($item).txt -side top -anchor nw -expand true

    load_mazes $frame($item) [get_mazes $item] $item
  }
}

#-- create the button for each maze
proc load_mazes { frame mazes id_folder } {

  frame $frame.mazes -width 0
  pack  $frame.mazes -side top -anchor nw -fill x -expand true
  foreach maze $mazes {
    button $frame.mazes.$maze -height 1 -width 6 -text "$maze" -command [list iterate_trials $maze $id_folder]
    pack  $frame.mazes.$maze -side left -anchor nw -padx 10 -pady 10
  }
}
