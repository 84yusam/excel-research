proc compute_data_time_matrix {time_data num_of_trials} {

  global originalSize
  global originalGridSize

  global ztime_area_cnt_trial_time

  set prevTotalTime 0

  for {set cnt 1} {$cnt <= $num_of_trials} {incr cnt} {
    foreach xval [list 0 1 2 3 4 5] {
      foreach yval [list 0 1 2 3 4 5] {
        set ztime_area_cnt_trial_time("$xval\_$yval\_$cnt") 0
      }
    }
  }

  set cnt 1
  foreach trial_data $time_data {

    foreach item $trial_data {

      set xpos        [lindex $item 0]
      set ypos        [lindex $item 1]
      set timeVal     [lindex $item 2]

      set trial       [lindex $item 3]

      set timeVal     [split $timeVal ":"]

      set hourVal     [lindex $timeVal 0]
      set minVal      [lindex $timeVal 1]
      set secSecVal   [lindex $timeVal 2]
      set secSecVal   [split  $secSecVal "."]

      set secVal      [lindex $secSecVal 0]
      set microSecVal [lindex $secSecVal 1]

      #converts everything to microseconds

      set totalTime [expr                \
        ($hourVal * 60 * 60 * 1000) +    \
        ($minVal  * 60 * 1000) +         \
        ($secVal  * 1000) + $microSecVal   ]

      set timeDiff [expr $totalTime - $prevTotalTime]

      set prevTotalTime $totalTime

      set xval [expr int(($originalSize - $xpos) / $originalGridSize) ]
      set yval [expr int(($originalSize - $ypos) / $originalGridSize) ]

      set ztime_area_cnt_trial_time("$xval\_$yval\_$cnt") \
        [expr {$ztime_area_cnt_trial_time("$xval\_$yval\_$cnt") + $timeDiff}]

    }

    incr cnt

  }
}

proc compute_average_time_matrix {num_of_trials} {

  global ztime_area_cnt_trial_time
  global ztime_area_cnt_total_time
  global ztime_tbar

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      set ztime_area_cnt_total_time("$xval\_$yval") 0

      for {set cnt 1} {$cnt <= $num_of_trials} {incr cnt} {

        set ztime_area_cnt_total_time("$xval\_$yval")                 \
            [expr $ztime_area_cnt_total_time("$xval\_$yval") +        \
                  $ztime_area_cnt_trial_time("$xval\_$yval\_$cnt")]
      }
    }
  }

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      set ztime_tbar("$xval\_$yval")  \
        [expr $ztime_area_cnt_total_time("$xval\_$yval") / $num_of_trials]
    }
  }

  # foreach xval [list 0 1 2 3 4 5] {
  #   foreach yval [list 0 1 2 3 4 5] {
  #     if {$ztime_tbar("$xval\_$yval") != 0} {
  #       #puts "$xval\_$yval  >> total time is  $ztime_area_cnt_total_time("$xval\_$yval") <<     >>>> ztime_tbar is $ztime_tbar("$xval\_$yval") <<<<"
  #     }
  #   }
  # }
}

proc compute_squares_time_matrix {num_of_trials} {

  global ztime_area_cnt_trial_time
  global ztime_area_cnt_total_time
  global ztime_tbar
  global ztime_squares_time

  for {set cnt 1} {$cnt <= $num_of_trials} {incr cnt} {

    foreach xval [list 0 1 2 3 4 5] {
      foreach yval [list 0 1 2 3 4 5] {

        set ztime_squares_time("$xval\_$yval\_$cnt")                        \
          [expr { pow ($ztime_area_cnt_trial_time("$xval\_$yval\_$cnt") -   \
                            $ztime_tbar("$xval\_$yval"),                    \
                        2)}]
      }
    }
  }
}

proc compute_sigma_time_matrix {num_of_trials} {

  global ztime_area_cnt_trial_time
  global ztime_tbar
  global ztime_squares_time
  global ztime_sum_of_time_squares
  global ztime_sigma_time

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      set ztime_sum_of_time_squares("$xval\_$yval") 0

      for {set cnt 1} {$cnt <= $num_of_trials} {incr cnt} {

        set ztime_sum_of_time_squares("$xval\_$yval")            \
            [ expr $ztime_sum_of_time_squares("$xval\_$yval") +  \
                   $ztime_squares_time("$xval\_$yval\_$cnt")      ]
      }

      set ztime_sigma_time("$xval\_$yval") \
         [expr {sqrt($ztime_sum_of_time_squares("$xval\_$yval") /     \
                     $num_of_trials                         )}]

    }
  }
}

