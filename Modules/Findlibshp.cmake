# - Try to find LIBSHP
# Once done, this will define
#
#  LIBSHP_FOUND - system has LIBSHP
#  LIBSHP_INCLUDE_DIRS - the LIBSHP include directories
#  LIBSHP_LIBRARIES - link these to use LIBSHP

find_path(LIBSHP_INCLUDE_DIR
  NAMES shapefil.h
)

# Finally the library itself
find_library(LIBSHP_LIBRARY
  NAMES shp
)

set(LIBSHP_INCLUDE_DIRS ${LIBSHP_INCLUDE_DIR})
set(LIBSHP_LIBRARIES ${LIBSHP_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(libshp DEFAULT_MSG
  LIBSHP_LIBRARIES
  LIBSHP_INCLUDE_DIRS)
mark_as_advanced(LIBSHP_INCLUDE_DIR LIBSHP_LIBRARIES)
