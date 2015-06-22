#--identify all folders within the directory
proc iterate_dir { dir } {

  global folderList

  set folderList {}
  set contents [glob -directory $dir *]
  foreach item $contents {
    if {[file isdirectory $item] == 1} {
      lappend folderList $item
    }
  }
  tk_messageBox -message $folderList
  separate_type $dir $folderList
}

#--separate list of directory folders into typical and atypical
proc separate_type { dir folderList } {
 global id_atypical
 global id_typical
 #global foldername

 set id_atypical($dir) {}
 set id_typical($dir) {}

 foreach item $folderList {
   set type [lindex [split $item _] 2]
   #set tmp [split $item /]
   #set foldername($item) [lindex $tmp [expr [llength $tmp] - 1]]
   if {$type == 1} {
     #lappend id_typical($dir) $foldername($item)
     lappend id_typical($dir) $item
   } else {
     #lappend id_atypical($dir) $foldername($item)
     lappend id_atypical($dir) $item
   }
 }

 list_ids $dir $id_atypical($dir) $id_typical($dir)
}

# loads data into maps, taking note of times,dates, and
# positions as displayed in name
proc load_data { filename } {

  set fh [open $filename r]

  set first 1
  set location   {}
  set timeValues {}

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

  return [list $location $timeValues]

}
