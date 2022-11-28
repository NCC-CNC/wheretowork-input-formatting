# Author: Dan Wismer 
# Date: Nov 25th, 2022
# Description: Copy .tiffs from Variable folder to Tiff folder 

root_folder <- NULL # <--- CHANGE PATH HERE

# Get list of files ----
ECCC_CH <- list.files(paste0(root_folder, "Variables/Themes/ECCC_CH"), 
                      pattern='.tif$', full.names = T, recursive = F)

ECCC_SAR <- list.files(paste0(root_folder, "Variables/Themes/ECCC_SAR"), 
                       pattern='.tif$', full.names = T, recursive = F)

IUCN_AMPH <- list.files(paste0(root_folder, "Variables/Themes/IUCN_AMPH"), 
                        pattern='.tif$', full.names = T, recursive = F)

IUCN_BIRD <- list.files(paste0(root_folder, "Variables/Themes/IUCN_BIRD"), 
                        pattern='.tif$', full.names = T, recursive = F)

IUCN_MAMM <- list.files(paste0(root_folder, "Variables/Themes/IUCN_MAMM"), 
                        pattern='.tif$', full.names = T, recursive = F)

IUCN_REPT <- list.files(paste0(root_folder, "Variables/Themes/IUCN_REPT"), 
                        pattern='.tif$', full.names = T, recursive = F)

NSC_END <- list.files(paste0(root_folder, "Variables/Themes/NSC_END"), 
                      pattern='.tif$', full.names = T, recursive = F)

NSC_SAR <- list.files(paste0(root_folder, "Variables/Themes/NSC_SAR"), 
                      pattern='.tif$', full.names = T, recursive = F)

NSC_SPP <- list.files(paste0(root_folder, "Variables/Themes/NSC_SPP"), 
                      pattern='.tif$', full.names = T, recursive = F)

LC <- list.files(paste0(root_folder, "Variables/Themes/LC"), 
                 pattern='.tif$', full.names = T, recursive = F)

W <- list.files(paste0(root_folder,"Variables/Weights"), 
                pattern='.tif$', full.names = T, recursive = F)

Incl <- list.files(paste0(root_folder, "Variables/Includes"), 
                   pattern='.tif$', full.names = T, recursive = F)

Excl <- list.files(paste0(root_folder, "Variables/Excludes"), 
                   pattern='.tif$', full.names = T, recursive = F)

# Change list here to include or exclude layers to copy
WtW <- list(ECCC_CH, ECCC_SAR, 
            IUCN_AMPH, IUCN_BIRD, IUCN_MAMM, IUCN_REPT, 
            NSC_END, NSC_SAR, NSC_SPP, 
            LC, 
            W, Incl, Excl)

# Copy files to Tiff folder ----
for (file in WtW) {
  name <- tools::file_path_sans_ext(basename(file))
  file.copy(file, paste0(root_folder, "Tiffs/", name, ".tif"))
}
