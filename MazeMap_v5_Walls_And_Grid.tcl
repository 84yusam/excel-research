proc draw_outer_walls { can } {
  
  global basic_grid_items
  global gridLocSize
  global can_width
  
  $can create line                   \
    [gridPos [expr {2.0 / 3.0}]]     \
    [gridPos 0]                      \
    [gridPos 0]                      \
    [gridPos [expr {-1 * 2.0 / 3.0}]]\
    [gridPos 0]                      \
    [gridPos [expr {-1 * 2.0 / 3.0}]]\
    [gridPos [expr {-1 * 2.0 / 3.0}]]\
    [gridPos 0]                      \
    [gridPos [expr {-1 * 2.0 / 3.0}]]\
    [gridPos 0]                      \
    [gridPos 0]                      \
    [gridPos [expr {2.0 / 3.0}]]     \
    [gridPos 0]                      \
    [gridPos [expr {2.0 / 3.0}]]     \
    [gridPos 0]                      \
    [gridPos 6]                      \
    [gridPos 0]                      \
    [gridPos 6]                      \
    [gridPos [expr {5 + 1.0 / 3.0} ]]\
    [gridPos 6]                      \
    [gridPos 6]                      \
    [gridPos [expr {6 + 2.0 / 3.0} ]]\
    [gridPos [expr {6 + 2.0 / 3.0} ]]\
    [gridPos 6]                      \
    [gridPos 6]                      \
    [gridPos [expr {5 + 1.0 / 3.0} ]]\
    [gridPos 6]                      \
    [gridPos 0]                      \
    [gridPos 6]                      \
    [gridPos 0]                      \
    [gridPos [expr {2.0 / 3.0}]]     \
    [gridPos 0]                      \
    -width 2
}


proc draw_inner_walls { maze_version can } {

  global dashPattern
  global lineWidth

  global solidLines
  global dashedLines

  foreach {x1 y1 x2 y2} $solidLines($maze_version) {

    $can create line                                          \
      [gridPos $x1] [gridPos $y1] [gridPos $x2] [gridPos $y2] \
      -width $lineWidth
  }

  foreach {x1 y1 x2 y2} $dashedLines($maze_version) {
    $can create line                                          \
      [gridPos $x1] [gridPos $y1] [gridPos $x2] [gridPos $y2] \
      -width $lineWidth                                       \
      -dash  $dashPattern

  }
}

proc draw_grid_loc { grid_loc can } {
  
  global gridLocName
  
  set xind [lindex [split $grid_loc "_"] 0]
  set yind [lindex [split $grid_loc "_"] 1]
  
  set coordValue {}


  lappend coordValues [gridPos $xind]
  lappend coordValues [gridPos $yind]

  lappend coordValues [gridPos [expr {$xind + 1}]]
  lappend coordValues [gridPos $yind]

  lappend coordValues [gridPos [expr {$xind + 1}]]
  lappend coordValues [gridPos [expr {$yind + 1}]]

  lappend coordValues [gridPos $xind]
  lappend coordValues [gridPos [expr {$yind + 1}]]
  

  set gridLocName($grid_loc) [$can create polygon $coordValues -fill white -outline gold]
}


proc draw_grid {can} {
  
  global basic_grid_items
  global gridLocSize
  global can_width
  global xOff
  global yOff
  global gridLocName
  
  set gridLocSize [expr {($can_width - ([gridPos 0] * 2)) / 6.0} ]
  
  foreach item $basic_grid_items {
    
    switch -exact $item {
      "0_0" {
        
        set coordValues {}

        lappend coordValues [gridPos [expr {2.0 / 3.0}] ]
        lappend coordValues [gridPos 0                ]

        lappend coordValues [gridPos 1 ]
        lappend coordValues [gridPos 0 ]

        lappend coordValues [gridPos 1 ]
        lappend coordValues [gridPos 1 ]

        lappend coordValues [gridPos 0 ]
        lappend coordValues [gridPos 1 ]

        lappend coordValues [gridPos 0 ]
        lappend coordValues [gridPos [expr {2.0 / 3.0} ] ]

        set gridLocName($item) [$can create polygon $coordValues -fill white -outline gold] 

        set coordValues {}

        lappend coordValues [gridPos [expr {2.0 / 3.0}] ]
        lappend coordValues [gridPos 0]

        lappend coordValues [gridPos 0]
        lappend coordValues [gridPos [expr {-1 * 2.0 / 3.0}] ]

        lappend coordValues [gridPos [expr {-1 * 2.0 / 3.0}] ]
        lappend coordValues [gridPos 0]


        lappend coordValues [gridPos 0]
        lappend coordValues [gridPos [expr {2.0 / 3.0} ]]

        set i [$can create polygon $coordValues -fill white -outline red]

        $can create text [gridPos 0] [gridPos 0] -anchor center -text "F"

      }
      "5_5" {

        set coordValues {}

        lappend coordValues [gridPos 5]
        lappend coordValues [gridPos 5]

        lappend coordValues [gridPos 6]
        lappend coordValues [gridPos 5]

        lappend coordValues [gridPos 6]
        lappend coordValues [gridPos [expr {5 + 1.0 / 3.0}]]

        lappend coordValues [gridPos [expr {5 + 1.0 / 3.0}]]
        lappend coordValues [gridPos 6]

        lappend coordValues [gridPos 5]
        lappend coordValues [gridPos 6]

        set gridLocName($item) [$can create polygon $coordValues -fill white -outline gold]
        
        set coordValues {}

        lappend coordValues [gridPos 6]
        lappend coordValues [gridPos [expr {5 + 1.0 / 3.0}]]

        lappend coordValues [gridPos [expr {5 + 1.0 / 3.0}]]
        lappend coordValues [gridPos 6]


        lappend coordValues [gridPos 6]
        lappend coordValues [gridPos [expr {6 + 2.0 / 3.0}]]

        lappend coordValues [gridPos [expr {6 + 2.0 / 3.0}]]
        lappend coordValues [gridPos 6 ]

        set i [$can create polygon $coordValues -fill white -outline red]        

        lappend coordValues [gridPos [expr {5 + 1.0 / 3.0}]]
        lappend coordValues [gridPos 6]

        $can create text [gridPos 6] [gridPos 6] \
          -anchor center                         \
          -text "S"

      }
      default {
        draw_grid_loc $item $can
      }
    }
  }

}
