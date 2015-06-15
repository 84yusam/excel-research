proc set_drawing_location {} {

  global fileSaveLocation

  set fileSaveLocation [tk_chooseDirectory -title "Where should the files be saved?" ]

  if {$fileSaveLocation eq ""} {
    set fileSaveLocation "choose output file location"
  }
}

proc save_all_drawing {maze trial type cantype} {

  global loadedFileVis
  global loadedFile_trial
  global loadedFile_mazenum
  global loadedFile_id
  global loadedFile_type
  global loadedFile_timedata
  global orderedNames

  global canT
  global canD
  global canP
  global drawingWindow
  global maze_and_trial

  set fileSaveList $maze_and_trial($maze$trial$type)

  foreach ref $fileSaveList {

    set mazenum $loadedFile_mazenum($ref)
    set trial   $loadedFile_trial($ref)
    set type    $loadedFile_type($ref)
    set id      $loadedFile_id($ref)

    if { $cantype eq "canD" } {set zscoretype "z_dist"}
    if { $cantype eq "canT" } {set zscoretype "z_time"}
    if { $cantype eq "canP" } {set zscoretype "Pesky_eff"}

    save_drawing $drawingWindow($mazenum$trial$id$type\_$cantype) "$zscoretype\-$id\-$mazenum\-$trial"
  }

  # foreach ref $orderedNames {
    # if { $loadedFileVis($ref) eq "true" } {

      # set id [lindex [split $ref "-"] 0]
      # set mazenum [lindex [split $ref "-"] 1]
      # set trial [lindex [split $ref "-"] 2]

      # save_drawing $drawingWindow($mazenum$trial$id$type\_canT) "z_time\-$id\-$mazenum\-$trial"
      # save_drawing $drawingWindow($mazenum$trial$id$type\_canD) "z_dist\-$id\-$mazenum\-$trial"
      # save_drawing $drawingWindow($mazenum$trial$id$type\_canP) "Pesky_eff\-$id\-$mazenum\-$trial"
      # #save_drawing $canC                         "Color_Spectrum"

    # }
  # }

tk_messageBox -message "Drawing Saved"

}

proc save_drawing {can fileInfo} {

  global fileSaveLocation
  global can_width
  global can_height

  if {$fileSaveLocation eq "choose output file location"} {
    tk_messageBox -message "You must first select a location and file name."
    return
  }

  set fileSaveName "$fileSaveLocation/$fileInfo.ps"

  $can postscript -file $fileSaveName -width $can_width -height $can_height
}
