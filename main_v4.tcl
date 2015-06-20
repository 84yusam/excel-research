package require Tk

source load_data_v4.tcl
source build_window_v4.tcl

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
.f1.t1 insert end "Source: "
pack .f1.t1 -side left -anchor nw

set destText [text .f2.t1 -height 1]
.f2.t1 insert end "Destination:"
pack .f2.t1 -side left -anchor nw

frame .f3 -width 0
pack .f3 -side top -anchor nw -fill x -expand 0

#-- when the user sets the source, create body frame and iterate through files
proc set_source {} {
  global directory
  global sourceText
  global numDirectories
  set directory [tk_chooseDirectory -mustexist 1 -title "Choose a source."]
  set shortenedDir [file tail $directory]
  #-- the num of directories increases by 2 because for each directory there are 2 frames
  incr numDirectories 2
    $sourceText insert end "$shortenedDir "
  create_central_frame $numDirectories
  iterate_dir $directory
}

proc set_destination {} {
  global destText
  set destination [tk_chooseDirectory -mustexist 1 -title "Choose a destination."]
  $destText delete 1.0 end
  $destText insert end "Destination: $destination"
}

#-- creates two frames for each directory, one w/ name and one w/ files within
proc create_central_frame { frameNum } {
  global directory
  global visible
  global lastDir

  #-- because each directory has two frames, the frame names must be based on the given num and by adding one
  set childFrame [expr $frameNum + 1]

  frame .f3.cf$frameNum -width 0
  pack  .f3.cf$frameNum -side top -anchor nw -fill x -expand 0

  button .f3.cf$frameNum.plus -text "+" -width 0 -command "toggle_hiding notDefined"
  pack  .f3.cf$frameNum.plus -side left -anchor nw -expand 0

  set filePath [split $directory "/"]
  set length [llength $filePath]
  set folder [lindex $filePath [expr $length - 1]]
  text .f3.cf$frameNum.t1 -height 1 -width [string length $folder]
  .f3.cf$frameNum.t1 delete 1.0 end
  .f3.cf$frameNum.t1 insert end $folder
  pack .f3.cf$frameNum.t1 -side left -anchor nw

  frame .f3.cf$childFrame -width 0
  pack  .f3.cf$childFrame -side top -anchor nw -fill x -expand 0

  labelframe .f3.cf$childFrame.typical -width 0 -text "Typical"
  pack       .f3.cf$childFrame.typical -side left -padx 25 -anchor nw -fill x -expand 0
  labelframe .f3.cf$childFrame.atypical -width 0 -text "Atypical"
  pack       .f3.cf$childFrame.atypical -side left -anchor nw -fill x -expand 0
  set visible(.f3.cf$childFrame) "true"

  .f3.cf$frameNum.plus configure -command "toggle_hiding .f3.cf$childFrame"

  #--allows you to make the list for typical and atypical based on the last dir loaded
  set lastDir ".f3.cf$childFrame"
}

proc toggle_hiding {thing_to_hide} {
  global visible
  global numDirectories
  if {$thing_to_hide eq "notDefined"} {
    tk_messageBox -message "Button not configured."
  } else {
    if {$visible($thing_to_hide) eq "true"} {
      pack forget $thing_to_hide
      set visible($thing_to_hide) "false"
    } else {
      pack $thing_to_hide -side top -anchor nw -fill x -expand 0
      if {$numDirectories > 2} {
        for {set i $numDirectories} {$i > 0} {incr i -2} {
          if {".f3.cf[expr $i - 1]" eq $thing_to_hide} {
            raise $thing_to_hide .f3.cf$i
            tk_messageBox -message "Raised $thing_to_hide above .f3.cf$i"
            break
          }
        }
      }
      set visible($thing_to_hide) "true"
    }
  }
}

#-- for each ID within the list, create a frame within its parent directory
proc list_ids { dir atypicalList typicalList } {
  global lastDir
  global id
  #-- TYPICAL LIST
  foreach item $typicalList {
    set id($item) {}
    set temp [split $item _]
    set idparts {}
    foreach part $temp {
      lappend idparts [split $part .]
    }
    foreach part $idparts {
      lappend id($item) $part
    }
    frame  $lastDir.typical.$id($item) -width 0
    pack   $lastDir.typical.$id($item) -side top -anchor nw -fill x -expand 0
    button $lastDir.typical.$id($item).plus -text "+" -width 0
    pack   $lastDir.typical.$id($item).plus -side left -anchor nw -fill x -expand 0
    text   $lastDir.typical.$id($item).txt -height 1 -width 25
    pack   $lastDir.typical.$id($item).txt -side left -anchor nw -fill x -expand 0
           $lastDir.typical.$id($item).txt insert end $item
  }
  #-- ATYPICAL LIST
  foreach item $atypicalList {
    set id($item) {}
    set temp [split $item _]
    set idparts {}
    foreach part $temp {
      lappend idparts [split $part .]
    }
    foreach part $idparts {
      lappend id($item) $part
    }
    frame  $lastDir.atypical.$id($item) -width 0
    pack   $lastDir.atypical.$id($item) -side top -anchor nw -fill x -expand 0
    button $lastDir.atypical.$id($item).plus -text "+" -width 0
    pack   $lastDir.atypical.$id($item).plus -side left -anchor nw -fill x -expand 0
    text   $lastDir.atypical.$id($item).txt -height 1 -width 25
    pack   $lastDir.atypical.$id($item).txt -side left -anchor nw -fill x -expand 0
           $lastDir.atypical.$id($item).txt insert end $item
  }
}