proc compute_zscore_time {num_of_trials} {

  global ztime_area_cnt_trial_time
  global ztime_area_cnt_total_time
  global ztime_tbar
  global ztime_sigma_time
  global ztime_zscore_time

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      for {set cnt 1} {$cnt <= $num_of_trials} {incr cnt} {

        if {$ztime_sigma_time("$xval\_$yval") != 0} {

          set ztime_zscore_time("$xval\_$yval\_$cnt") \
              [expr ($ztime_area_cnt_trial_time("$xval\_$yval\_$cnt") -     \
                     $ztime_tbar("$xval\_$yval")                          ) / \
                    $ztime_sigma_time("$xval\_$yval")]

        } else {

          set ztime_zscore_time("$xval\_$yval\_$cnt") 0
        }
      }
    }
  }
}

proc compute_ztime   {time_data} {

  global ztime_sigma_time
  global ztime_zscore_time
  global ztime_maxTimeVal
  global ztime_minTimeVal
  global ztime_num_of_trials

  set num_of_trials [llength $time_data]

  # for use by draw_ztime
  set ztime_num_of_trials $num_of_trials

  compute_data_time_matrix    $time_data $num_of_trials
  compute_average_time_matrix $num_of_trials
  compute_squares_time_matrix $num_of_trials
  compute_sigma_time_matrix   $num_of_trials
  compute_zscore_time         $num_of_trials

  set ztime_maxTimeVal 0

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {
      for {set cnt 1} {$cnt <= $num_of_trials} {incr cnt} {

        if {$ztime_sigma_time("$xval\_$yval") != 0} {

          if {$ztime_zscore_time("$xval\_$yval\_$cnt") > $ztime_maxTimeVal} {

            set ztime_maxTimeVal $ztime_zscore_time("$xval\_$yval\_$cnt")
          }
        }
      }
    }
  }

  set ztime_minTimeVal $ztime_maxTimeVal

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {
      for {set cnt 1} {$cnt <= $num_of_trials} {incr cnt} {

        if {$ztime_sigma_time("$xval\_$yval") != 0} {

          if {$ztime_zscore_time("$xval\_$yval\_$cnt") < $ztime_minTimeVal} {

            set ztime_minTimeVal $ztime_zscore_time("$xval\_$yval\_$cnt")
          }
        }
      }
    }
  }

}

proc draw_ztime {can trial} {

  global originalSize
  global originalGridSize
  global gridLocName

  global ztime_area_cnt_trial_time
  global ztime_zscore_time
  global ztime_sigma_time

  global ztime_num_of_trials
  global ztime_maxTimeVal
  global ztime_minTimeVal

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {

      if { $ztime_area_cnt_trial_time("$xval\_$yval\_$trial") == 0 ||
           $ztime_num_of_trials                               == 1    } {

        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill white

      } elseif {  $ztime_zscore_time("$xval\_$yval\_$trial") == 0 } {

        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill yellow

      } elseif {$ztime_zscore_time("$xval\_$yval\_$trial") > 0} {

        set redVal   65535
        set greenVal [expr {int( 65535.0 - (1.0 * $ztime_zscore_time("$xval\_$yval\_$trial"))  / $ztime_maxTimeVal * 65535.0 )}]
        set blueVal  29
        set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
        set gridLoc "$xval\_$yval"

        $can itemconfigure $gridLocName($gridLoc) -fill $colorVal

      } elseif {$ztime_zscore_time("$xval\_$yval\_$trial") < 0} {

        set redVal   [expr int( 65535 - (abs($ztime_zscore_time("$xval\_$yval\_$trial") / $ztime_minTimeVal) * 65535) )]
        set greenVal [expr int( 65535 - (abs($ztime_zscore_time("$xval\_$yval\_$trial") / $ztime_minTimeVal) * 45535) )]
        set blueVal  1000
        set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]

        set gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill $colorVal

      } else {

        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill white
      }
    }
  }
}
