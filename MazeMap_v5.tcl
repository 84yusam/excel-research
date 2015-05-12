set toggle1 "hi on"

set loadedFiles     {}
set loadedFileCount 0
array set loadedFileVis {}
array set loadedFile_data {}
array set loadedFile_timedata {}
array set loadedFile_trial {}

global loadedFileVis
global loadedFile_trial
global drawingWindow {}

foreach ref [array names loadedFileVis] {
  if { $loadedFileVis($ref) eq "true" } {
    set trial $loadedFile_trial($ref)
    set drawingWindow($trial\_canT) 0
    set drawingWindow($trial\_canD) 0
    set drawingWindow($trial\_canP) 0
  }
}

set dashPattern {2}
set lineWidth   2

array set zscore_time         {}
array set area_cnt_trial_time {}
array set area_cnt_total_time {} 
array set sum_of_time_squares {}
array set squares_time        {}
array set sigma_time          {}
array set tbar                {}
array set zscore_dist         {}
array set area_cnt_trial_dist {}
array set area_cnt_total_dist {} 
array set sum_of_dist_squares {}
array set squares_dist        {}
array set sigma_dist          {}
array set dbar                {}
array set perf_eff            {}

array set gridLocName         {}

set originalGridSize 256    
set originalSize     [expr {$originalGridSize * 6}]

set displayGridSize  40
set displaySize      [expr { $displayGridSize * 6}]

set displayOffset    35 

set can_width  [ expr {$displayOffset * 2 + $displaySize} ]
set can_height [ expr {$displayOffset * 2 + $displaySize} ]

#coordinates of locations of solid lines
array set solidLines {
  "Maze 1"  { 3 0 3 2 0 3 2 3 5 0 5 4 0 5 4 5 }
  "Maze 2"  { 1 0 1 2 3 0 3 2 2 3 4 3 2 3 2 6 }
  "Maze 3"  { 1 2 6 2 1 2 1 4 3 3 6 3 3 3 3 5 }
  "Maze 4"  { 3 1 6 1 3 1 3 3 3 3 4 3 5 3 5 4 0 4 5 4 }
  "Maze 5"  { 0 1 1 1 1 1 1 3 1 3 3 3 2 0 2 1 2 1 4 1 4 1 4 5 }
  "Maze 6"  { 0 1 5 1 0 3 4 3 4 3 4 5 }
  "Maze 7"  { 0 1 3 1 3 1 3 3 4 1 6 1 4 1 4 4 }
  "Maze 8"  { 1 0 1 3 1 3 3 3 4 3 5 3 5 3 5 4 0 4 5 4 }
  "Maze 9"  { 0 1 5 1 1 1 1 4 1 4 3 4 2 3 6 3 4 3 4 5 }
  "Maze 10" { 1 0 1 2 1 2 4 2 5 2 5 4 0 4 5 4 }
  "Maze 11" { 0 1 3 1 4 1 6 1 3 1 3 3 4 1 4 4 1 3 1 5 2 2 2 4 }
  "Maze 12" { 1 0 1 5 1 5 2 5 2 1 2 4 4 4 4 6 }
}

#Coordinates of locations of dashed lines
array set dashedLines {
  "Maze 1"  { 3 1 5 1 1 3 1 5 3 2 5 4 2 3 4 5 5 2 6 2 5 4 6 4 2 5 2 6 4 5 4 6 }
  "Maze 2"  { 1 1 3 1 1 2 6 2 3 3 3 6 4 3 4 6 0 3 2 3 }
  "Maze 3"  { 1 0 1 2 1 4 3 5 3 4 6 4 3 5 6 5 3 2 3 3 }
  "Maze 4"  { 3 0 3 1 3 4 3 6 5 4 5 6 3 3 5 1 0 2 2 4 }
  "Maze 5"  { 0 3 1 3 3 3 3 6 4 0 4 1 4 3 6 3 4 5 6 5 }
  "Maze 6"  { 3 1 3 3 3 3 3 6 4 1 4 3 4 5 4 6 }
  "Maze 7"  { 3 3 3 6 0 3 3 3 4 3 6 3 4 4 6 4 0 3 2 1 4 0 4 1 }
  "Maze 8"  { 1 2 3 0 3 3 6 0 3 4 3 6 5 4 5 6 }
  "Maze 9"  { 1 3 3 1 3 4 3 6 4 4 6 4 4 5 6 5 0 4 1 4 }
  "Maze 10" { 3 0 3 2 4 0 4 2 3 4 3 6 5 4 5 6 }
  "Maze 11" { 4 0 4 1 2 1 2 2 2 4 2 6 4 3 6 3 4 4 6 4 3 3 3 6 }
  "Maze 12" { 2 0 2 1 2 4 2 5 }
}

