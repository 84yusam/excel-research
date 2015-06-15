set dest_directory   "../AW1_imgs"
set return_directory [pwd]

cd $dest_directory

foreach dir1 [glob *] {

  puts $dir1
  cd   $dir1

  foreach dir2 [glob *] {

    puts "\t$dir2"
    cd   $dir2

    foreach dir3 [glob *] {

      if {[file isdirectory $dir3]} {

        puts "\t\t$dir3"
        cd   $dir3

        file delete -force *.pdf
        file delete -force *.ppm
        file delete -force *.eps
        file delete -force *.jpg
        file delete -force *.png

        foreach item [glob *.ps] {
          
          regexp {^(.+)\.ps$} $item match filename
          
          puts "\t\t\t$filename"
          exec ps2eps -q --ignoreBB $filename.ps
          exec epstopdf  $filename.eps
          exec pdftoppm  $filename.pdf $filename
          exec pnmtojpeg $filename-1.ppm > $filename.jpg
          exec pnmtopng  $filename-1.ppm > $filename.png

        }

        cd ..

      } elseif {[regexp {^(.+)\.ps$} $dir3 match filename ]} {

        file delete -force "$filename.pdf"
        file delete -force "$filename.ppm"
        file delete -force "$filename.eps"
        file delete -force "$filename.jpg"
        file delete -force "$filename.png"

        exec ps2eps -q --ignoreBB "$filename.ps"
        exec epstopdf  "$filename.eps"
        exec pdftoppm  "$filename.pdf"     $filename
        exec pnmtojpeg "$filename-1.ppm" > "$filename.jpg"
        exec pnmtopng  "$filename-1.ppm" > "$filename.png"

      }
    }

    cd ..
  }

  cd ..
}

puts "file conversion complete"

cd $return_directory