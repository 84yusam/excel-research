package require Tk

source LoadDataSample.tcl

wm title . "Heat Map Generator"

#-- create the source and destination frames
global sourceText
global destText
global numDirectories

set numDirectories 0

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
  global numDirectories
  set directory [tk_chooseDirectory -mustexist 1 -title "Choose a source."]
  #-- the num of directories increases by 2 because for each directory there are 2 frames
  incr numDirectories 2
    $sourceText insert end "$directory "
  iterate_dir $directory
  create_central_frame $numDirectories
}

proc set_destination {} {
  global destText
  set destination [tk_chooseDirectory -mustexist 1 -title "Choose a destination."]
  $destText delete 1.0 end
  $destText insert end "Destination: $destination"
}

proc create_central_frame { frameNum } {
  global directory
  global visible
  #-- because each directory has two frames, the frame names must be based on the given num and by adding one
  set childFrame [expr $frameNum + 1]

  frame .cf$frameNum -width 0
  pack  .cf$frameNum -side top -anchor nw -fill x -expand 0

  button .cf$frameNum.plus -text "+" -width 0 -command "toggle_hiding notDefined"
  pack  .cf$frameNum.plus -side left -anchor nw -expand 0

  set filePath [split $directory "/"]
  set length [llength $filePath]
  set folder [lindex $filePath [expr $length - 1]]
  text .cf$frameNum.t1 -height 1 -width [string length $folder]
  .cf$frameNum.t1 delete 1.0 end
  .cf$frameNum.t1 insert end $folder
  pack .cf$frameNum.t1 -side left -anchor nw

  frame .cf$childFrame -width 0
  pack  .cf$childFrame -side top -anchor nw -fill x -expand 0

  labelframe .cf$childFrame.typical -width 0 -text "Typical"
  pack       .cf$childFrame.typical -side left -padx 25 -anchor nw -fill x -expand 0
  labelframe .cf$childFrame.atypical -width 0 -text "Atypical"
  pack       .cf$childFrame.atypical -side left -anchor nw -fill x -expand 0
  set visible(.cf$childFrame) "true"

  #-- TEMPORARY
  button .cf$childFrame.typical.tmp -width 25 -text "here $childFrame"
  pack .cf$childFrame.typical.tmp -side left -anchor nw -fill x -expand 0
  button .cf$childFrame.atypical.tmp -width 25 -text "here $childFrame"
  pack .cf$childFrame.atypical.tmp -side left -anchor nw -fill x -expand 0

  .cf$frameNum.plus configure -command "toggle_hiding .cf$childFrame"
}

proc toggle_hiding {thing_to_hide} {
  global visible
  global numDirectories
  if {$thing_to_hide eq "notDefined"} {
    tk_messageBox -message "Button not configure."
  } else {
    if {$visible($thing_to_hide) eq "true"} {
      pack forget $thing_to_hide
      set visible($thing_to_hide) "false"
    } else {
      pack $thing_to_hide -side top -anchor nw -fill x -expand 0
      if {$numDirectories > 2} {
        for {set i $numDirectories} {$i > 0} {incr i -2} {
          if {".cf[expr $i - 1]" eq $thing_to_hide} {
            raise $thing_to_hide .cf$i
            tk_messageBox -message "Raised $thing_to_hide above .cf$i"
            break
          }
        }
      }
      set visible($thing_to_hide) "true"
    }
  }


}
