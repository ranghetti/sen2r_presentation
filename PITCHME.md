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

---

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

+++
<!-- .slide: style="center: false" -->

#### Output
```
out_ex01
├── BOA
│   ├── S2A2A_20180711_065_Esempio_BOA_10.tif
│   ├── S2B2A_20180709_108_Esempio_BOA_10.tif
│   └── thumbnails
│       ├── S2A2A_20180711_065_Esempio_BOA_10.jpg
│       ├── S2A2A_20180711_065_Esempio_BOA_10.jpg.aux.xml
│       ├── S2B2A_20180709_108_Esempio_BOA_10.jpg
│       └── S2B2A_20180709_108_Esempio_BOA_10.jpg.aux.xml
└── MSAVI
    ├── S2A2A_20180711_065_Esempio_MSAVI_10.tif
    ├── S2B2A_20180709_108_Esempio_MSAVI_10.tif
    └── thumbnails
        ├── S2A2A_20180711_065_Esempio_MSAVI_10.jpg
        ├── S2A2A_20180711_065_Esempio_MSAVI_10.jpg.aux.xml
        ├── S2B2A_20180709_108_Esempio_MSAVI_10.jpg
        └── S2B2A_20180709_108_Esempio_MSAVI_10.jpg.aux.xml
```
@[1,2,10](One subdir for each product (optional))
@[3-4,11-12](Output images with a short naming convention)
@[1,2,5,10,13](Subfolders with JPEG thumbnails (optional))

