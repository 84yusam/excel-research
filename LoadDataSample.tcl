proc iterate_dir { dir } {

  global folderList

  set folderList {}
  set contents [glob -directory $dir *]
  foreach item $contents {
    if {[file isdirectory $item] == 1} {
      lappend $folderList $item
    }
  }

}
