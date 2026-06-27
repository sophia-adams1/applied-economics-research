# ==============================================================================
# Spatial Intersections & Choropleth Mapping via sf
# Data: Built-in County Boundaries + Simulated Regional Infrastructure Hubs
# ==============================================================================

library(sf)
library(ggplot2)

# Load the built-in polygon shapefile of North Carolina counties
counties <- st_read(system.file("shape/nc.shp", package="sf"), quiet = TRUE)

# Create a clean point dataset representing 3 major regional Economic Development Hubs
# Hand-coded in standard GPS coordinates (WGS84) to mimic raw field data
hub_data <- data.frame(
  lng = c(-80.8431, -78.6382, -82.5548),
  lat = c(35.2271, 35.7796, 35.5951),
  hub_name = c("Charlotte Core", "Raleigh Innovation Hub", "Asheville Tech Hub"),
  funding_millions = c(450, 600, 250)
)
head(hub_data)

# Spatial type as simple features (showing R where each hub is, on the shapefile)
# Convert the raw data frame into an official spatial sf point object
hubs <- st_as_sf(hub_data, coords = c("lng", "lat"), crs = 4326)

# Inspect the Coordinate Reference Systems
print(st_crs(counties)$epsg) # Uses 4267
print(st_crs(hubs)$epsg)     # Uses 4326 - Standard Global GPS

# Transform the points to match the exact projection matrix of the polygons
# This gets rid of geometric misalignment before performing the spatial join.
hubs_projected <- st_transform(hubs, crs = st_crs(counties))

# Join the county boundaries with the projected infrastructure hubs.
# st_intersects maps which specific county polygon encompasses the hub's location.
spatial_analysis <- st_join(counties, hubs_projected, join = st_intersects)

# Visualise the data on a chloropleth map.
ggplot(data = spatial_analysis) +
  geom_sf(aes(fill = funding_millions), color = "white", size = 0.2) +
  scale_fill_viridis_c(           # c for continuous numbers (gradient colours)
    option = "viridis",           # viridis is the yellow-purple colour scheme offering a lot of contrast
    na.value = "grey90",          # colour of the NA counties
    name = "Allocated Capital (£M)"
  ) +
  theme_void() +                  # No grid, no axes, no borders (just the map shape)
  
  labs(
    title = "Regional Distribution of Macro-Economic Infrastructure Grants",
    subtitle = "Point-in-polygon spatial intersection of targeted capital allocations across county sectors",
    caption = "Source: Open GIS Portfolio Lab | Base Projection: NAD27 / Local State Plane"
  )