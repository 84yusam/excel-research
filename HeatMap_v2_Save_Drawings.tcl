proc set_drawing_location {} {

  global fileSaveLocation

  set fileSaveLocation [tk_chooseDirectory -title "Where should the files be saved?" ]

  if {$fileSaveLocation eq ""} {
    set fileSaveLocation "choose output file location"
  }
}

proc save_all_drawing {} {

  global loadedFileVis
  global loadedFile_trial
  global loadedFile_timedata
  global orderedNames

  global canT
  global canD
  global canP
  #global canC
  global drawingWindow
  global currentMaze


  foreach ref $orderedNames {
    if { $loadedFileVis($ref) eq "true" } {

      set id [lindex [split $ref "-"] 0]
      set mazenum [lindex [split $ref "-"] 1]
      set trial [lindex [split $ref "-"] 2]

      save_drawing $drawingWindow($trial\_canT) "z_time\-$id\-$mazenum\-$trial"
      save_drawing $drawingWindow($trial\_canD) "z_dist\-$id\-$mazenum\-$trial"
      save_drawing $drawingWindow($trial\_canP) "Pesky_eff\-$id\-$mazenum\-$trial"
      #save_drawing $canC                         "Color_Spectrum"

    }
  }

puts "all drawings are saved"

}

proc save_drawing {can fileInfo} {

  global fileSaveLocation
  global can_width
  global can_height
  global drawingFileType

  if {$fileSaveLocation eq "choose output file location"} {
    tk_messageBox -message "You must first select a location and file name."
    return
  }

  set fileSaveName "$fileSaveLocation/$fileInfo.$drawingFileType"

  $can postscript -file $fileSaveName -width [expr $can_width*3] -height [expr $can_height * 3]
}
