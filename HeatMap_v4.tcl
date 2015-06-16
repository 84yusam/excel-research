package require Tk

source LoadDataSample.tcl

wm title . "Heat Map Generator"

#-- create the source and destination frames
global sourceText
global destText

frame .f1 -width 0
pack  .f1 -side top -anchor nw  -fill x -expand 0

button .f1.b1 -text "Set Source" -width 25 -command set_source
pack   .f1.b1 -side left -anchor nw

frame .f2 -width 0
pack  .f2 -side top -anchor nw -fill x -expand 0

button .f2.b2 -text "Set Destination" -width 25 -command set_destination
pack   .f2.b2 -side left -anchor nw

set sourceText [text .f1.t1 -height 1]
.f1.t1 insert end "Source:"
pack .f1.t1 -side left -anchor nw

set destText [text .f2.t1 -height 1]
.f2.t1 insert end "Destination:"
pack .f2.t1 -side left -anchor nw

#-- when the user sets the source, create body frame and iterate through files
proc set_source {} {
  global directory
  global sourceText
  set directory [tk_chooseDirectory -mustexist 1 -title "Choose a source."]
  if {$sourceText eq "Source: "} {
    $sourceText insert end $directory
  } else {
    $sourceText insert end ", $directory"
  }
  iterate_dir $directory
  create_central_frame
}

proc set_destination {} {
  global destText
  set destination [tk_chooseDirectory -mustexist 1 -title "Choose a destination."]
  $destText delete 1.0 end
  $destText insert end "Destination: $destination"
}

proc create_central_frame {} {
  global directory
  global visible

  frame .f3 -width 0
  pack  .f3 -side top -anchor nw -fill x -expand 0

  button .f3.plus -text "+" -width 0 -command "toggle_hiding notDefined"
  pack  .f3.plus -side left -anchor nw -expand 0

  set filePath [split $directory "/"]
  set length [llength $filePath]
  set folder [lindex $filePath [expr $length - 1]]
  text .f3.t1 -height 1 -width [string length $folder]
  .f3.t1 delete 1.0 end
  .f3.t1 insert end $folder
  pack .f3.t1 -side left -anchor nw

  #button .f3.plus -text "+" -width 0 -command "toggle_hiding notDefined"
  #pack  .f3.plus -side left -anchor nw -expand 0

  frame .f4 -width 0
  pack  .f4 -side top -anchor nw -fill x -expand 0

  labelframe .f4.typical -width 0 -text "Typical"
  pack       .f4.typical -side left -padx 25 -anchor nw -fill x -expand 0
  labelframe .f4.atypical -width 0 -text "Atypical"
  pack       .f4.atypical -side left -anchor nw -fill x -expand 0
  set visible(.f4) "true"

  #-- TEMPORARY
  button .f4.typical.tmp -width 25 -text "here"
  pack .f4.typical.tmp -side left -anchor nw -fill x -expand 0
  button .f4.atypical.tmp -width 25 -text "here"
  pack .f4.atypical.tmp -side left -anchor nw -fill x -expand 0

  .f3.plus configure -command "toggle_hiding .f4"
}

proc toggle_hiding {thing_to_hide} {
  global visible
  if {$thing_to_hide eq "notDefined"} {
    tk_messageBox -message "Button not configure."
  } else {
    if {$visible($thing_to_hide) eq "true"} {
      pack forget $thing_to_hide
      set visible($thing_to_hide) "false"
    } else {
      pack $thing_to_hide -side top -anchor nw -fill x -expand 0
      set visible($thing_to_hide) "true"
    }
  }


}
