proc add_data_files {} {

  global loadedFiles
  global loadedFileVis
  global loadedFileCount
  global loadedFile_data
  global loadedFile_timedata
  global loadedFile_trial
  global fileRef  
  global treeview

  global fileOpenLocation
  global orderedFiles
  global orderedNames
  global fileName
 
  set fileOpenLocation [tk_getOpenFile -multiple 1]

  if {[llength $fileOpenLocation]} {

     set orderedFiles [lsort -increasing $fileOpenLocation]
    
     foreach fullname $orderedFiles {
      set locName  [file dirname $fullname]
      set fileName [file tail    $fullname]
      lappend orderedNames $fileName

      set fileRef $fileName
      set refvalue [$treeview insert {} 0 -text $fileName -tag $fileRef]
      $treeview set $refvalue visible "true"
      $treeview set $refvalue location $locName
      $treeview tag bind $fileRef <ButtonPress> "toggle_hiding $fileRef $refvalue"

      lappend loadedFiles $fileRef
      incr loadedFileCount
      set loadedFileVis($fileRef) "true"

      set dataList [load_data $fullname]
      set loadedFile_data($fileRef) [lindex $dataList 0]
      set loadedFile_timedata($fileRef) [lindex $dataList 1]
      set loadedFile_trial($fileRef) [lindex $dataList 2]

    }

  }

}

#loads data into maps, taking note of times,dates, and positions as displayed in name
proc load_data { filename } {
  
  global trial
  global idname
  global namenum
  
  set fh [open $filename r]

  set first 1
  set location   {}
  set timeValues {}
    
  set name [lindex [split $filename "/"] 6]
  set idname [split [lindex $name 0] "-"]
  set trial [lindex [split $filename "-"] 2]  
  set mazenum [lindex [split $filename "-"] 1]

  while {![eof $fh]} {
    
    set data [gets $fh]

    if {[string length $data] == 0} {

      set data [split $data]    
      break
    }
    set dateTime [split [lindex $data 0] "T"]
    set position [split [lindex $data 1] ","]
        
    set trial [lindex [split $filename "-"] 2]

    set dateVal  [split [lindex $dateTime 0] "-"]
    set timeVal  [lindex [split $dateTime] 1]

    set xval [lindex $position 0]
    set yval [lindex $position 1]
    set zval [lindex $position 2]
    
    lappend location   $xval
    lappend location   $yval

    lappend timeValues [list $xval $yval $timeVal $trial]

  }
  
  close $fh
    
  return [list $location $timeValues $trial]

}
