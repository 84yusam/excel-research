proc build_window { maze id_folder } {
  set folderName [file tail $id_folder]
  set id [split_id $folderName]

  toplevel .$id$maze
  wm title .$id$maze "HeatMaps for $id_folder $maze"

  set contents [glob -directory $id_folder *]
  foreach item $contents {
    if {[file isdirectory $item] == 1} {
      set logs $item
    }
  }


}

#-- returns the ID without any punctuation
proc split_id { orig_id } {
  set split_1 [split $orig_id _]
  set tmp1 [lindex $split_1 0]
  set tmp2 [lindex $split_1 1]
  set tmp3 [lindex $split_1 2]

  set split_2 [split $tmp1 .]
  set split_3 [split $tmp2 .]

  set tmp4 [lindex $split_2 0]
  set tmp5 [lindex $split_2 1]
  set tmp6 [lindex $split_2 2]

  set tmp7 [lindex $split_3 0]
  set tmp8 [lindex $split_3 1]
  set tmp9 [lindex $split_3 2]

  set final_id $tmp4$tmp5$tmp6$tmp7$tmp8$tmp9$tmp3

  return $final_id
}
