proc compute_PE_matrix {} {

    global perf_eff
    global zscore_time
    global zscore_dist
    global sigma_time
    global xval
    global yval
    global loadedFileVis
    global loadedFile_trial
    
    foreach ref [array names loadedFileVis] {
      if { $loadedFileVis($ref) eq "true" } {
        set trial $loadedFile_trial($ref)
          
        foreach xval [list 0 1 2 3 4 5] {
          foreach yval [list 0 1 2 3 4 5] {
             if {$sigma_time("$xval\_$yval") != 0} {
              set perf_eff("$xval\_$yval\_$trial") [expr ($zscore_time("$xval\_$yval\_$trial") + $zscore_dist("$xval\_$yval\_$trial")) /2 ]
              #puts "The performance efficiency for $xval\_$yval\_$trial is $perf_eff("$xval\_$yval\_$trial")"
            } 
	        }
        }
      
      }
    }
    
}


proc draw_path_PE {reference can trial} {

    compute_PE_matrix

    global loadedFile_data
    global loadedFile_timedata
    global originalSize
    global originalGridSize
    global gridLocName

    global perf_eff
    global area_cnt_trial_time
    global sigma_dist
    global sigma_time
    global num_of_trials
    global xval
    global yval
    
    set first 1
  
    foreach {xpos ypos} $loadedFile_data($reference) {

      if {$first} {

        set first 0

      } else {

        $can create line                          \
        [ rawPos $prevXPos ] [ rawPos $prevYPos ] \
        [ rawPos $xpos     ] [ rawPos $ypos     ]

      }

    set prevXPos $xpos
    set prevYPos $ypos

    }

    set maxVal 0
    foreach xval [list 0 1 2 3 4 5] {
     foreach yval [list 0 1 2 3 4 5] {
      if {$sigma_dist("$xval\_$yval") != 0 && $sigma_time("$xval\_$yval") != 0} {
      	if {$perf_eff("$xval\_$yval\_$trial") > $maxVal} {
      	  set maxVal $perf_eff("$xval\_$yval\_$trial")
      	}
      }
     }
    }
    
    foreach xval [list 0 1 2 3 4 5] {
     foreach yval [list 0 1 2 3 4 5] {
      if {$sigma_dist("$xval\_$yval") != 0 && $sigma_time("$xval\_$yval") != 0} {
 
      if {$perf_eff("$xval\_$yval\_$trial") == 0} {       
        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill yellow
        
      } elseif {$perf_eff("$xval\_$yval\_$trial") > 0 } {      
        
        set redVal   65535
        set greenVal [expr {int( 65535.0 - (1.0 * $perf_eff("$xval\_$yval\_$trial"))  / $maxVal * 65535.0 )}]
        set blueVal  29
        set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]       
        set gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill $colorVal
        
      } elseif {$perf_eff("$xval\_$yval\_$trial") < 0} {    
        
        set redVal   1000
	      set greenVal [expr int(65535.0 -  abs(1.0 * $perf_eff("$xval\_$yval\_$trial") / $maxVal) * 65535.0 * .25)]
        set blueVal  1000
        set colorVal [format "#%04x%04x%04x" $redVal $greenVal $blueVal ]     
        set gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill $colorVal
        
      } elseif { $area_cnt_trial_time("$xval\_$yval\_$trial") == 0 || $num_of_trials == 1 } {
       
        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill white
        
      }  else {
       
        set  gridLoc "$xval\_$yval"
        $can itemconfigure $gridLocName($gridLoc) -fill white
        
      }  
      
      }
     }
    }

}
