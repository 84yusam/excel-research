# excel-research
Summer 2015 Excel Research

See various branches to see various versions of code. Note that MazeMap_v5 is the oldest version of the code.

Newest version of the code is HeatMap_v5. 

When the user first opens the program, they will be prompted to choose a directory (such as AW1). The program then creates another window, which separates typical and atypical participants and allows the user to choose which particular maze they want to see for a certain individual. The new pop up window will contain all trials for that maze and individual, and the images can be saved together or individually. The heat maps produced are based on Pesky efficiency scores. The 'aggregate' button for typical and atypical participants shows up to 6 mazes at once, and it shows all paths taken by the individuals on that particular maze.

Multiple directories may be uploaded via the first pop up window. New directories will be put into a new tab.

Currently, the images produced by the HeatMap_v5 code do not match those produced by Rachel's originally HeatMap_v2 code. This applies to time, distance, and Pesky efficiency heat maps. I believe the problem can be found in zscore_pe_v5.tcl, zscore_distance_v5.tcl, and zscore_time_v5.tcl. The particular procs would be draw_pe, draw_dist, and draw_ztime. I have compared z scores for both programs and have found them to be the same. Thus, I believe there is an error in the code calculating the colors used for the HeatMap.
