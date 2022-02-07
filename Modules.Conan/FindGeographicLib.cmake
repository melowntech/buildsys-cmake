find_package(geographiclib REQUIRED CONFIG)

if (TARGET GeographicLib::GeographicLib)
  set(GeographicLib_FOUND TRUE)
  set(GeographicLib_LIBRARIES GeographicLib::GeographicLib)
endif()