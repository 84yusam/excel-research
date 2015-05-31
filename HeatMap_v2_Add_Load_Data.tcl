proc load_folders {} {
  global directory
  global fileList
  global treeview
  global parent
  global loadedFile_trial
  global loadedFile_mazenum

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
  global loadedFile_id
  global loadedFile_type
  global fileRef
  global treeview
  global parent
  global maze_and_trial

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
      set loadedFile_data($fileRef)     [lindex $dataList 0]
      set loadedFile_timedata($fileRef) [lindex $dataList 1]
      set loadedFile_trial($fileRef)    [lindex $dataList 2]
      set loadedFile_mazenum($fileRef)  [lindex $dataList 3]
      set loadedFile_id($fileRef)       [lindex $dataList 4]

      set loadedFile_type($fileRef) [string index $loadedFile_id($fileRef) end]

      #checks if a list for that maze and trial exists. If so, adds file to list. If not, creates the list.
      if {[info exists maze_and_trial($loadedFile_mazenum($fileRef)$loadedFile_trial($fileRef)$loadedFile_type($fileRef))] == 1} {
        lappend maze_and_trial($loadedFile_mazenum($fileRef)$loadedFile_trial($fileRef)$loadedFile_type($fileRef)) $fileRef
      } else {
        set maze_and_trial($loadedFile_mazenum($fileRef)$loadedFile_trial($fileRef)$loadedFile_type($fileRef)) [list $fileRef]
      }
    }
  }

}

#loads data into maps, taking note of times,dates, and positions as displayed in name
proc load_data { filename } {

  global trial
  global id
  global mazenum

  set fh [open $filename r]

  set first 1
  set location   {}
  set timeValues {}

  set trial   [lindex [split $filename "-"] 2]
  set mazenum [lindex [split $filename "-"] 1]
  #set mazenum to be just the number, not the word 'maze'

  if {[string length $mazenum] == 5} {
    set mazenum [string index $mazenum 4]
  }
  if {[string length $mazenum] == 6} {
    set mazenum [string range $mazenum 4 5]
  }

  #create a new id number that will not have periods and includes atypical vs. typical ending
  set temp [lindex [split $filename "_"] 2]
  set part1 [lindex [split $temp "."] 0]
  set part2 [lindex [split $temp "."] 1]
  set part3 [lindex [split $temp "."] 2]
  set tmp2 [lindex [split $filename "_"] 3]
  set part4 [lindex [split $tmp2 "/"] 0]

  set id $part1$part2$part3$part4


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

  return [list $location $timeValues $trial $mazenum $id]

}
