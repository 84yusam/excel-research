proc create_draw_aggregate_maze {can maze data} {
  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can

  foreach path $data {
    draw_path $can $path
  }

}

proc create_draw_base_maze {can maze trial path_list} {

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list

  return $can
}

proc create_draw_zscore_time_maze {can maze trial path_list time_data} {

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list
  draw_ztime       $can $trial

  return $can
}

proc create_draw_zscore_distance_maze {can maze trial path_list time_data} {

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list
  draw_zdist       $can $trial

  return $can
}


proc create_draw_pesky_maze {can maze trial path_list time_data} {

  # draw forms
  draw_grid        $can
  draw_inner_walls $maze $can
  draw_outer_walls $can
  draw_path        $can $path_list
  draw_PE          $can $trial

  return $can
}
