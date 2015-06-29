set dashPattern {2 2 2 2 2}
set lineWidth   2

set originalGridSize 256

set originalSize     [expr {$originalGridSize * 6}]

set displayGridSize  40

set displaySize      [expr { $displayGridSize * 6}]

set displayOffset    35

set can_width  [ expr {$displayOffset * 2 + $displaySize} ]
set can_height [ expr {$displayOffset * 2 + $displaySize} ]

#coordinates of locations of solid lines
array set solidLines {
  "maze1"  { 3 0 3 2
              0 3 2 3
              5 0 5 4
              0 5 4 5 }
  "maze2"  { 1 0 1 2 3 0 3 2 2 3 4 3 2 3 2 6 }
  "maze3"  { 1 2 6 2 1 2 1 4 3 3 6 3 3 3 3 5 }
  "maze4"  { 3 1 6 1 3 1 3 3 3 3 4 3 5 3 5 4 0 4 5 4 }
  "maze5"  { 0 1 1 1 1 1 1 3 1 3 3 3 2 0 2 1 2 1 4 1 4 1 4 5 }
  "maze6"  { 0 1 5 1 0 3 4 3 4 3 4 5 }
  "maze7"  { 0 1 3 1 3 1 3 3 4 1 6 1 4 1 4 4 }
  "maze8"  { 1 0 1 3 1 3 3 3 4 3 5 3 5 3 5 4 0 4 5 4 }
  "maze9"  { 0 1 5 1 1 1 1 4 1 4 3 4 2 3 6 3 4 3 4 5 }
  "maze10" { 1 0 1 2 1 2 4 2 5 2 5 4 0 4 5 4 }
  "maze11" { 0 1 3 1 4 1 6 1 3 1 3 3 4 1 4 4 1 3 1 5 2 2 2 4 }
  "maze12" { 1 0 1 5 1 5 2 5 2 1 2 4 4 4 4 6 }
}

#Coordinates of locations of dashed lines
array set dashedLines {
  "maze1"  { 3 1 5 1  1 3 1 5 3 2 5 4 2 3 4 5 5 2 6 2 5 4 6 4 2 5 2 6 4 5 4 6 }
  "maze2"  { 1 1 3 1 1 2 6 2 3 3 3 6 4 3 4 6 0 3 2 3 }
  "maze3"  { 1 0 1 2 1 4 3 5 3 4 6 4 3 5 6 5 3 2 3 3 }
  "maze4"  { 3 0 3 1 3 4 3 6 5 4 5 6 3 3 5 1 0 2 2 4 }
  "maze5"  { 0 3 1 3 3 3 3 6 4 0 4 1 4 3 6 3 4 5 6 5 }
  "maze6"  { 3 1 3 3 3 3 3 6 4 1 4 3 4 5 4 6 }
  "maze7"  { 3 3 3 6 0 3 3 3 4 3 6 3 4 4 6 4 0 3 2 1 4 0 4 1 }
  "maze8"  { 1 2 3 0 3 3 6 0 3 4 3 6 5 4 5 6 }
  "maze9"  { 1 3 3 1 3 4 3 6 4 4 6 4 4 5 6 5 0 4 1 4 }
  "maze10" { 3 0 3 2 4 0 4 2 3 4 3 6 5 4 5 6 }
  "maze11" { 4 0 4 1 2 1 2 2 2 4 2 6 4 3 6 3 4 4 6 4 3 3 3 6 }
  "maze12" { 2 0 2 1 2 4 2 5 }
}

#Coordinate system of locations
set basic_grid_items {
  "0_1" "0_2" "0_3" "0_4" "0_5"
  "1_0" "1_1" "1_2" "1_3" "1_4" "1_5"
  "2_0" "2_1" "2_2" "2_3" "2_4" "2_5"
  "3_0" "3_1" "3_2" "3_3" "3_4" "3_5"
  "4_0" "4_1" "4_2" "4_3" "4_4" "4_5"
  "5_0" "5_1" "5_2" "5_3" "5_4" "5_5" "0_0"
}

# grid position is sum of position, displayed grid size, and displayOffSet
proc gridPos { position } {

  global displayOffset
  global displayGridSize

  return [ expr {$displayOffset + $position * $displayGridSize} ]
}

# how to change image size (ratio or display size)
proc rawPos { pos } {

    global displayOffset
    global displaySize
    global originalSize

    return [ expr $displayOffset + ($displaySize * ( ($originalSize - $pos) / $originalSize) ) ]
}
