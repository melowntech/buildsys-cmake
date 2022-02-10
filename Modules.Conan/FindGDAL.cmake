# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(gdaL REQUIRED CONFIG)

if (TARGET GDAL::GDAL)
  set(GDAL_FOUND TRUE)
  set(GDAL_VERSION ${gdaL_VERSION})
  set(GDAL_LIBRARIES GDAL::GDAL)
  
  # Get first include dir from cmake generator expression
  get_target_property(GDAL_INCLUDE_DIR GDAL::GDAL INTERFACE_INCLUDE_DIRECTORIES)
  string(REGEX REPLACE "\\$<\\$<CONFIG:[^>]*>:" "" GDAL_INCLUDE_DIR "${GDAL_INCLUDE_DIR}")
  string(REGEX REPLACE ">.*" "" GDAL_INCLUDE_DIR "${GDAL_INCLUDE_DIR}")
endif()