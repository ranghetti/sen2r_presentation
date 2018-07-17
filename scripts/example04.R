library(sen2r)
library(raster)
library(sf)
library(sprawl)
library(ggplot2)
library(plotly)
library(mapview)

data_dir <- "/home/lranghetti/share/git/github/ranghetti/sen2r_presentation/data"
out_dir <- file.path(data_dir, "out_ex02")

# Load images
msavi_paths <- list.files(file.path(out_dir, "MSAVI"), "\\.tif$", full.names = TRUE)
msavi_meta <- fs2nc_getElements(msavi_paths, format = "data.frame") # get metadata
msavi_meta$paths <- msavi_paths; rm(msavi_paths) # associate paths to metadata
msavi_meta <- msavi_meta[which(!msavi_meta$sensing_date == "2018-06-11"),] # wrong image
msavi_meta <- msavi_meta[order(msavi_meta$sensing_date),] # order by date
msavi_stack <- raster::stack(msavi_meta$paths) # load images

# Aggregate time series by field
fields_ex <- sf::st_read(file.path(data_dir, "fields_ex.geojson")) # read fields
fields_ex$id <- seq_len(nrow(fields_ex)) # use a shorten ID
msavi_aggr <- sprawl::extract_rast(
  msavi_stack,
  fields_ex,
  id_field = "id",
  na.rm = FALSE # only fully-covered fields are considered
)

# Plot time series for some fields
sample_coltures <- data.frame(
  "id" = as.factor(c(
    912, 933, 945, 937, # mais (di prima e seconda)
    5, 306, 986,  32, # riso (allagato e in asciutta)
    882, 849, 859, 883  # riso (in asciutta con sovescio)
  )),
  "colture" = c(
    "Maize", rep("Winter crop + maize", 3),
    rep("Rice (water seeding)", 2), rep("Rice (dry seeding)", 2), 
    rep("Rice (green manure\n+ dry seeding)", 4)
  ),
  stringsAsFactors = FALSE
)
msavi_aggr_sample <- msavi_aggr$stats[
  msavi_aggr$stats$id %in% sample_coltures$id &
    !is.na(msavi_aggr$stats$med),]
msavi_aggr_sample$id <- factor(msavi_aggr_sample$id, levels = sample_coltures$id)

# Compute additional information
msavi_aggr_meta <- fs2nc_getElements(msavi_aggr_sample$band_name, format = "data.frame")
msavi_aggr_sample$date <- msavi_aggr_meta$sensing_date
msavi_aggr_sample$sensor <- msavi_aggr_meta$mission # Sentinel-2A or 2B
msavi_aggr_sample$orbit <- msavi_aggr_meta$id_orbit # Sentinel-2 orbit
msavi_aggr_sample$MSAVI <- msavi_aggr_sample$med / 1E4 # from -1000:1000 to -1:1
msavi_aggr_sample$colture <- sample_coltures[match(msavi_aggr_sample$id, sample_coltures$id), "colture"]

# Build plot of time series
Sys.setlocale("LC_TIME", "en_GB.UTF-8")
msavi_plot_ts <- ggplot(msavi_aggr_sample, aes(x = date, y = MSAVI, label = colture)) +
  geom_line() + 
  geom_point(aes(colour = orbit, shape = sensor), size = 2) +
  # geom_text(data = sample_coltures, x = as.Date("2018-05-15"), y = 0, aes(label = colture)) +
  facet_wrap(~id) +
  coord_cartesian(ylim = c(0, 1)) +
  theme_light()
msavi_plotly <- ggplotly(msavi_plot_ts)

# Show sample images
mapviewOptions(
  basemaps = c("Esri.WorldImagery", "CartoDB.Positron", "OpenStreetMap.Mapnik"),
  raster.palette = colorRampPalette(RColorBrewer::brewer.pal(11, "RdYlGn")),
  na.color = NA
) # mapview styles

msavi_ex01 <- msavi_stack[[which(msavi_meta$sensing_date == as.Date("2018-04-22"))]]/1E4
mapview::mapview(msavi_aggr_sample, label = msavi_aggr_sample$id, alpha.regions = 0, color = "blue") +
  mapview::mapview(msavi_ex01, legend = TRUE, at = seq(-1, 1, .01))
