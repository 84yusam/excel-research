package require Tk

#####========= SOURCE FILES ========#####
source load_data_v5.tcl
source directory_tools_v5.tcl
source build_windows_v5.tcl
source grid_info_v5.tcl
source zscore_distance_v5.tcl
source zscore_pe_v5.tcl
source zscore_time_v5.tcl

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

proc load_directory {} {
  global numDirs

  set directory [tk_chooseDirectory -mustexist true -title "Choose a source."]
  set dirname [file tail $directory]

  incr numDirs

  label .f2.dir$numDirs -text "$numDirs) $dirname"
  pack  .f2.dir$numDirs -side top -anchor nw -expand 0

  create_tabs $directory $dirname
  get_ids $directory
}

proc create_tabs { directory dirname } {
  global numDirs
  global new_typical
  global new_atypical
  global typical
  global atypical

  if {$numDirs == 1} {
    toplevel .typical
    wm title .typical "Typical Individuals"
    set typical  [ttk::notebook .typical.tabs]
    pack .typical.tabs -side top -anchor nw -expand true
    toplevel .atypical
    wm title .atypical "Atypical Individuals"
    set atypical [ttk::notebook .atypical.tabs]
    pack .atypical.tabs -side top -anchor nw -expand true
  }

  $typical add [frame .typical.tabs.f$numDirs] -text $dirname
  $atypical add [frame .atypical.tabs.f$numDirs] -text $dirname

  set new_typical  ".typical.tabs.f$numDirs"
  set new_atypical ".atypical.tabs.f$numDirs"

}

proc load_ids { directory typical atypical } {
  global num_ids
  global id
  global new_typical
  global new_atypical

  set num_ids($typical) 0
  set num_ids($atypical) 0

  foreach item $typical {
    incr num_ids($typical)
    set id($item) [file tail $item]
    set frame($item) "$new_typical.id$num_ids($typical)"
    frame $frame($item) -width 0
    pack  $frame($item) -side top -anchor nw -fill x -expand true
    label $frame($item).txt -height 1 -width 25 -text "ID: $id($item)"
    pack  $frame($item).txt -side top -anchor nw -expand true

    load_mazes $frame($item) [get_mazes $item] $item
  }

  foreach item $atypical {
    incr num_ids($atypical)
    set id($item) [file tail $item]
    set frame($item) "$new_atypical.id$num_ids($atypical)"
    frame $frame($item) -width 0
    pack  $frame($item) -side top -anchor nw -fill x -expand true
    label $frame($item).txt -height 1 -width 25 -text "ID: $id($item)"
    pack  $frame($item).txt -side top -anchor nw -expand true

    load_mazes $frame($item) [get_mazes $item] $item
  }
}

proc load_mazes { frame mazes id_folder } {

  frame $frame.mazes -width 0
  pack  $frame.mazes -side top -anchor nw -fill x -expand true
  foreach maze $mazes {
    button $frame.mazes.$maze -height 1 -width 14 -text "Build $maze" -command [list iterate_trials $maze $id_folder]
    pack  $frame.mazes.$maze -side left -anchor nw -padx 10 -pady 10
  }
}
