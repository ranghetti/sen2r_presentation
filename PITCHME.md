---?image=https://www.esa.int/var/esa/storage/images/esa_multimedia/images/2015/02/colour_vision_for_copernicus/15250391-1-eng-GB/Colour_vision_for_Copernicus.jpg&size=cover
# **sen2r**: an R toolbox to find, download and preprocess Sentinel-2 data

---

## Introduction

### Sentinel-2 data
- Sentinel-2A available from July 2015 (revisiting time: 10 day);
- Sentinel-2B available from July 2017 (joint revisiting time: 5 days);

+++

- 12 [spectral bands](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/resolutions/radiometric) at 10, 20 or 60 metres [resolution](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/resolutions/spatial):
    ![Sentinel-2 bands](https://landsat.gsfc.nasa.gov/wp-content/uploads/2015/06/Landsat.v.Sentinel-2.png)

+++

- short [revisiting time](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/revisit-coverage) (5-days or less for cloudly-free areas)
    ![](https://sentinel.esa.int/documents/247904/3394924/Figure-2.jpg)

+++

- provided in [SAFE](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/data-formats) format:
    ![](https://sentinel.esa.int/documents/247904/266422/Sentinel-2_Data_Formats_Figure_1.jpg)
    
    (with two different -- both long -- [naming conventions](https://sentinel.esa.int/web/sentinel/user-guides/sentinel-2-msi/naming-convention))

---

### What **sen2r** is for
@ul
- download Sentinel-2 images (Level-1C or 2A) matching input conditions;
- apply [sen2cor](http://step.esa.int/main/third-party-plugins-2/sen2cor) to atmospherically correct Level-1C products;
- perform geometric manupulation of images (clip, rescale, reproject, merge contiguous tiles, etc.);
- apply a cloud mask;
- produce spectral indices;
- obtain output prodicts in file formats managed by GDAL (e.g. GeoTIFF).
@ulend

+++

In general, the aim is to provide R functions to *semi-automatically* perform recurrent processing operations on Sentinel-2 products.

_Target_: data scientists with basic skills on R and geoprocessing.

+++

### What **sen2r** is *not* for
@ul
- interactively search specific products<br/>([&rightarrow; Copernicus Open Hub](https://scihub.copernicus.eu/dhus));
- download products through a user-friendly interface<br/>(&rightarrow; GeoGrabber);
- interactively perform processing operations on specific images<br/>([&rightarrow; ESA SNAP](http://step.esa.int/main/toolboxes/snap)).
@ulend

---

## Installation

### Standard installation

@ol
1. install the package **devtools**
    ```r
    install.packages("devtools")
    ```
2. install **sen2r** from [GitHub](https://github.com/ranghetti/sen2r) and load it
    ```r
    devtools::install_github("ranghetti/sen2r")
    library(sen2r)
    ```
@olend

+++

3. install external dependencies
    - [**mandatory**] [**GDAL**](http://www.gdal.org/)  (with support for JP2OpenJPEG format) 
    - [*optional*] [**sen2cor**](http://step.esa.int/main/third-party-plugins-2/sen2cor) (required to convert Level-1C to Level-2a)
    - [*optional*] **Wget** (required to work online)
    - [*optional*] [**aria2**](https://aria2.github.io/) (to speed up the download of SAFE archives)
    ```r
    check_sen2r_deps() # graphical mode
    # or
    sen2r:::load_binpaths(c("python", "wget", "aria2c", "gdal", "sen2cor")) # automatic mode
    ```

---

### Docker installation
TODO

---

## Usage

### 1. Single interactive run
```r
sen2r()
```
Execute it in interactive mode ([shiny](https://shiny.rstudio.com) interface):
1. set the parameters graphically;
2. [optional] save a parameter JSON file to run/restore the processing;
3. launch the processing.
[![Sheet 1](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet1_small.png)<!-- .element height="20%" width="20%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet1.jpg) [![Sheet 2](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet2_small.png)<!-- .element height="20%" width="20%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet2.jpg) [![Sheet 3](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet3_small.png)<!-- .element height="20%" width="20%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet3.jpg) [![Sheet 4](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet4_small.png)<!-- .element height="20%" width="20%" -->](https://raw.githubusercontent.com/ranghetti/sen2r/devel/man/figures/sen2r_gui_sheet4.jpg)

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

---

### 3. Launch as R function, using function arguments

```r
example_dir <- system.file("extdata","example_files", package="sen2r")
safe_dir <- file.path(example_dir, "safe")
out_dir <- file.path(example_dir, "out")
example_extent <- sf::st_read(file.path(safe_dir, "scalve.kml"))

sen2r(
  gui = FALSE,                         # run without opening the GUI
  step_atmcorr = "l2a",                # consider only Level-2A products
  extent = example_extent,             # set the desired extent
  extent_name = "Scalve",              # set the name (used in output files)
  extent_as_mask = TRUE,               # clip on the input polygon,
  timewindow = as.Date("2016-12-05"),  # set the time window
  list_prods = "BOA",                  # produce Surface Reflectance
  list_indices = c("MSAVI", "NDRE"),   # produce these spectral indices
  mask_type = "cloud_medium_proba",    # define a cloud mask
  path_l2a = safe_dir,                 # save here SAFE archives
  path_out = out_dir,                  # save here output products
  path_indices = out_dir               # save here indices
)
```

See the [documentation of the function](https://ranghetti.github.io/sen2r/reference/sen2r.html):
```{r, eval = FALSE}
?sen2r
```

---

## Intermediate functions
Functions used by `sen2r()` to perform specific steps, and which can be used individually:

### [Find and download Sentinel-2 products](https://ranghetti.github.io/sen2r/reference/index.html#section-find-and-download-sentinel-products)
| | |
---|---
`s2_list()` | [Retrieve list of available products.](https://ranghetti.github.io/sen2r/reference/s2_list.html)
`s2_download()` | [Download S2 products.](https://ranghetti.github.io/sen2r/reference/s2_download.html)
`sen2cor()` | [Correct L1C products using sen2cor](https://ranghetti.github.io/sen2r/reference/sen2cor.html)

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

## Work in progress!
- [[#80](https://github.com/ranghetti/sen2r/issues/80)] Add [THEIA images](http://www.theia-land.fr/en/products/sentinel-2-surface-reflectance) as possible sources (atmospheric correction with [MACCS-MAJA](http://www.cesbio.ups-tlse.fr/multitemp/?p=6203) processor);
- improve user experience (GUI interface, documentation, logging);
- several bug fixes (users can report them on [GitHub](https://github.com/ranghetti/sen2r/issues));
- publish a stable version on [CRAN](https://cran.r-project.org).

+++

### Test the package

You are the beta-testers!

In case of errors, [open a new issue on GitHub](https://github.com/ranghetti/sen2r/issues)
*(anche in italiano)*.


