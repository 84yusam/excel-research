proc build_drawing_windows {} {

  global drawingFileType
  global fileSaveLocation
  global currentMaze
  global can_width
  global can_height
  global loadedFileVis
  global loadedFile_trial
  global canT
  global canD
  global canP
  global drawingWindow
  
  array set drawingWindow {}
  array set trialDisplay {}  

  foreach ref [array names loadedFileVis] {

   if { $loadedFileVis($ref) eq "true" } {
    set trial $loadedFile_trial($ref)

   set top [toplevel ".trial-$trial"]
   wm title $top "Heat Maps for Trial $trial"
   
   set trialDisplay($trial) $top
   
   #--- frame one (button to source out files)
   frame $top.f1 -width 0
   pack  $top.f1 -side top -anchor nw -fill x 

   set fileSaveLocation "choose output file location"
   button $top.f1.b3 -command set_drawing_location -textvar fileSaveLocation
   pack   $top.f1.b3 -side left -anchor nw -fill x -expand 1

   #--- frame two (button to save drawing)
   frame $top.f2 -width 0
   pack  $top.f2 -side top -anchor nw -fill x
   
   button $top.f2.b2 -command save_all_drawing -text "save drawing" -width 20
   pack   $top.f2.b2 -side left -anchor nw  -fill x

   #--- frame three (refresh button and what maze number the data is from / should be shown)
   frame $top.f3 -width 0
   pack  $top.f3 -side top -anchor nw -fill x

   button $top.f3.b1 -command refresh_all_drawings -text "refresh drawing" -width 20
   pack   $top.f3.b1 -side left -anchor nw -fill x

   set combolist2  [list "Maze 1" "Maze 2" "Maze 3" "Maze 4"  "Maze 5"  "Maze 6" \
                         "Maze 7" "Maze 8" "Maze 9" "Maze 10" "Maze 11" "Maze 12"  ]
   set currentMaze [lindex $combolist2 0 ]
   ttk::combobox $top.f3.cb2 -values $combolist2 -textvar currentMaze
   pack     $top.f3.cb2 -side left -anchor nw  -fill x

   #--- frame four (display 3 maze maps per trial)
   frame $top.f4 -width 0 -relief groove 
   pack  $top.f4 -side top -expand 0 -pady 20 

    set drawingWindow($trial\_canT) [canvas $top.f4.canT -width $can_width -height $can_height]
    set drawingWindow($trial\_canD) [canvas $top.f4.canD -width $can_width -height $can_height]
    set drawingWindow($trial\_canP) [canvas $top.f4.canP -width $can_width -height $can_height]
    $drawingWindow($trial\_canP) create text 30 290 -text "The heatmap for performance efficiency goes here" -anchor nw
    $drawingWindow($trial\_canD) create text 40 190 -text "The heatmap for distance z-scores goes here" -anchor nw
    $drawingWindow($trial\_canT) create text 35 90 -text "The heatmap for time z-score goes here" -anchor nw
    pack $drawingWindow($trial\_canT) -side left -anchor nw
    pack $drawingWindow($trial\_canD) -side left -anchor nw
    pack $drawingWindow($trial\_canP) -side left -anchor nw

   }
 }
   
}
