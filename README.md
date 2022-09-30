# Where To Work Input Formatting

## Introduction
### This repo assists in formating your raster data into the 4 mandatory files (described below) required for import into **Where To Work** when using the *upload project data* method.

1. **configuration.yaml:** <br>
The configuration file defines user access, UI elements in the 'Table of contents' 
and initial values in the 'New solution' side bars.
 
2. **spatial.tif:** <br>
The spatial tiff file defines the spatial properties of the area of interest, 
such as cell size, extent, number of rows, number of columns and coordinate reference system.

3. **attribute.csv.gz:** <br>
The attribute file defines the cell values of each theme, weight and include in tabular form


4. **boundary.csv.gz:** <br>
The boundary file defines the adjacency table of each theme, weight and include

## Prerequisites
- Raster layers that represent themes, weights, includes and AOI must be organized into one folder

- All rasters must have the same spatial properties (cell size, coordinate reference system, extent, etc.)

- Raster file names should follow some type of naming convention 


## Getting Started
#### Before you can run `02_format_data.R` you must create a new 'metadata.csv` that defines the following properties for each raster layer in the project. You can view a QC'd version [here.](https://github.com/NCC-CNC/wheretowork-input-formatting/blob/main/W2W/metadata/sw-on-metadata.csv)

- **Type** <br>
Available choices: theme, weight or include.

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
If legend is manual, provide the hex colors. This must be the same length as values. <br>
Example: #00000000, #b3de69 <br>
If legend is continuous, provide a colors ramp from [wheretowork::color_palette()](https://ncc-cnc.github.io/wheretowork/reference/color_palette.html) <br>
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

#### The `01_populate_metadata.R` script assists in creating the metadata.csv. However, manual editing and QC is still needed.

## Format Data
#### Change path names in `02_format_data.R` to point to your "Tiffs" folder and "metadata.csv". This script outputs the 4 mandatory files required for import into **Where To Work**.

## Help
#### Reach out to Dan Wismer (daniel.wismer@natureconservancy.ca) for help using these scripts or to report a bug.

