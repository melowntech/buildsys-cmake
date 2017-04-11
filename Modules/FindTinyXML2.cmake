# - Try to find TINYXML2
# Once done, this will define
#
#  TINYXML2_FOUND - system has TINYXML2
#  TINYXML2_INCLUDE_DIRS - the TINYXML2 include directories
#  TINYXML2_LIBRARIES - link these to use TINYXML2

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(TINYXML2_PKGCONF QUIET tinyxml2)

find_path(TINYXML2_INCLUDE_DIR
  NAMES tinyxml2.h
  PATHS ${TINYXML2_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(TINYXML2_LIBRARY
  NAMES tinyxml2
  PATHS ${TINYXML2_PKGCONF_LIBRARY_DIRS}
)

set(TINYXML2_INCLUDE_DIRS ${TINYXML2_INCLUDE_DIR})
set(TINYXML2_LIBRARIES ${TINYXML2_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TinyXML2 DEFAULT_MSG
  TINYXML2_LIBRARIES
  TINYXML2_INCLUDE_DIRS)
mark_as_advanced(TINYXML2_INCLUDE_DIR TINYXML2_LIBRARIES)
