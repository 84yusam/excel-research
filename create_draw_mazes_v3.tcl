proc create_draw_aggregate_maze {f maze data canName} {

  global can_height
  global can_width

  # create canvas
  set can [canvas $f.$canName -height $can_height -width $can_width]
  pack $can -expand true -fill both -side left -anchor nw

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can

  foreach path $data {
    draw_path $can $path
  }

  return $can
}

proc create_draw_base_maze {f maze trial path_list} {

  global can_height
  global can_width
  
  # create canvas
  set can [canvas $f.basic -height $can_height -width $can_width]
  pack $can -expand true -fill both -side left -anchor nw

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list

  return $can 
}

proc create_draw_zscore_time_maze {f maze trial path_list time_data} {

  global can_height
  global can_width

  # create canvas
  set can [canvas $f.zscoreTime -height $can_height -width $can_width]
  pack $can -expand true -fill both -side left -anchor nw

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list
  draw_ztime       $can $trial

  return $can
}

proc create_draw_zscore_distance_maze {f maze trial path_list time_data} {

  global can_height
  global can_width

  # create canvas
  set can [canvas $f.zscoreTime -height $can_height -width $can_width]
  pack $can -expand true -fill both -side left -anchor nw

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list
  draw_zdist       $can $trial

  return $can
}


proc create_draw_pesky_maze {f maze trial path_list time_data} {

  global can_height
  global can_width

  # create canvas
  set can [canvas $f.pesky -height $can_height -width $can_width]
  pack $can -expand true -fill both -side left -anchor nw

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list
  draw_PE          $can $trial

  return $can
}