#
# Author: Dan Wismer 
#
# Date: November 21st, 2022
#
# Description: Renames IUCN layers and copies national layers from Variables
#              folder to Tiffs folder
#
# 1.0 Load packages ------------------------------------------------------------

## Start timer
start_time <- Sys.time()

## Package names
packages <- c("raster", "stringr")

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

# IUCN ----
AMPH <- list.files("Variables/Themes/IUCN_AMPH", pattern='.tif$', 
                   full.names = T, recursive = F)

BIRD <- list.files("Variables/Themes/IUCN_BIRD", pattern='.tif$', 
                   full.names = T, recursive = F)

MAMM <- list.files("Variables/Themes/IUCN_MAMM", pattern='.tif$', 
                   full.names = T, recursive = F)

REPT <- list.files("Variables/Themes/IUCN_REPT", pattern='.tif$', 
                   full.names = T, recursive = F)

IUCN <- do.call(c, list(AMPH, BIRD, MAMM, REPT))

for (raster in IUCN) {
  ## get raster name ----
  name_aoh <- tools::file_path_sans_ext(basename(raster))
  ## remove _aoh from name
  name <- str_replace_all(name_aoh, "_aoh", "")
  ## remove _#
  if (suppressWarnings(!is.na(as.numeric(str_sub(name, -1, -1))))) {
    name <-  str_sub(name, 1, -3)
  }
  ## save a copy with formatted name into Tiffs folder ----
  file.copy(raster, paste0("Tiffs/", name, ".tif"))
}

# NSC END ----
NSC_END <- list.files("Variables/Themes/NSC_END", pattern='.tif$', 
                      full.names = T, recursive = F)

# NSC SAR ----
NSC_SAR <- list.files("Variables/Themes/NSC_SAR", pattern='.tif$', 
                      full.names = T, recursive = F)

# NSC SAR ----
NSC_SPP <- list.files("Variables/Themes/NSC_SPP", pattern='.tif$', 
                      full.names = T, recursive = F)

# Landcover ----
LC <- list.files("Variables/Themes/LC", pattern='.tif$', 
                   full.names = T, recursive = F)
# Weights
W <- list.files("Variables/Weights", pattern='.tif$', 
                full.names = T, recursive = F)
# Includes
Incl <- list.files("Variables/Includes", pattern='.tif$', 
                   full.names = T, recursive = F)
# Excludes
Excl <- list.files("Variables/Excludes", pattern='.tif$', 
                   full.names = T, recursive = F)


# Copy other layers to Tiffs folder
WtW <- list(NSC_END, NSC_SAR, NSC_SPP, LC, W, Incl, Excl)

for (raster in WtW) {
  ## get raster name ----
  name <- tools::file_path_sans_ext(basename(raster))
  ## save a copy into Tiffs folder ----
  file.copy(raster, paste0("Tiffs/", name, ".tif"))
}

