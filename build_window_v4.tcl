proc build_window { maze folder id } {
  tk_messageBox -message "Maze: $maze from individual $id"

  set temp [lindex [split $id "_"] 2]
  set part1 [lindex [split $temp "."] 0]
  set part2 [lindex [split $temp "."] 1]
  set part3 [lindex [split $temp "."] 2]
  set tmp2 [lindex [split $id "_"] 3]
  set part4 [lindex [split $tmp2 "/"] 0]

  set idlabel $part1$part2$part3$part4

  toplevel .$maze$idlabel
  wm title .$maze$idlabel "$maze for $idlabel"
}
