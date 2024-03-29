library(track2KBA)
library(sp)

dat <- read.csv("boobies_testdata.csv")
trips <- projectTracks(dat, projType = "azim", custom = TRUE)
KDE <- estSpaceUse(trips, scale = 50, levelUD = 50, res = 25)

expect_error(findSite("KDE"), pattern = "class")
expect_message(findSite(KDE, represent = 100, levelUD = 50), 
               pattern = "population size")

if (ignore(expect_silent)(
  findSite(KDE, represent = 100, levelUD = 50, popSize = 100)
)) {
  expect_silent(
    findSite(KDE, represent = 100, levelUD = 50, popSize = 100)
  )
} else {
  expect_warning(
    findSite(KDE, represent = 100, levelUD = 50, popSize = 100),
    pattern = "CRS object"
  )
}

expect_warning(findSite(as(KDE[[1]], "SpatialPixelsDataFrame"), 
                        represent = 100, levelUD = 50), 
               pattern = "LOW SAMPLE SIZE")

if (ignore(expect_silent)(
  findSite(KDE, represent = 80, levelUD = 50, popSize = 100)
)) {
  expect_silent(
    findSite(KDE, represent = 80, levelUD = 50, popSize = 100)
  )
} else {
  expect_warning(
    findSite(KDE, represent = 80, levelUD = 50, popSize = 100),
    pattern = "CRS object"
  )
}

if (ignore(expect_silent)(
  findSite(KDE, represent = 60, levelUD = 50, popSize = 100)
)) {
  expect_silent(
    findSite(KDE, represent = 60, levelUD = 50, popSize = 100)
  )
} else {
  expect_warning(
    findSite(KDE, represent = 60, levelUD = 50, popSize = 100),
    pattern = "CRS object"
  )
}

expect_message(findSite(KDE, represent = 25, levelUD = 50, popSize = 100),
               pattern = "UNREPRESENTATIVE SAMPLE")
expect_message(findSite(KDE, represent = 100, levelUD = 50, popSize = 100,
                        thresh = 5),
               pattern = "thresh")

if (ignore(expect_silent)(
  any(class(findSite(KDE, represent = 100, levelUD = 50, 
                     popSize = 100, polyOut = TRUE)) == "sf")
)) {
  expect_silent(any(class(findSite(KDE, represent = 100, levelUD = 50, 
                                      popSize = 100, polyOut = TRUE)) == "sf"))
} else {
  expect_warning(
    any(class(findSite(KDE, represent = 100, levelUD = 50, 
                       popSize = 100, polyOut = TRUE)) == "sf"),
    pattern = "CRS object"
  )
}
