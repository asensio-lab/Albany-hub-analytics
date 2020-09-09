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

povDF <- read_csv('pov.csv')
treatDF <- read_csv('treatMerge1.csv')
tr_albany <- st_read("Intersect_of_tracts_and_CityBoundary___CityBoundaries.shp")

# Convert csv to shapefile using coordinates
treatDF.sf <- treatDF %>% st_as_sf(coords = c("Longitude", "Latitude"), 
                         dim = "XY", 
                         crs = 4326)

# Join poverty data with Albany census tract shapefile 
povDF <- povDF %>% rename(GEOID = Tract_Boundaries_ID)
povDF$GEOID <- as.factor(povDF$GEOID)
pov_tr.sf <- inner_join(tr_albany,povDF,by='GEOID')

orange <- brewer.pal(5, "Oranges")

povMap <- tm_shape(pov_tr.sf) +
  tm_polygons(col = "Poverty_csv_Percent_below_pover",
              title = "Estimated Percent Population Below Poverty Level",
              border.col = "black",
              border.alpha = 0.3,
              palette = orange,
              n = 5,
              style = "jenks") 

tmap_mode('view') +
  povMap + tm_shape(treatDF.sf) + tm_dots(col="black",
                                               border.col = "gray",
                                               border.alpha = 0.1,
                                               size = 0.035)
