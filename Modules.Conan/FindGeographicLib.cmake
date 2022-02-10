# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(geographicliB REQUIRED CONFIG)

if (TARGET GeographicLib::GeographicLib)
  set(GeographicLib_FOUND TRUE)
  set(GeographicLib_VERSION ${geographicliB_VERSION})
  set(GeographicLib_LIBRARIES GeographicLib::GeographicLib)
endif()