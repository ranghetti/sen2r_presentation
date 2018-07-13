---?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover
<div style="position:fixed;left:10px;bottom:0%;">![](https://api.qrserver.com/v1/create-qr-code/?size=200x200&margin=5&data=https://gitpitch.com/ranghetti/sen2r_presentation)</div>

# <div align="right">@color[white](@size[150%](<span style="color:white;vertical-align:top;font-size:90%;font-weight:normal;text-transform:lowercase;">sen</span><span style="color:white;vertical-align:baseline;font-size:115%;font-weight:bolder;">2</span><span style="color:white;vertical-align:baseline;font-size:90%;font-weight:bold;text-transform:lowercase;">r</span>:)<br/>an R toolbox<br/>to find, download<br/>and preprocess<br/>Sentinel-2 data)</div>

---?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

## Introduction

### Sentinel-2 data
- Sentinel-2A available from July 2015 (revisiting time: 10 day);
- Sentinel-2B available from July 2017 (joint revisiting time: 5 days);

+++?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

- 12 [spectral bands](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/resolutions/radiometric) at 10, 20 or 60 metres [resolution](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/resolutions/spatial):
    ![Sentinel-2 bands](https://landsat.gsfc.nasa.gov/wp-content/uploads/2015/06/Landsat.v.Sentinel-2.png)

+++?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

- short [revisiting time](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/revisit-coverage) (5-days or less for cloudly-free areas)
    ![](https://sentinel.esa.int/documents/247904/3394924/Figure-2.jpg)

+++?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

- provided in [SAFE](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/data-formats) format:
    ![](https://sentinel.esa.int/documents/247904/266422/Sentinel-2_Data_Formats_Figure_1.jpg)
    
    (with two different -- both long -- [naming conventions](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/naming-convention))

---?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

### What <span style="color:#5793dd;vertical-align:top;font-size:90%;font-weight:normal;text-transform:lowercase;">sen</span><span style="color:#6a7077;vertical-align:baseline;font-size:115%;font-weight:bolder;">2</span><span style="color:#2f66d5;vertical-align:baseline;font-size:90%;font-weight:bold;text-transform:lowercase;">r</span> is for
@ul
- download Sentinel-2 images (Level-1C or 2A) matching input conditions;
- apply [sen2cor](http://step.esa.int/main/third-party-plugins-2/sen2cor) to atmospherically correct Level-1C products;
- perform geometric manupulation of images (clip, rescale, reproject, merge contiguous tiles, etc.);
- apply a cloud mask;
- produce spectral indices;
- obtain output prodicts in file formats managed by GDAL (e.g. GeoTIFF).
@ulend

+++?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

In general, the aim is to provide R functions to *semi-automatically* perform recurrent processing operations on Sentinel-2 products.

_Target_: data scientists with basic skills on R and geoprocessing.

+++?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

### What <span style="color:#5793dd;vertical-align:top;font-size:90%;font-weight:normal;text-transform:lowercase;">sen</span><span style="color:#6a7077;vertical-align:baseline;font-size:115%;font-weight:bolder;">2</span><span style="color:#2f66d5;vertical-align:baseline;font-size:90%;font-weight:bold;text-transform:lowercase;">r</span> is **not** for
@ul
- interactively search specific products<br/>([&rightarrow; Copernicus Open Hub](https://scihub.copernicus.eu/dhus));
- download products through a user-friendly interface<br/>(&rightarrow; GeoGrabber);
- interactively perform processing operations on specific images<br/>([&rightarrow; ESA SNAP](http://step.esa.int/main/toolboxes/snap)).
@ulend

---?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover&opacity=50

## Installation

### Standard installation

1. install the package **devtools**
    ```r
    install.packages("devtools")
    ```

2. install **sen2r** from [GitHub](https://github.com/ranghetti/sen2r) and load it
    ```r
    devtools::install_github("ranghetti/sen2r")
    library(sen2r)
    ```

+++

3: install external dependencies
- [**mandatory**] [**GDAL**](http://www.gdal.org/)  (with support for JP2OpenJPEG format) 
- [*optional*] [**sen2cor**](http://step.esa.int/main/third-party-plugins-2/sen2cor) (required to convert Level-1C to Level-2a)
- [*optional*] **Wget** (required to work online)
- [*optional*] [**aria2**](https://aria2.github.io/) (to speed up the download of SAFE archives)
```r
check_sen2r_deps()
# or
sen2r:::load_binpaths(c("python", "wget", "aria2c", "gdal", "sen2cor"))
```
@[1](graphical mode)
@[3](automatic mode)

---

### Docker installation
TODO

---

## Usage

### 1. Single interactive run
```r
library(sen2r)
sen2r()
```
Execute it in interactive mode ([shiny](https://shiny.rstudio.com) interface):
1. set the parameters graphically;
2. [optional] save a parameter JSON file to run/restore the processing;
3. launch the processing.

+++

#### GUI preview

| | |
---|---
@fa[image](Product selection)<br/>[![Sheet 1](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet1_small.png)<!-- .element height="70%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet1.jpg)   |   @fa[clone](Spatio-temporal selection)<br/>[![Sheet 2](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet2_small.png)<!-- .element height="70%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet2.jpg)
@fa[th](Processing options)<br/>[![Sheet 3](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet3_small.png)<!-- .element height="70%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet3.jpg)   |   @fa[calculator](Spectral indices selection)<br/>[![Sheet 4](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet4_small.png)<!-- .element height="70%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet4.jpg)

#### Run example
[@fa[terminal]](http://10.0.1.230:8787)

---

### 2. Run from an existing parameter file
Launch it from R commandline:
```r
sen2r("/path/of/the/existing/parameter_file.json")
```
Launch it from the terminal:
```bash
R -e "sen2r::sen2r('/path/of/the/existing/parameter_file.json')"
```

+++

#### Example 02

`/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example02.json`
```json
{
  "preprocess": [true],
  "s2_levels": ["l1c", "l2a"],
  "sel_sensor": ["s2a", "s2b"],
  "online": [true],
  "downloader": ["aria2"],
  "overwrite_safe": [false],
  "rm_safe": ["no"],
  "step_atmcorr": ["auto"],
  "timewindow": ["2018-07-07","2018-07-11"],
  "timeperiod": ["full"],
  "extent": ["/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data/fields_ex.geojson"],
  "s2tiles_selected": [null],
  "s2orbits_selected": [null],
  "list_prods": ["BOA"],
  "list_indices": ["MSAVI"],
  "index_source": ["BOA"],
  "mask_type": ["cloud_medium_proba"],
  "max_mask": [80],
  "mask_smooth": [100],
  "mask_buffer": [100],
  "clip_on_extent": [true],
  "extent_as_mask": [true],
  "extent_name": ["Esempio"],
  "reference_path": [null],
  "res": [null],
  "res_s2": ["10m"],
  "unit": ["Meter"],
  "proj": ["+proj=longlat +datum=WGS84 +no_defs"],
  "resampling": ["near"],
  "resampling_scl": ["near"],
  "outformat": ["GTiff"],
  "index_datatype": ["Int16"],
  "compression": ["DEFLATE"],
  "overwrite": [false],
  "path_l1c": ["/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data/safe"],
  "path_l2a": ["/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data/safe"],
  "path_tiles": [null],
  "path_merged": [null],
  "path_out": ["/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data/out"],
  "path_indices": ["/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data/out"],
  "path_subdirs": [true],
  "thumbnails": [true],
  "pkg_version": ["0.3.2"]
}
```
@[10,12-13,24,36-37,40-41](These lines were edited from [scalve.json](https://github.com/ranghetti/sen2r/blob/master/inst/extdata/example_files/scalve.json))

+++

Launch it:

```r
sen2r("/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example02.json")
```

---

### 3. Launch as R function, using function arguments
See the [documentation of the function](https://ranghetti.github.io/sen2r/reference/sen2r.html):
```r
?sen2r
```

+++

#### Example 03
`/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example03.R`
```r
library(sen2r)

data_dir <- "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data"
safe_dir <- file.path(example_dir, "safe")
out_dir <- file.path(example_dir, "out")
example_extent <- sf::st_read(file.path(data_dir,"fields_ex.geojson"))
example_timewindow <- c("2018-07-07","2018-07-11")

sen2r(
  gui = FALSE,                         # run without opening the GUI
  online = FALSE,                      # use only local SAFE archives
  step_atmcorr = "l2a",                # consider only Level-2A products
  timewindow = example_timewindow,     # define the time window
  extent = example_extent,             # set the desired extent
  extent_name = "Esempio",             # set the name (used in output files)
  extent_as_mask = TRUE,               # clip on the input polygon,
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
```
(equivalent to example 02)

+++

#### Example 03b
or use a parameter file and change only some parameters
```r
library(sen2r)

data_dir <- "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data"
safe_dir <- file.path(example_dir, "safe")
out_dir <- file.path(example_dir, "out")
example_extent <- sf::st_read(file.path(data_dir,"fields_ex.geojson"))
example_timewindow <- c("2018-07-07","2018-07-11")

sen2r(
  system.file("extdata/example_files/scalve.kml", package="sen2r"),
  timewindow = example_timewindow,
  extent = example_extent,
  extent_name = "Esempio",
  s2tiles_selected = NA,
  path_l1c = safe_dir,
  path_l2a = safe_dir,
  path_out = out_dir,
  path_indices = out_dir
)
```
(useful to launch similar processing chains changing only e.g. the extent)

---

## Intermediate functions
Functions used by `sen2r()` to perform specific steps, and which can be used individually:

+++

### [Find and download Sentinel-2 products](https://ranghetti.github.io/sen2r/reference/index.html#section-find-and-download-sentinel-products)
| | |
---|---
`s2_list()` | [Retrieve list of available products.](https://ranghetti.github.io/sen2r/reference/s2_list.html)
`s2_download()` | [Download S2 products.](https://ranghetti.github.io/sen2r/reference/s2_download.html)
`sen2cor()` | [Correct L1C products using sen2cor](https://ranghetti.github.io/sen2r/reference/sen2cor.html)

+++

### [Read and convert SAFE format](https://ranghetti.github.io/sen2r/reference/index.html#section-read-and-convert-safe-format)

| | |
---|---
`s2_getMetadata()` | [Get information from S2 file name or metadata](https://ranghetti.github.io/sen2r/reference/s2_getMetadata.html)
`s2_translate()` | [Convert from SAFE format](https://ranghetti.github.io/sen2r/reference/s2_translate.html)
`s2_merge()` | [Merge S2 tiles with the same date and orbit](https://ranghetti.github.io/sen2r/reference/s2_merge.html)
`gdal_warp()` | [Clip, reproject and warp raster files](https://ranghetti.github.io/sen2r/reference/gdal_warp.html)
`s2_mask()` | [Apply cloud masks](https://ranghetti.github.io/sen2r/reference/s2_mask.html)
`s2_calcindices()` | [Compute maps of spectral indices](https://ranghetti.github.io/sen2r/reference/s2_calcindices.html)

---

## Schedule a daily download

What is needed:
- a R script to run;
- [additional] a JSON parameter file;
- a cron job.
    
+++

#### Example 04

##### R script and JSON file
`/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example04.R`
```r
library(sen2r)

data_dir <- "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/data"
log_path <- file.path(data_dir, strftime(Sys.time(), "sen2r_example04_%Y%m%d_%H%M%S.log.txt"))

sen2r(
  "/mnt/nr_working/luigi/docs/sen2r/180719_presentation/example02.json",
  timewindow = 5,
  log = file.path(data_dir, 
)
```

+++

##### Cron job 

On Linux: add a crontab entry or create a systemd timer

```bash
crontab -e
```

```bash
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command

# Sentinel-2 example cron job
  20  0 * * * /usr/bin/Rscript /mnt/nr_working/luigi/docs/sen2r/180719_presentation/example04.R
```
@[23,26](Now the job is scheduled to run every day at 0:20)

+++

On Windows, use the [Task Scheduler](https://docs.microsoft.com/en-us/windows/desktop/taskschd/task-scheduler-start-page)
![Task Scheduler screenshot](https://i.stack.imgur.com/Aqa57.png)

---

## Work in progress!
- [[#80](https://github.com/ranghetti/sen2r/issues/80)] Add [THEIA images](http://www.theia-land.fr/en/products/sentinel-2-surface-reflectance) as possible sources (atmospheric correction with [MACCS-MAJA](http://www.cesbio.ups-tlse.fr/multitemp/?p=6203) processor);
- improve user experience (GUI interface, documentation, logging);
- several bug fixes (users can report them on [GitHub](https://github.com/ranghetti/sen2r/issues));
- publish a stable version on [CRAN](https://cran.r-project.org).

+++

### Test the package

You are the beta-testers!

In case of errors, you are welcome to [open a new issue on GitHub](https://github.com/ranghetti/sen2r/issues)
*(anche in italiano)*.


