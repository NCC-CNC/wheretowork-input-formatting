# Where To Work Input Formatting

## Introduction
### This repo assists in formating your raster data into the 4 mandatory files (described below) required for import into **Where To Work** when using the *upload project data* method.

1. **configuration.yaml:** <br>
The configuration file defines project attributes, legend elements / map display in the left side bar 'Table of contents' and initial goals in the 'New solution' right side bar.
 
2. **spatial.tif:** <br>
The spatial tiff file defines the spatial properties of the planning units, 
such as cell size, extent, number of rows, number of columns and coordinate reference system. It acts as the template to build rasters from columns within the attribute.csv.gz.

3. **attribute.csv.gz:** <br>
The attribute file defines the cell values of each theme, weight, include and exclude in tabular form. Each column in the .csv is a variable. 

4. **boundary.csv.gz:** <br>
The boundary file defines the adjacency table of each theme, weight, include and exclude. It stores information on the perimeter and shared boundary lengths of the planning units. This is needed to run optimizations for spatial clustering.

## Prerequisites
- Raster layers (.tiffs) that represent themes, weights, includes, excludes and AOI must be organized into one folder

- All rasters must have the same spatial properties (cell size, coordinate reference system, extent, etc.)

- Raster file names should follow some type of naming convention 

## Getting Started
#### Before you can run `03_format_data_wtw.R` you must create a new 'metadata.csv` that defines the following properties for each raster layer in the project. You can view a QC'd version [here.](https://github.com/NCC-CNC/wheretowork-input-formatting/blob/main/WTW/metadata/sw-on-metadata-NEEDS-QC.csv)

- **Type** <br>
Available choices: theme, weight, include or exclude.

- **Theme** <br>
If Type is theme, provide a name for the grouping. <br>
Example: Species at Risk (ECCC)

- **File** <br>
Provide the file name with extension of the layer. <br>
Example: T_ECCC_SAR_Agalinis_gattingeri.tif

- **Name** <br>
Provide a name for the layer. <br>
Example: Existing conservation

- **Legend** <br>
Provide a legend type based off the data type (manual legend == categorical data). <br>
Available choices: manual, continuous or null

- **Values** <br>
If legend is manual, provide the categorical values. <br>
Example: 0, 1

- **Color** <br>
If legend is **manual**, provide the hex colors. This must be the same length as values. <br>
Example: #00000000, #b3de69 <br>
If legend is **continuous**, provide a colors ramp from [wheretowork::color_palette()](https://ncc-cnc.github.io/wheretowork/reference/color_palette.html) <br>
Example: magma

- **Labels** <br>
If legend is manual, provide the labels for each value. This must be the same length as values. <br>
Example: absence, presence

- **Unit** <br>
Provide a unit for the layer <br>
Example: km2

- **Provenance** <br>
Define if the layer is regional or national data. <br>
Available choices: regional, national or missing

- **Order** <br>
Optional; define the order of the layers when `wheretowork`is initialized. <br>

- **Visible** <br>
Define if the layer will be visible when `wheretowork`is initialized. <br>
Available choices: TRUE or FALSE

- **Hidden** <br>
Define if the layer will be hidden from `wheretowork` (recommended for large projects). <br>
Available choices: TRUE or FALSE

- **Goal** <br>
If Type is theme, provide a goal for the layer when `wheretowork` is initialized. <br>
Available choices: a number between 0 and 1

#### The `02_populate_metadata.R` script assists in creating the metadata.csv. However, manual editing and QC is still needed.

## Format Data
#### Change path names in `03_format_data_wtw.R` to reflect the input/output locations of your data. This script outputs the 4 mandatory files required for import into **Where To Work**.

## Help
#### Reach out to Dan Wismer (daniel.wismer@natureconservancy.ca) for help using these scripts or to report a bug.