#Coordinate system of locations
set basic_grid_items {
  "0_1" "0_2" "0_3" "0_4" "0_5"
  "1_0" "1_1" "1_2" "1_3" "1_4" "1_5"
  "2_0" "2_1" "2_2" "2_3" "2_4" "2_5"
  "3_0" "3_1" "3_2" "3_3" "3_4" "3_5"
  "4_0" "4_1" "4_2" "4_3" "4_4" "4_5"
  "5_0" "5_1" "5_2" "5_3" "5_4" "5_5" "0_0" 
}

# grid position is sum of position, displayed grid size, and displayOffSet 
proc gridPos { position } {
  
  global displayOffset
  global displayGridSize
  
  return [ expr {$displayOffset + $position * $displayGridSize} ]
}

# how to change image size (ratio or display size)
proc rawPos { pos } {

    global displayOffset
    global displaySize
    global originalSize

    return [ expr $displayOffset + ($displaySize * ( ($originalSize - $pos) / $originalSize) ) ]
}

proc build_main_window {} {
  
  global toggle1
  global treeview
  global currentMaze
  
  #name of data sourcing window
  wm title . "HeatMaps Data"   

  frame .f1 -width 0
  pack  .f1 -side top -anchor nw  -fill x -expand 0

  button .f1.b2 -command add_data_files -text "Load Data Files" -width 25
  pack   .f1.b2 -side left -anchor nw
  
  frame .f2
  pack  .f2 -side top -anchor nw  -fill both -expand 1

  # Inserted at the root, program chooses id:
  set treeview [ttk::treeview .f2.tree -columns "visible location"]
  $treeview heading visible  -text "Visible"
  $treeview heading location -text "Location"
  $treeview column #0       -width 100 -stretch 1
  $treeview column visible  -width 100 -stretch 1 -anchor center
  $treeview column location -width 300 -stretch 1
  pack $treeview -side left -anchor nw -fill both  -expand 1

  frame .f3 -width 0
  pack  .f3 -side bottom -anchor nw -fill x
  button .f3.b1 -command build_drawing_windows -text "Build Heat Map Windows" -width 50
  pack   .f3.b1 -side bottom -anchor nw -fill x -expand 1


}

source ./MazeMap_v5_Add_Load_Data.tcl

source ./MazeMap_v5_zScore_Time.tcl
source ./MazeMap_v5_zScore_Dist.tcl
source ./MazeMap_v5_zScore_PE.tcl

proc toggle_hiding {fileRef refvalue} {
  
  global treeview
  global loadedFileVis
  
  if {[$treeview set $refvalue visible] eq "true"} {
     #if the user says the file is false, make the visibility false (hide it)
    $treeview set $refvalue visible "false"
    set loadedFileVis($fileRef) "false"
  } else {
     #if the user says the file is true, make the visibility true (plot it)
	$treeview set $refvalue visible "true"
    set loadedFileVis($fileRef) "true"
  }

}

build_main_window 

source ./MazeMap_v5_Save_Drawings.tcl
source ./MazeMap_v5_Build_Windows.tcl
source ./MazeMap_v5_Refresh.tcl
source ./MazeMap_v5_Walls_And_Grid.tcl
