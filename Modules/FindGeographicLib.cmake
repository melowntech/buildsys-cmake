# - Try to find geographiclib
# Once done, this will define
#
#  GeographicLib_FOUND - system has GeographicLib
#  GeographicLib_INCLUDE_DIR - the GeographicLib include directory
#  GeographicLib_LIBRARIES - link these to use GeographicLib

find_path(GeographicLib_INCLUDE_DIR
  NAMES GeographicLib/TransverseMercator.hpp
)

# Finally the library itself
find_library(GeographicLib_LIBRARY
  NAMES Geographic
)

set(GeographicLib_LIBRARIES ${GeographicLib_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GeographicLib
  FOUND_VAR GeographicLib_FOUND
  REQUIRED_VARS GeographicLib_LIBRARIES GeographicLib_INCLUDE_DIR)
mark_as_advanced(GeographicLib_INCLUDE_DIR GeographicLib_LIBRARIES)
