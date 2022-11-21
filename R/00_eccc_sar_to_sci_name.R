#
# Author: Dan Wismer 
#
# Date: September 30th, 2022
#
# Description: Renames ECCC SAR layers from COSEWICID to their scientific name. 
#              This is an optional script that batch renames ECCC SAR
#              layers extracted from the natdata-to-aoi.R script.
#
# Inputs:  1. A folder of ECCC SAR rasters that have the COSEWICID name 
#             (view "Variables/Themes/ECCC_SAR" for example)
#
#          2. A look-up csv (view "Variables/Themes/eccc_sar_names.csv"
#             for an example)
#
# Outputs: 1. Copied and renamed ECCC SAR layers
#

# 1.0 Load packages ------------------------------------------------------------

## Start timer
start_time <- Sys.time()

## Package names
packages <- c("tibble", "raster", "dplyr", "stringr", "readr")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

library(tibble)
library(raster)
library(dplyr)
library(stringr)
library(readr)

# 2.0 Set up -------------------------------------------------------------------

# Read-in ECCC SAR csv 
ECC_SAR_LU <- read_csv("Variables/Themes/ECCC_SAR/eccc_sar_names.csv")
# Get list of ECCC SAR .tiffs
raster_list <- list.files("Variables/Themes/ECCC_SAR", 
                          pattern='.tif$', 
                          full.names = T, 
                          recursive = F)


# 3.0 Copy and rename ----------------------------------------------------------

# For each file in raster list:
for (raster in raster_list) {
  
  ## get raster name ----
  name <- tools::file_path_sans_ext(basename(raster))
  ## get id
  cid <- str_split(name, "T_ECCC_SAR_COSEWICID_")[[1]][2]
  ## filter look-up table by COSEWICID
  rename <- ECC_SAR_LU %>% filter(COSEWICID == cid) 
  
  ## extract scientific name and format ----
  sci_name <- rename$SCI_NAME[1]
  sci_name <- gsub(".", "", sci_name, fixed = TRUE)
  sci_name <- gsub(" ", "_", sci_name, fixed = TRUE)
  sci_name <- gsub("-", "", sci_name )
  sci_name <- gsub("'", "", sci_name )
  sci_name <- gsub("/", "", sci_name )
  sci_name <- gsub("\\s*\\([^\\)]+\\)","",sci_name)
  print(paste0("ID: ", cid, "|", "Name: ",  sci_name))
  
  ## save a copy with formatted name into Tiffs folder ----
  file.copy(raster, paste0("Tiffs/T_ECCC_SAR_",sci_name,".tif"))
}

# 4.0 Clear R environment ------------------------------------------------------ 

## End timer
end_time <- Sys.time()
end_time - start_time
