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
