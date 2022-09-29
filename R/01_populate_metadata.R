

# 1.0 Load packages ------------------------------------------------------------

## Start timer
start_time <- Sys.time()

## Package names
packages <- c("tibble", "raster", "dplyr", "stringr")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

library(tibble)
library(raster)
library(dplyr)
library(stringr)
source("R/fct_calculate_targets.R")

# 2.0 Set up -------------------------------------------------------------------

## Read-in tiff file paths
file_list <- list.files("Tiffs", # <--- CHANGE PATH HERE FOR NEW PROJECT
                        pattern='.tif$', full.names = T, recursive = T) 

## Remove AOI from file list
aoi_path <- "Tiffs/AOI.tif" # <--- CHANGE PATH HERE FOR NEW PROJECT
file_list <- file_list[file_list != aoi_path]

## Build empty data.frame (template for metadata.csv)
df <- data.frame(Type = character(),
                 Theme = character(),
                 File = character(),
                 Name = character(),
                 Legend = character(),
                 Values = character(),
                 Color = character(),
                 Labels = character(),
                 Unit = character(),
                 Provenance = character(),
                 Order = character(),
                 Visible = character(),
                 Hidden = character(),
                 Goal = character())


# 3.0 Populate metadata --------------------------------------------------------

counter <- 1
len <- length(file_list)

## Loop over each tiff file:
for (file in file_list) {

  ## File ----
  ### Assign file name with extension of layer (ex. I_Protected.tif)
  file_no_ext <- paste0(tools::file_path_sans_ext(basename(file)))
  file <-  paste0(file_no_ext,".tif")
  #### message
  print(paste0("Populating ", counter, " of ", len, ": ", file))
  
  # Type ----
  ### Assign layer as either theme, weight, or include
  ### Example:
  
  if (startsWith(file_no_ext, "AOI")) {
    type <- "-"
  } else if (startsWith(file_no_ext, "T_")) {
    type <- "theme"
  } else if (startsWith(file_no_ext, "W_")) {
    type <- "weight"
  } else if (startsWith(file_no_ext, "I_")) {
    type <- "include"
  }
  
  ## Name ----
  ### Assigning a name to be used in the w2w legend is best left for the user
  ### to manually populate the NAME column in the output csv. Or write custom
  ### code below to populate each layer with a name
  ### Example:
  
  if (startsWith(file_no_ext, "T_ECCC_SAR_")) {
    name_ <- unlist(str_split(file_no_ext, "T_ECCC_SAR_"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "T_LC_")) {
    name_ <- unlist(str_split(file_no_ext, "T_LC_"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "W_")) {
    name_ <- unlist(str_split(file_no_ext, "W_"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else {
    name <- ""
  }

  # Theme ----
  ### Assigning a theme name to be used in the w2w legend is best left for the user
  ### to manually populate the THEME column in the output csv. Or write custom
  ### code below to populate each layer with a THEME name
  ### EXAMPLE:
  
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    theme <- "Species at Risk (ECCC)"
    
  } else if (startsWith(file_no_ext, "T_LC")) {
    theme <- "Land Cover"
    
  } else {
    theme <- ""
  }
  
  # Legend ----
  ### Assigning a legend to be used in the w2w legend is best left for the user
  ### to manually populate the LEGEND column in the output csv. Or write custom
  ### code below to populate each layer with a LEGEND type: continuous, manual, null 
  ### Example:
  
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    legend <- "manual"
    
  } else if (startsWith(file_no_ext, "T_LC")) {
    legend <- "continuous"
    
  } else if (startsWith(file_no_ext, "I_"))  {
    legend <- "manual"
    
  } else {
    legend <- ""
  }

  # Values ----
  ### Assigning values to be used fro the w2w legend is best left for the user
  ### to manually populate the values column in the output csv. Or write custom
  ### code below to populate each layer with VALUES if legend is manual.
  ### Example:
  
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    values <- "0, 1"
    
  } else if (startsWith(file_no_ext, "I")) {
    values <- "0, 1"
    
  } else {
    values <- ""
  }
  
  # Color ----
  ### Assigning colors to be used for the w2w legend is best left for the user
  ### to manually populate the colors column in the output csv. Or write custom
  ### code below to populate each layer with COLOR.
  ### Example:
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    color <- "#00000000, #fb8072"
    
  } else if (startsWith(file_no_ext, "I")) {
    color <- "#00000000, #b3de69"
    
  } else {
    color <- ""
  }  
  
  # LABEL ----
  ### Assigning labels to be used for the w2w manual legend is best left for the user
  ### to manually populate the labels column in the output csv. Or write custom
  ### code below to populate each layer with a LABEL if legend is manual.   
  ### Example:
  
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    labels <- "absence, presence"
    
  } else if (startsWith(file_no_ext, "I")) {
    labels <- "not included, included"
    
  } else {
    labels <- ""
  }   
  
  # Units ----
  ### Assigning units to be used for the w2w legend is best left for the user
  ### to manually populate the unit column in the output csv. Or write custom
  ### code below to populate each layer with a UNIT.
  ### Example:
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    unit <- "km2"
    
  } else if (startsWith(file_no_ext, "I")) {
    unit <- "km2"
    
  } else {
    unit <- ""
  }  
  
  # Provenance ----
  ### Assigning provenance to be used for the w2w legend is best left for the user
  ### to manually populate the provenance column in the output csv. Or write custom
  ### code below to populate each layer with a PROVENANCE.
  ### Example
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    provenance <- "national"
    
  } else if (startsWith(file_no_ext, "W_Mean_NDVI")) {
    provenance <- "regional"
    
  } else {
    provenance <- ""
  } 
  
  # Order ----
  ### Assigning order to be used for the w2w legend is best left for the user
  ### to manually populate the order column in the output csv. Or write custom
  ### code below to populate each layer with a ORDER value.    
  order <- ""
  
  # Visible ----
  ### Assigning visible to be used for the w2w legend is best left for the user
  ### to manually populate the visible column in the output csv. Or write custom
  ### code below to populate each layer with a VISIBLE value.     
  visible <- ""

  # Hidden ----
  ### Assigning hidden to be used for the w2w legend is best left for the user
  ### to manually populate the hidden column in the output csv. Or write custom
  ### code below to populate each layer with a HIDDEN value.     
  hidden <- ""
  
  # Goal ----
  ### if layer is a binary theme then set a goal based on the proportion
  if (type == "theme") {
    r <- raster(paste0("Tiffs/", file)) # read-in layer as a raster
    
    if (raster::maxValue(r) == 1) {
      x <- cellStats(r, sum) # Get the cell sum
      goal <- calculate_targets(x)
      
    } else {
      goal <- ""
    }
    
  } else {
    goal <- ""
  }
  
  # Append row to data.frame ----
  new_row <- c(type, theme, file, name, legend, values, color, labels, unit, 
               provenance, order, visible, hidden, goal)
  
  df <- structure(rbind(df, new_row), .Names = names(df))
  
  # Update counter
  counter <- 1 + counter
  
} 


# Write to CSV ----
write.csv(df, 
          "W2W/metadata/sw-on-metadata-NEEDS-QC.csv",  # <--- CHANGE NAME FOR NEW PROJECT
          row.names = FALSE)

# 4.0 Clear R environment ------------------------------------------------------ 

## End timer
end_time <- Sys.time()
end_time - start_time

rm(list=ls())
gc()

