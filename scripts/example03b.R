library(sen2r)

data_dir <- "/home/lranghetti/share/git/github/ranghetti/sen2r_presentation/data"
safe_dir <- file.path(data_dir, "safe")
out_dir <- file.path(data_dir, "out_ex02")
example_extent <- sf::st_read(file.path(data_dir,"fields_ex.geojson"))
example_timewindow <- c("2018-07-07","2018-07-11")

sen2r(
  system.file("extdata/example_files/scalve.json", package="sen2r"),
  timewindow = example_timewindow,
  extent = example_extent,
  extent_name = "Esempio",
  s2tiles_selected = NA,
  path_l1c = safe_dir,
  path_l2a = safe_dir,
  path_out = out_dir,
  path_indices = out_dir
)

