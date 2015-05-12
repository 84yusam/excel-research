proc set_drawing_location {} {
  
  global fileSaveLocation
  
  set types {
      {{Text Files}       {.txt}        }
      {{TCL Scripts}      {.tcl}        }
      {{All Files}        *             }
  }

  set fileSaveLocation [tk_getSaveFile -filetypes $types]
  
  if {$fileSaveLocation eq ""} {
    set fileSaveLocation "choose output file location"
  }
}

proc save_all_drawing {} {

  global loadedFileVis
  global loadedFile_trial
  global loadedFile_date

  global canT
  global canD
  global canP
  global drawingWindow 
  global currentMaze

  foreach ref [array names loadedFileVis] {
    if { $loadedFileVis($ref) eq "true" } {
      
      set trial $loadedFile_trial($ref)
      set date $loadedFile_date($ref)

      save_drawing $drawingWindow($trial\_canT) "zscore_time__$date\_$currentMaze\_trial $trial"
      save_drawing $drawingWindow($trial\_canD) "zscore_dist__$date\_$currentMaze\_trial $trial"
      save_drawing $drawingWindow($trial\_canP) "performance_efficiency__$date\_$currentMaze\_trial $trial"

      puts "all drawings for trial $trial are saved"

    }
  }

}

proc save_drawing {can fileInfo} {
  
  global fileSaveLocation
  global can_width
  global can_height
  
  if {$fileSaveLocation eq "choose output file location"} {
    tk_messageBox -message "You must first select a location and file name."
    return
  }
  
  set fileName "$fileSaveLocation\___$fileInfo.ps"

  $can postscript -file $fileName -width $can_width -height $can_height
}
