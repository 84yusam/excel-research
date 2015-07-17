proc save_all_drawings { maincan can_height can_width id maze} {

  set saveloc [tk_chooseDirectory -title "Where should the file be saved?" -mustexist true]
  set imgtype "allimages"
  set filename "$saveloc/$id$maze$imgtype"

  if {$saveloc eq ""} {
    tk_messageBox -message "Please choose a valid location."
  } else {
    $maincan postscript -file $filename -width $can_width -height $can_height
    tk_messageBox -message "File saved."
  }
}

proc save_individual_drawing {maincan num_trials id maze} {
  global can_height
  global can_width

  set saveloc [tk_chooseDirectory -title "Where should the files be saved?" -mustexist true]

  if {$saveloc eq ""} {
    tk_messageBox -message "Please choose a valid location."
  } else {
    for {set i 1} {$i <= $num_trials} {incr i} {
      set imgtype "trial$i"
      set filename "$saveloc/$id$maze$imgtype"
      $maincan.can$i postscript -file $filename -width $can_width -height $can_height
    }
    tk_messageBox -message "All images saved."
  }
}

proc save_all_agg {} {

}

proc save_individual_agg {} {

}
