## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%"
)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("track2KBA")

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("devtools", dependencies = TRUE)
#  devtools::install_github("BirdLifeInternational/track2kba", dependencies=TRUE) # development version - add argument 'build_vignettes = FALSE' to speed it up

## ----example, eval= FALSE, message=FALSE, warning = FALSE, include=T----------
#  library(track2KBA) # load package
#  
#  data(boobies)
#  # ?boobies  # for some background on the data set
#  
#  dataGroup <- formatFields(
#    dataGroup = boobies,
#    fieldID   = "track_id",
#    fieldDate = "date_gmt",
#    fieldTime = "time_gmt",
#    fieldLon  = "longitude",
#    fieldLat  = "latitude"
#    )
#  
#  str(dataGroup)
#  

## ----message=FALSE, eval= FALSE-----------------------------------------------
#  library(dplyr)
#  
#  # here we know that the first points in the data set are from the colony center
#  colony <- dataGroup %>%
#    summarise(
#      Longitude = first(Longitude),
#      Latitude  = first(Latitude)
#      )
#  

## ----tripSplit, eval= FALSE, warning = FALSE, message=FALSE, include=T, fig.height=7, fig.width=7----
#  
#  str(dataGroup)
#  
#  trips <- tripSplit(
#    dataGroup  = dataGroup,
#    colony     = colony,
#    innerBuff  = 3,      # kilometers
#    returnBuff = 10,
#    duration   = 1,      # hours
#    rmNonTrip  = TRUE
#    )
#  
#  mapTrips(trips = trips, colony = colony)
#  

## ----tripSplit graphic, echo=FALSE, out.height='80%', out.width='80%', fig.align="center"----
knitr::include_graphics("tripSplit-chunk-3-1.png", dpi=50) 

## ----tripSummary, eval= FALSE, message=FALSE, warning=FALSE-------------------
#  trips <- subset(trips, trips$Returns == "Yes" )
#  
#  sumTrips <- tripSummary(trips = trips, colony = colony)
#  
#  sumTrips

## ----projectTracks, eval= FALSE, warning = FALSE, message=F-------------------
#  tracks <- projectTracks( dataGroup = trips, projType = 'azim', custom=TRUE )
#  class(tracks)

## ----findScale, eval= FALSE, warning = FALSE, message=F-----------------------
#  hVals <- findScale(
#    tracks   = tracks,
#    scaleARS = TRUE,
#    sumTrips = sumTrips)
#  
#  hVals

## ----estSpaceUse, eval= FALSE, warning = FALSE, message = FALSE, include = TRUE, fig.width=5, fig.height=4, dpi=300----
#  tracks <- tracks[tracks$ColDist > 3, ] # remove trip start and end points near colony
#  
#  KDE <- estSpaceUse(
#    tracks = tracks,
#    scale = hVals$mag,
#    levelUD = 50,
#    polyOut = TRUE
#    )
#  
#  mapKDE(KDE = KDE$UDPolygons, colony = colony)
#  

## ----estSpaceUse graphic, echo=FALSE, out.height='80%', out.width='80%', fig.align="center"----
knitr::include_graphics("estSpaceUse-1.png", dpi=50)

## ----repAssess, eval= FALSE, fig.show='hide'----------------------------------
#  repr <- repAssess(
#    tracks    = tracks,
#    KDE       = KDE$KDE.Surface,
#    levelUD   = 50,
#    iteration = 1,
#    bootTable = FALSE)

## ----repAssess graphic, echo=FALSE, out.height='80%', out.width='80%', fig.align="center"----
knitr::include_graphics("repAssess-1.png", dpi=100)

## ----echo=F-------------------------------------------------------------------
repr <- data.frame(out = 98)

## ----findSite, eval= FALSE----------------------------------------------------
#  Site <- findSite(
#    KDE = KDE$KDE.Surface,
#    represent = repr$out,
#    levelUD = 50,
#    popSize = 500,     # 500 individual seabirds breed one the island
#    polyOut = TRUE
#    )
#  
#  class(Site)

## ----plot Site_sf, eval= FALSE------------------------------------------------
#  Sitemap <- mapSite(Site, colony = colony)
#  ## in case you want to save the plot
#  # ggplot2::ggsave("Sitemap", device="pdf")

## ----boobies graphic1, echo=FALSE, out.height='100%', out.width='100%', fig.width=5, fig.height=4, fig.align="center", dpi=300----
knitr::include_graphics("plot_KBA_sf.png", dpi=50)

## ----site2assess, eval= FALSE-------------------------------------------------
#  potSite <- Site %>% dplyr::filter(.data$potentialSite==TRUE) %>%
#     summarise(
#       max_animals = max(na.omit(N_animals)), # maximum number of animals aggregating in the site
#       min_animals = min(na.omit(N_animals))  # minimum number using the site
#     )
#  

## ----plot Site SPixDF, eval= FALSE--------------------------------------------
#  
#  mapSite(Site, colony = colony)
#  

## ----boobies graphic2, echo=FALSE, out.height='70%', out.width='70%', fig.width=5, fig.height=4, fig.align="center", dpi=300----
knitr::include_graphics("KBA_sp_plot.png", dpi=50)