@[6]([<img src="https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/BOA/thumbnails/S2A2A_20180711_065_Esempio_BOA_10.jpg" alt="S2A2A_20180711_065_Esempio_BOA_10.jpg" height=150px>](https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/BOA/thumbnails/S2A2A_20180711_065_Esempio_BOA_10.jpg))
@[8]([<img src="https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/BOA/thumbnails/S2B2A_20180709_108_Esempio_BOA_10.jpg" alt="S2B2A_20180709_108_Esempio_BOA_10.jpg" height=150px>](https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/BOA/thumbnails/S2B2A_20180709_108_Esempio_BOA_10.jpg))
@[14]([<img src="https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/MSAVI/thumbnails/S2A2A_20180711_065_Esempio_MSAVI_10.jpg" alt="S2A2A_20180711_065_Esempio_MSAVI_10.jpg" height=150px>](https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/MSAVI/thumbnails/S2A2A_20180711_065_Esempio_MSAVI_10.jpg))
@[16]([<img src="https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/MSAVI/thumbnails/S2B2A_20180709_108_Esempio_MSAVI_10.jpg" alt="S2B2A_20180709_108_Esempio_MSAVI_10.jpg" height=150px>](https://raw.githubusercontent.com/ranghetti/sen2r_presentation/devel/data/out_ex01/MSAVI/thumbnails/S2B2A_20180709_108_Esempio_MSAVI_10.jpg))

<span style="display:block; height: 150px;"></span>

---

#### <a name="naming"></a>Naming convention

@color[blue](`S2mll`)`_`@color[blue](`yyyymmdd`)`_`@color[blue](`rrr`)`_`@color[blue](`ttttt`)`_`@color[blue](`ppp`)`_`@color[blue](`rr`)`.`@color[blue](`fff`)

@ul
* @color[blue](`S2mll`) mission ID (`S2A` or `S2B`) and product level (`1C` or `2A`);
* @color[blue](`yyyymmdd`) sensing date (e.g. `20170603` for 2017-06-03);
* @color[blue](`rrr`) relative orbit number (e.g. `022`);
* @color[blue](`ttttt`) tile number (e.g. `32TQQ`);
* @color[blue](`ppp`) output product (`TOA`, `BOA`, `TCI`, index name);
* @color[blue](`rr`) original minimum spatial resolution in metres (10, 20 or 60);
* @color[blue](`fff`) file extension.
@ulend

E.g. `S2A2A_20180711_065_Esempio_BOA_10.jpg`

See also [the documentation](https://ranghetti.github.io/sen2r/reference/s2_shortname.html).

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

+++?code=scripts/example02.json&lang=json&title=<h4>Example 02</h4>[`scripts/example02.json`](https://github.com/ranghetti/sen2r_presentation/blob/master/scripts/example02.json)
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

+++?code=scripts/example03.R&lang=r&title=<h4>Example 03</h4>[`scripts/example03.R`](https://github.com/ranghetti/sen2r_presentation/blob/master/scripts/example03.R)
(equivalent to example 02)

+++?code=scripts/example03b.R&lang=r&title=[`scripts/example03b.R`](https://github.com/ranghetti/sen2r_presentation/blob/master/scripts/example03b.R)
You can also use a parameter file and change only some parameters
(useful to launch similar processing chains changing only e.g. the extent)

---

## Schedule a daily download

What is needed:
- a R script to run;
- [additional] a JSON parameter file;
- a cron job.
    
+++?code=scripts/example04.R&lang=r&title=<h4>Example 04</h4><h5>R script and JSON file</h5>[`scripts/example04.R`]((https://github.com/ranghetti/sen2r_presentation/blob/master/scripts/example04.R)
@[8](Search and download the last 5 days)
@[9](Save a log file to monitor the processing chain)

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
  20  0 * * * /usr/bin/Rscript /home/lranghetti/share/git/github/ranghetti/sen2r_presentation/scripts/example04.R
```
@[23,26](Now the job is scheduled to run every day at 0:20)

+++

On Windows, use the [Task Scheduler](https://docs.microsoft.com/en-us/windows/desktop/taskschd/task-scheduler-start-page)
![Task Scheduler screenshot](https://i.stack.imgur.com/Aqa57.png)

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

---?image=https://www.progettosaturno.it/wp-content/uploads/2018/01/263.jpg&size=cover&opacity=50

## An example from SATURNO project

[<img src="https://www.progettosaturno.it/wp-content/uploads/2018/01/cropped-progettosaturnodef.png" alt="SATURNO logo" width="50%"/>](https://www.progettosaturno.it/)

### Aim
Providing NRT images of a proxy of the vegetation status (NDRE index) over the Lomellina rice cultivation district (PV, Italy).

+++?image=https://www.progettosaturno.it/wp-content/uploads/2018/01/cropped-progettosaturnodef.png&&size=75% auto&position=center&opacity=50

### Steps

@ol
- Automatically produce Sentinel-2 images:<ul>
    <li>Download them when available (3 tiles in a single orbit);</li>
    <li>Merge the tiles;</li>
    <li>Clip on the Lomellina extent and mask the non arable land;</li>
    <li>Mask the cloud-covered surface (with a buffer over clouds);</li>
    <li>Compute NDRE index.</li></ul>
- Load images on a Geoserver;
- Expose them with a geoportal (Get-IT).
@olend

+++?image=https://www.progettosaturno.it/wp-content/uploads/2018/01/cropped-progettosaturnodef.png&&size=75% auto&position=center&opacity=50

---

## Work in progress!
- [[#80](https://github.com/ranghetti/sen2r/issues/80)] Add [THEIA images](http://www.theia-land.fr/en/products/sentinel-2-surface-reflectance) as possible sources (atmospheric correction with [MACCS-MAJA](http://www.cesbio.ups-tlse.fr/multitemp/?p=6203) processor);
- improve user experience (GUI interface, documentation, logging);
- several bug fixes (users can report them on [GitHub](https://github.com/ranghetti/sen2r/issues));
- publish a stable version on [CRAN](https://cran.r-project.org).

+++

### Test the package

You can be the beta-testers!

In case of errors, you are welcome to [open a new issue on GitHub](https://github.com/ranghetti/sen2r/issues)
*(anche in italiano)*.


