if (!require("sf")) install.packages("sf") 
if (!require("tmap")) install.packages("tmap") 
if (!require("tidyverse")) install.packages("tidyverse") 
if (!require("tigris")) install.packages("tigris") 
if (!require("rappdirs"))install.packages("rappdirs")

library(sf)
library(tmap)
library(tidyverse)
library(tigris)
library(rappdirs)

# ENV
setwd("/Users/Kira/Documents/ESRI_Research_Project")

df <- read_csv('treatMerge1.csv')
bg_albany <- st_read("bg_albany.shp")

# CSV TO SF
df.sf <- df %>% st_as_sf(coords = c("Longitude", "Latitude"), 
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

mymap <- tm_shape(df.in.bk.sumr) +
  tm_polygons(col = "Yearly_Monetary_Savings",
              title = "Yearly Monetary Savings ($)",
              style = "jenks",
              palette = "Oranges")

tmap_mode('view') +
  mymap 

# SAVE IT
st_write(df.in.tr.sumr, "Kira1.shp")

