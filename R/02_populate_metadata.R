#
# Author: Dan Wismer 
#
# Date: Nov 16th, 2022
#
# Description: Assists in generating a metadata.csv required for 
#              04_format_data.R.  
#
# Inputs:  1. A folder of rasters 
#          2. Required R libraries
#
# Outputs: 1. A partially built metadata.csv to QC and manually edit in excel
#
#
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

## File path variables ----
input_tiff_folder <- "Tiffs" # <--- CHANGE PATH FOR NEW PROJECT
input_aoi_name <- "AOI.tif" # <--- CHANGE NAME FOR NEW PROJECT (aoi needs to be in Tiffs folder)
output_metadata_folder <- "WtW/metadata" # <--- CHANGE PATH FOR NEW PROJECT
output_metadata_name <- "sw-on" # <--- CHANGE NAME FOR NEW PROJECT

## Read-in tiff file paths
file_list <- list.files(input_tiff_folder, pattern='.tif$', 
                        full.names = T, recursive = T) 

## Remove AOI from file list
aoi_path <- file.path(input_tiff_folder, input_aoi_name) 
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
                 Goal = character(),
                 Targets = character())

# 3.0 Populate metadata --------------------------------------------------------

## Set up counter
counter <- 1
len <- length(file_list)

## Loop over each tiff file:
for (file in file_list) {
  
  ### read-in as raster
  wtw_raster <- raster(file)
  
  ## File ----
  ### assign file name with extension of layer (ex. I_Protected.tif)
  file_no_ext <- paste0(tools::file_path_sans_ext(basename(file)))
  file <-  paste0(file_no_ext,".tif")
  #### message
  print(paste0("Populating ", counter, " of ", len, ": ", file))
  
  ## Type ----
  if (startsWith(file_no_ext, "AOI")) {
    type <- "-"
  } else if (startsWith(file_no_ext, "T_")) {
    type <- "theme"
  } else if (startsWith(file_no_ext, "W_")) {
    type <- "weight"
  } else if (startsWith(file_no_ext, "I_")) {
    type <- "include"
  } else if (startsWith(file_no_ext, "E_")) {
    type <- "exclude"
  } 
  
  ## Name ----
  if (startsWith(file_no_ext, "T_ECCC_SAR_")) {
    name_ <- unlist(str_split(file_no_ext, "T_ECCC_SAR_"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "T_ECCC_CH")) {
    name_ <- unlist(str_split(file_no_ext, "T_ECCC_CH"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "T_IUCN_AMPH")) {
    name_ <- unlist(str_split(file_no_ext, "T_IUCN_AMPH"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space 
    
  } else if (startsWith(file_no_ext, "T_IUCN_BIRD")) {
    name_ <- unlist(str_split(file_no_ext, "T_IUCN_BIRD"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space 
    
  } else if (startsWith(file_no_ext, "T_IUCN_MAMM")) {
    name_ <- unlist(str_split(file_no_ext, "T_IUCN_MAMM"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "T_IUCN_REPT")) {
    name_ <- unlist(str_split(file_no_ext, "T_IUCN_REPT"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space 
    
  } else if (startsWith(file_no_ext, "T_NSC_END")) {
    name_ <- unlist(str_split(file_no_ext, "T_NSC_END"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space  
    
  } else if (startsWith(file_no_ext, "T_NSC_SAR")) {
    name_ <- unlist(str_split(file_no_ext, "T_NSC_SAR"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "T_NSC_SPP")) {
    name_ <- unlist(str_split(file_no_ext, "T_NSC_SPP"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space       
    
  } else if (startsWith(file_no_ext, "T_LC_")) {
    name_ <- unlist(str_split(file_no_ext, "T_LC_"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "W_")) {
    name_ <- unlist(str_split(file_no_ext, "W_"))[2] # split string
    name <- str_replace_all(name_, "_", " ") # replace underscore with space
    
  } else if (startsWith(file_no_ext, "I_Protected")) {
    name <- "Existing Conservation (CPCAD)"    
    
  } else {
    name <- ""
  }
  
  ## Theme ----
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    theme <- "Species at Risk (ECCC)"
    
  } else if (startsWith(file_no_ext, "T_ECCC_CH")) {
    theme <- "Critical Habitat (ECCC)"      
    
  } else if (startsWith(file_no_ext, "T_IUCN_AMPH")) {
    theme <- "Amphibians (IUCN)"
    
  } else if (startsWith(file_no_ext, "T_IUCN_BIRD")) {
    theme <- "Birds (IUCN)" 
    
  } else if (startsWith(file_no_ext, "T_IUCN_MAMM")) {
    theme <- "Mammals (IUCN)"
    
  } else if (startsWith(file_no_ext, "T_IUCN_REPT")) {
    theme <- "Reptiles (IUCN)"
    
  } else if (startsWith(file_no_ext, "T_NSC_SAR")) {
    theme <- "Species at Risk (NSC)"
    
  } else if (startsWith(file_no_ext, "T_NSC_END")) {
    theme <- "Endemic Species (NSC)"
    
  } else if (startsWith(file_no_ext, "T_NSC_END")) {
    theme <- "Endemic Species (NSC)"         
    
  } else if (startsWith(file_no_ext, "T_NSC_SPP")) {
    theme <- "Common Species"
    
  } else if (startsWith(file_no_ext, "T_LC")) {
    theme <- "Land Cover"    
    
  } else {
    theme <- ""
  }
  
  ## Legend ----
  if (any(startsWith(file_no_ext, c("T_ECCC", "T_IUCN", "T_NSC", "I_")))) {
    legend <- "manual"
    
  } else if (any(startsWith(file_no_ext, c("T_LC", "W_")))) {
    legend <- "continuous"
    
  } else if (startsWith(file_no_ext, "W_Key"))  {
    legend <- "manual"    
    
  } else {
    legend <- ""
  }
  
  ## Values ----
  if (any(startsWith(file_no_ext, c("T_ECCC", "T_IUCN", "T_NSC")))) {
    
    if (raster::minValue(wtw_raster) == 0) {
      values <- "0, 1"
    } else {
      values <- "1" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "I")) {
    values <- "0, 1"  
    
  } else if (startsWith(file_no_ext, "W_Key")) {
    values <- "0, 1"     
    
  } else {
    values <- ""
  }
  
  ## Color ----
  if (startsWith(file_no_ext, "T_ECCC_SAR")) {
    if (startsWith(values, "0")) {
      color <- "#00000000, #fb9a99"
    } else {
      color <- "#fb9a99" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_ECCC_CH")) {
    if (startsWith(values, "0")) {
      color <- "#00000000, #ffed6f"
    } else {
      color <- "#ffed6f" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_IUCN_AMPH")) {
    if (startsWith(values, "0")) {
      color <- "#00000000, #a6cee3"
    } else {
      color <- "#a6cee3" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_IUCN_BIRD")) {
    if (startsWith(values, "0")) {    
      color <- "#00000000, #ff7f00"
    } else {
      color <- "#ff7f00" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_IUCN_MAMM")) {
    if (startsWith(values, "0")) {     
      color <- "#00000000, #b15928"
    } else {
      color <- "#b15928" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_IUCN_REPT")) {
    if (startsWith(values, "0")) { 
      color <- "#00000000, #b2df8a"
    } else {
      color <- "#b2df8a" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_NSC_SAR")) {
    if (startsWith(values, "0")) {     
      color <- "#00000000, #d73027"
    } else {
      color <- "#d73027" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_NSC_END")) {
    if (startsWith(values, "0")) { 
      color <- "#00000000, #4575b4"
    } else {
      color <- "#4575b4" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_NSC_SPP")) {
    if (startsWith(values, "0")) { 
      color <- "#00000000, #e6f598"
    } else {
      color <- "#e6f598" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "T_LC")) {
    color <- "viridis"     
    
  } else if (startsWith(file_no_ext, "I")) {
    color <- "#00000000, #7fbc41"
    
  } else if (startsWith(file_no_ext, "W_Carbon")) {
    color <- "YlOrBr"    
    
  } else if (startsWith(file_no_ext, "W_Climate")) {
    color <- "PuBuGn"
    
  } else if (startsWith(file_no_ext, "W_Human")) {
    color <- "rocket"
    
  } else if (startsWith(file_no_ext, "W_Freshwater")) {
    color <- "Blues"
    
  } else if (startsWith(file_no_ext, "W_Recreation")) {
    color <- "Greens"
    
  } else if (startsWith(file_no_ext, "W_Key")) {
    color <- "#00000000, #7fbc41"     
    
  } else {
    color <- ""
  }  
  
  ## Label ----
  
  if (any(startsWith(file_no_ext, c("T_ECCC", "T_IUCN", "T_NSC")))) {
    
    if (startsWith(values, "0")) {
      labels <- "absence, presence"
    } else {
      labels <- "presence" # layer covers entire AOI
    }
    
  } else if (startsWith(file_no_ext, "I_")) {
    labels <- "not included, included"
    
  } else if (startsWith(file_no_ext, "W_Key")) {
    labels <- "not KBA, KBA"    
    
  } else {
    labels <- ""
  }   
  
  ## Units ----
  if (any(startsWith(file_no_ext, c("T_ECCC", 
                                    "T_IUCN", 
                                    "T_NSC",  
                                    "I_",
                                    "W_Key")))) {
    unit <- "km2"
    
  } else if (file_no_ext %in% c("T_LC_Forest", 
                                "T_LC_Wetlands",
                                "T_LC_Lakes", 
                                "T_LC_Grassland")) {
    unit <- "ha"
    
  } else if (file_no_ext %in% c("T_LC_River_length", 
                                "T_LC_Shoreline_length")) {
    unit <- "km"       
    
  } else if (startsWith(file_no_ext, "W_Carbon_potential")) {
    unit <- "tonnes/yr"   
    
  } else if (startsWith(file_no_ext, "W_Carbon_storage")) {
    unit <- "tonnes"
    
  } else if (file_no_ext %in% c("W_Climate_forward_velocity", 
                                "W_Climate_refugia", 
                                "W_Human_footprint")) {
    unit <- "index" 
    
  } else if (any(startsWith(file_no_ext, c("W_Freshwater", 
                                           "W_Recreation")))) {
    unit <- "ha"      
    
  } else {
    unit <- ""
  }  
  
  ## Provenance ----
  provenance <- "national"
  
  ## Order ----
  order <- "" # manual assignment in csv
  
  ## Visible ----
  visible <- "" # manual assignment in csv
  
  ## Hidden ----
  hidden <- "" # manual assignment in csv
  
  ## Goal ----
  goal <- "0.2"  # default
  
  ## Target ----
  ## calculate a target based on the proportion of a binary theme within AOI
  ## can be used as goal
  if (type == "theme") {
    
    if (raster::maxValue(wtw_raster) == 1) {
      x <- cellStats(wtw_raster, sum) # Get the cell sum
      target <- calculate_targets(x)
      
    } else {
      target <- ""
    }
    
  } else {
    target <- ""
  }
  
  ## Append row to data.frame ----
  new_row <- c(type, theme, file, name, legend, values, color, labels, unit, 
               provenance, order, visible, hidden, goal, target)
  
  df <- structure(rbind(df, new_row), .Names = names(df))
  
  ## Update counter
  counter <- 1 + counter
  
} 


# Write to CSV ----
write.csv(df, 
          file.path(output_metadata_folder, 
                    paste0(output_metadata_name, "-metadata-NEEDS-QC.csv")),
          row.names = FALSE)

# 4.0 Clear R environment ------------------------------------------------------ 

## End timer
end_time <- Sys.time()
end_time - start_time


