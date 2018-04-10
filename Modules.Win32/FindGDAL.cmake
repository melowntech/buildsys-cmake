# we look for gdal in Program Files/gdal
find_path(GDAL_INCLUDE_DIR gdal.h
  PATHS "$ENV{PROGRAMFILES}/gdal"
  PATH_SUFFIXES include)

find_library(GDAL_LIBRARY NAMES gdal gdal_i
  PATHS "$ENV{PROGRAMFILES}/gdal"
  PATH_SUFFIXES lib)

if(GDAL_LIBRARY)
  set(GDAL_LIBRARIES "${GDAL_LIBRARY}")
endif()

find_package_handle_standard_args(GDAL DEFAULT_MSG
  GDAL_LIBRARIES GDAL_INCLUDE_DIR)
mark_as_advanced(GDAL_LIBRARIES GDAL_INCLUDE_DIR)
