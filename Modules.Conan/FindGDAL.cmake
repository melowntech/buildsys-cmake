find_package(GDAL REQUIRED CONFIG)

if (TARGET GDAL::GDAL)
  set(GDAL_FOUND TRUE)
  set(GDAL_VERSION ${GDAL_VERSION})
  set(GDAL_LIBRARIES GDAL::GDAL)
  
  # Get first include dir from cmake generator expression
  get_target_property(GDAL_INCLUDE_DIR GDAL::GDAL INTERFACE_INCLUDE_DIRECTORIES)
  string(REGEX REPLACE "\\$<\\$<CONFIG:[^>]*>:" "" GDAL_INCLUDE_DIR "${GDAL_INCLUDE_DIR}")
  string(REGEX REPLACE ">.*" "" GDAL_INCLUDE_DIR "${GDAL_INCLUDE_DIR}")
endif()