# - Try to find geographiclib
# Once done, this will define
#
#  GEOGRAPHICLIB_FOUND - system has GEOGRAPHICLIB
#  GEOGRAPHICLIB_INCLUDE_DIRS - the GEOGRAPHICLIB include directories
#  GEOGRAPHICLIB_LIBRARIES - link these to use GEOGRAPHICLIB

find_path(GEOGRAPHICLIB_INCLUDE_DIR
  NAMES GeographicLib/TransverseMercator.hpp
)

# Finally the library itself
find_library(GEOGRAPHICLIB_LIBRARY
  NAMES Geographic
)

set(GEOGRAPHICLIB_INCLUDE_DIRS ${GEOGRAPHICLIB_INCLUDE_DIR})
set(GEOGRAPHICLIB_LIBRARIES ${GEOGRAPHICLIB_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GeographicLib DEFAULT_MSG
  GEOGRAPHICLIB_LIBRARIES
  GEOGRAPHICLIB_INCLUDE_DIRS)
mark_as_advanced(GEOGRAPHICLIB_INCLUDE_DIR GEOGRAPHICLIB_LIBRARIES)
