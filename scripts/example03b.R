library(sen2r)

# 1: change the time window (build the archive)
sen2r(
  "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example02.json",
  timewindow = c("2017-01-01", "2017-12-31")
)

# 2: process a different area of interest
data_dir <- "/home/lranghetti/share/git/github/ranghetti/sen2r_presentation/data"
out_dir_1 <- file.path(data_dir, "out_ex03b1")
sen2r(
  "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example02.json",
  extent = system.file("extdata/example_files/scalve.json", package="sen2r"),
  extent_name = "Scalve",
  path_out = out_dir_1,
  path_indices = out_dir_1
)

# 3: change some processing parameters
out_dir_2 <- file.path(data_dir, "out_ex03b2")
sen2r(
  "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example02.json",
  mask_type = NA,
  extent_as_mask = TRUE,
  path_out = out_dir_2,
  path_indices = out_dir_2
)
