proc load_folders {} {
  global directory
  global fileList
  global treeview
  global parent

  #have the user choose a folder and extract the files from the folder
  set directory [tk_chooseDirectory -mustexist 1 -title "Choose a folder."]
  set fileList [glob -directory $directory *.txt]

  #add the directory to the treeview
  set parent [$treeview insert {} 0 -text $directory]

  add_data_files fileList
}


proc add_data_files { files } {

  global loadedFiles
  global loadedFileVis
  global loadedFileCount
  global loadedFile_data
  global loadedFile_timedata
  global loadedFile_trial
  global loadedFile_mazenum
  global fileRef
  global treeview
  global parent

  global fileList
  global orderedFiles
  global orderedNames
  global fileName

  if {[llength $fileList]} {

     set orderedFiles [lsort -increasing $fileList]

     foreach fullname $orderedFiles {
      set locName  [file dirname $fullname]
      set fileName [file tail    $fullname]
      lappend orderedNames $fileName

      set fileRef $fileName
      set refvalue [$treeview insert $parent 0 -text $fileName -tag $fileRef]
      $treeview set $refvalue visible "true"
      $treeview tag bind $fileRef <ButtonPress> "toggle_hiding $fileRef $refvalue"

      lappend loadedFiles $fileRef
      incr loadedFileCount
      set loadedFileVis($fileRef) "true"

      set dataList [load_data $fullname]
      set loadedFile_data($fileRef) [lindex $dataList 0]
      set loadedFile_timedata($fileRef) [lindex $dataList 1]
      set loadedFile_trial($fileRef) [lindex $dataList 2]
      set loadedFile_mazenum($fileRef) [lindex $dataList 3]

    }

  }

}

#loads data into maps, taking note of times,dates, and positions as displayed in name
proc load_data { filename } {

  global trial
  global idname
  global mazenum
  #global namenum

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

  return [list $location $timeValues $trial $mazenum]

}
