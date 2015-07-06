proc save_all_drawings { maincan can_height can_width id maze} {

  set saveloc [tk_chooseDirectory -title "Where should the file be saved?" -mustexist true]
  set filename "$saveloc/allimages$id$maze"

  if {$saveloc eq ""} {
    tk_messageBox -message "Please choose a valid location."
  } else {
    $maincan postscript -file $filename -width $can_width -height $can_height
  }

}

proc save_individual_drawing {} {

}
