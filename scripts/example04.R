library(sen2r)

data_dir <- "/home/lranghetti/share/git/github/ranghetti/sen2r_presentation/data"
log_path <- file.path(data_dir, strftime(Sys.time(), "sen2r_example04_%Y%m%d_%H%M%S.log.txt"))

sen2r(
  "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example02.json",
  timewindow = 5,
  log = file.path(data_dir, strftime(Sys.time(),"sen2r_example_%Y%m%d_%H%M%S.log.txt"))
)
