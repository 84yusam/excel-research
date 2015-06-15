proc compute_PE_matrix {num_of_trials} {

  global pesky_eff
  global ztime_zscore_time
  global zdist_zscore_dist
  global ztime_sigma_time
  # global xval
  # global yval
  # global loadedFileVis
  # global loadedFile_trial

  for {set cnt 0} {$cnt < $num_of_trials} {incr cnt} {
    foreach xval [list 0 1 2 3 4 5] {
      foreach yval [list 0 1 2 3 4 5] {

        if {$ztime_sigma_time("$xval\_$yval") != 0} {

          set pesky_eff("$xval\_$yval\_$cnt")                    \
              [expr ($ztime_zscore_time("$xval\_$yval\_$cnt") +        \
                     $zdist_zscore_dist("$xval\_$yval\_$cnt")    ) / 2   ]
        }
      }
    }
  }
}


proc draw_PE {can trial} {

  global originalSize
  global originalGridSize
  global gridLocName
  global orderedNames

  global pesky_eff
  global ztime_area_cnt_trial_time
  global zdist_sigma_dist
  global ztime_sigma_time
  global ztime_num_of_trials
  # global xval
  # global yval

  set prevFiles {} 

  set maxVal 0
  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {
      if {$zdist_sigma_dist("$xval\_$yval") != 0 && 
          $ztime_sigma_time("$xval\_$yval") != 0     } {

        if {$pesky_eff("$xval\_$yval\_$trial") > $maxVal} {
          set maxVal $pesky_eff("$xval\_$yval\_$trial")
        }
      }
    }
  }

  set minVal 0
  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {
      if {$zdist_sigma_dist("$xval\_$yval") != 0 && 
          $ztime_sigma_time("$xval\_$yval") != 0     } {

        if {$pesky_eff("$xval\_$yval\_$trial") < $minVal} {
          set minVal $pesky_eff("$xval\_$yval\_$trial")
        }
      }
    }
  }

  set firstTrial 0
  set lastConsideredTrial [expr $trial - 1]

  foreach xval [list 0 1 2 3 4 5] {
    foreach yval [list 0 1 2 3 4 5] {
      if {$zdist_sigma_dist("$xval\_$yval") != 0 &&  \
          $ztime_sigma_time("$xval\_$yval") != 0       } {

        # if { $ztime_num_of_trials == 1 } {
        #   set  gridLoc "$xval\_$yval"
        #   set  colorVal white
        # }
        set  gridLoc "$xval\_$yval"
        set  colorVal white

        for {set previousTrial 0} {$previousTrial < $lastConsideredTrial} {incr previousTrial} {

          if {$ztime_area_cnt_trial_time("$xval\_$yval\_$previousTrial") != 0 || \
              $ztime_area_cnt_trial_time("$xval\_$yval\_$trial")         != 0    } { 

            if {$pesky_eff("$xval\_$yval\_$trial") > 0 } {

              set redVal   65535
              set greenVal [expr {                                \
                int( 65535.0 -                                    \
                     (1.0 * $pesky_eff("$xval\_$yval\_$trial")) / \
                     $maxVal * 65535.0 )}]
              set blueVal  29
              set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
              set gridLoc "$xval\_$yval"

            } elseif {$pesky_eff("$xval\_$yval\_$trial") < 0} {

              set redVal [expr                                         \
                int( 65535 - (abs($pesky_eff("$xval\_$yval\_$trial") / \
                              $minVal) * 65535) )]
              set greenVal [expr                                       \
                int( 65535 - (abs($pesky_eff("$xval\_$yval\_$trial") / \
                                   $minVal) * 45535) )]
              set blueVal  1000
              set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]
              set gridLoc "$xval\_$yval"      

            } else {

              set colorVal yellow
              set gridLoc "$xval\_$yval"   
            } 
          } 
        }

        $can itemconfigure $gridLocName($gridLoc) -fill $colorVal
      }
    }
  }
}