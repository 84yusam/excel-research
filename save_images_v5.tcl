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

proc save_individual_drawing {maincan trial id maze} {
  global can_height
  global can_width

  if {$trial eq "Choose a trial"} {
    tk_messageBox -message "Please choose a trial."
  } else {
    set saveloc [tk_chooseDirectory -title "Where should the file be saved?" -mustexist true]
    set imgtype "trial$trial"
    set filename "$saveloc/$id$maze$imgtype"

    if {$saveloc eq ""} {
      tk_messageBox -message "Please choose a valid location."
    } else {
      $maincan.can$trial postscript -file $filename -width $can_width -height $can_height
      tk_messageBox -message "File saved."
    }
  }

}
