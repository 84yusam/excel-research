proc compute_data_dist_matrix {time_data num_of_trials} {

  global originalSize
  global originalGridSize

  global zdist_area_cnt_trial_dist

	set prevXPos 0
	set prevYPos 0

  for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {
    foreach xval [list 0 1 2 3 4 5] {
      foreach yval [list 0 1 2 3 4 5] {
        set zdist_area_cnt_trial_dist("$xval\_$yval\_$cnt") 0
      }
    }
  }

  set cnt 0
  foreach trial_data $time_data {

    foreach item $trial_data {

      set xpos  [lindex $item 0]
      set ypos  [lindex $item 1]
      set trial [lindex $item 3]

      set distance [expr                  \
        sqrt( pow($xpos - $prevXPos, 2) + \
        pow($ypos - $prevYPos, 2) )]
      set prevXPos $xpos
      set prevYPos $ypos

      set xval [expr int(($originalSize - $xpos) / $originalGridSize) ]
      set yval [expr int(($originalSize - $ypos) / $originalGridSize) ]

      set zdist_area_cnt_trial_dist("$xval\_$yval\_$cnt") \
          [expr $zdist_area_cnt_trial_dist("$xval\_$yval\_$cnt") + $distance]
    }
    incr cnt
  }
}

proc compute_average_dist_matrix {num_of_trials} {

  global zdist_area_cnt_trial_dist
  global zdist_area_cnt_total_dist
  global zdist_dbar

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      set zdist_area_cnt_total_dist("$xval\_$yval") 0

      for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {

        set zdist_area_cnt_total_dist("$xval\_$yval")               \
            [expr $zdist_area_cnt_total_dist("$xval\_$yval") +      \
                  $zdist_area_cnt_trial_dist("$xval\_$yval\_$cnt")  ]
      }

      set zdist_dbar("$xval\_$yval") \
          [expr $zdist_area_cnt_total_dist("$xval\_$yval") / $num_of_trials]
    }
  }
}


proc compute_squares_dist_matrix {num_of_trials} {

  global zdist_area_cnt_trial_dist
  global zdist_area_cnt_total_dist
  global zdist_dbar
  global zdist_squares_dist

  for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {

    foreach xval [list 0 1 2 3 4 5] {
      foreach yval [list 0 1 2 3 4 5] {

        set zdist_squares_dist("$xval\_$yval\_$cnt")  \
           [expr {                                    \
             pow ($zdist_area_cnt_trial_dist("$xval\_$yval\_$cnt") - \
                      $zdist_dbar("$xval\_$yval"),                   \
                  2)}]

      }
    }
  }
}


proc compute_sigma_dist_matrix {num_of_trials} {

  global zdist_sum_of_dist_squares
  global zdist_squares_dist
  global zdist_sigma_dist
  global zdist_area_cnt_total_dist

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      set zdist_sum_of_dist_squares("$xval\_$yval") 0

      for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {
        set zdist_sum_of_dist_squares("$xval\_$yval") [ expr \
          $zdist_sum_of_dist_squares("$xval\_$yval") +       \
          $zdist_squares_dist("$xval\_$yval\_$cnt") ]
      }

      set zdist_sigma_dist("$xval\_$yval") [expr {                          \
        sqrt($zdist_sum_of_dist_squares("$xval\_$yval") / $num_of_trials)}]
    }
  }
}

proc compute_zscore_dist {num_of_trials} {

  global zdist_area_cnt_trial_dist
  global zdist_area_cnt_total_dist
  global zdist_dbar
  global zdist_sigma_dist
  global zdist_zscore_dist

  for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {

    foreach xval [list 0 1 2 3 4 5] {
      foreach yval [list 0 1 2 3 4 5] {

        if {$zdist_sigma_dist("$xval\_$yval") != 0} {

          set zdist_zscore_dist("$xval\_$yval\_$cnt")         \
              [expr ($zdist_area_cnt_trial_dist("$xval\_$yval\_$cnt") -      \
                     $zdist_dbar("$xval\_$yval")                        ) /  \
                     $zdist_sigma_dist("$xval\_$yval")   ]
        }
      }
    }
  }
}

proc compute_zdist {time_data} {

  global zdist_zscore_dist
  global zdist_sigma_dist
  global zdist_maxDistVal
  global zdist_minDistVal
  global zdist_num_of_trials

  set num_of_trials [llength $time_data]

  # for use by draw_zdist
  set zdist_num_of_trials $num_of_trials

  compute_data_dist_matrix     $time_data $num_of_trials
  compute_average_dist_matrix  $num_of_trials
  compute_squares_dist_matrix  $num_of_trials
  compute_sigma_dist_matrix    $num_of_trials
  compute_zscore_dist          $num_of_trials

  set zdist_maxDistVal 0

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {
      for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {

        if {$zdist_sigma_dist("$xval\_$yval") != 0} {
          if {$zdist_zscore_dist("$xval\_$yval\_$cnt") > $zdist_maxDistVal} {
            set zdist_maxDistVal $zdist_zscore_dist("$xval\_$yval\_$cnt")
          }
        }
      }
    }
  }

  set zdist_minDistVal $zdist_maxDistVal

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {
      for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {

        if {$zdist_sigma_dist("$xval\_$yval") != 0} {
          if {$zdist_zscore_dist("$xval\_$yval\_$cnt") < $zdist_minDistVal} {
            set zdist_minDistVal $zdist_zscore_dist("$xval\_$yval\_$cnt")
          }
        }
      }
    }
  }

}


proc draw_zdist {can trial} {

  global originalSize
  global originalGridSize
  global gridLocName

  global zdist_area_cnt_trial_dist
  global zdist_zscore_dist
  global zdist_sigma_dist

  global zdist_num_of_trials
  global zdist_maxDistVal
  global zdist_minDistVal

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      if { $zdist_area_cnt_trial_dist("$xval\_$yval\_$trial") == 0 ||
           $zdist_num_of_trials                               == 1    } {

        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill white

      } elseif {  $zdist_zscore_dist("$xval\_$yval\_$trial") == 0 } {

        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill yellow

      } elseif {$zdist_zscore_dist("$xval\_$yval\_$trial") > 0} {

        set redVal   65535
        set greenVal [expr {int( 65535.0 - (1.0 * $zdist_zscore_dist("$xval\_$yval\_$trial"))  / $zdist_maxDistVal * 65535.0 )}]
        set blueVal  29
        set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
        set gridLoc  "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill $colorVal

      } elseif {$zdist_zscore_dist("$xval\_$yval\_$trial") < 0} {

        set redVal   [expr int( 65535 - (abs($zdist_zscore_dist("$xval\_$yval\_$trial") / $zdist_minDistVal) * 65535) )]
        set greenVal [expr int( 65535 - (abs($zdist_zscore_dist("$xval\_$yval\_$trial") / $zdist_minDistVal) * 45535) )]
        set blueVal  1000
        set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
        set gridLoc  "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill $colorVal

      } else {

        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill white
      }
    }
  }
}
