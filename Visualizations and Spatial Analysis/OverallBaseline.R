if (!require("sf")) install.packages("sf") 
if (!require("tmap")) install.packages("tmap") 
if (!require("tidyverse")) install.packages("tidyverse") 
if (!require("tigris")) install.packages("tigris") 
if (!require("rappdirs"))install.packages("rappdirs")
if (!require("shinyjs"))install.packages("shinyjs")
if (!require("RColorBrewer"))install.packages("RColorBrewer")

library(sf)
library(tmap)
library(tidyverse)
library(tigris)
library(rappdirs)
library(shinyjs)
library(RColorBrewer)


# ENV
setwd("/Users/Kira/Documents/ESRI_Research_Project")

df <- read_csv('OverallStats2.csv')
treatDF <- read_csv('treatMerge1.csv')
bg_albany <- st_read("bg_albany.shp")

# CSV TO SF
df.sf <- df %>% st_as_sf(coords = c("Longitude", "Latitude"), 
                         dim = "XY", 
                         crs = 4326)

treatDF.sf  <- treatDF %>% st_as_sf(coords = c("Longitude", "Latitude"), 
                                    dim = "XY", 
                                    crs = 4326)

# MAP
tmap_options(max.categories = 48)
tmap_mode("view") +
  tm_shape(df.sf %>% mutate(FIPS_Code = as.factor(FIPS_Code))) +
  tm_dots(col = "FIPS_Code")

df.in.bk <- bg_albany %>%
  st_join(df.sf) 

df.in.bk %>%
  group_by() %>%
  summarise(unique.n = length(unique(GEOID))) %>%
  summary()
# checking whether, after the join, there are more than one census tract
# for each 'Tract' variable

df.in.bk.sumr <- df.in.bk %>%
  group_by(FIPS_Code) %>%
  summarise_if(is.numeric, mean, na.rm = TRUE)

orange <- brewer.pal(4, "Oranges")

baselineMap <- tm_shape(df.in.bk.sumr) +
  tm_polygons(col = "Baseline",
              title = "Baseline Energy Consumption (kWh/ft^2)",
              border.col = "black",
              border.alpha = 0.3,
              palette = orange,
              n = 4,
              style = "jenks") 

tmap_mode('view') +
  baselineMap + tm_shape(treatDF.sf) + tm_dots(col="black",
                                               border.col = "gray",
                                               border.alpha = 0.1,
                                               size = 0.025)

tmap_save(baselineMap, "baselineMap.svg")


# SAVE IT
st_write(df.in.tr.sumr, "Kira1.shp")

