library(sen2r)

data_dir <- "/home/lranghetti/share/git/github/ranghetti/sen2r_presentation/data"
safe_dir <- file.path(data_dir, "safe")
out_dir <- file.path(data_dir, "out_ex02")
example_extent <- sf::st_read(file.path(data_dir,"fields_ex.geojson"))
example_timewindow <- c("2018-03-01","2018-09-30")

sen2r(
  gui = FALSE,                         # run without opening the GUI
  online = TRUE,                       # search available SAFE
  step_atmcorr = "l2a",                # consider only Level-2A products
  timewindow = example_timewindow,     # define the time window
  extent = example_extent,             # set the desired extent
  extent_name = "Esempio",             # set the name (used in output files)
  list_prods = "BOA",                  # produce Surface Reflectance
  list_indices = c("MSAVI"),           # produce these spectral indices
  mask_type = "cloud_medium_proba",    # define a cloud mask
  max_mask = 80,                       # do not produce images with a cover > 80%
  mask_smooth = 100,                   # bufferize cloud coverages with a 100m radius
  mask_buffer = 100,                   # use a smoothing radius of 100m
  proj = 4326,                         # reproject in geographical coordinates
  path_l1c = safe_dir,                 # save here SAFE archives
  path_l2a = safe_dir,                 # save here SAFE archives
  path_out = out_dir,                  # save here output products
  path_indices = out_dir               # save here indices
)
