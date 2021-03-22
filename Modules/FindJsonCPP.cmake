# - Try to find JSONCPP
# Once done, this will define
#
#  JSONCPP_FOUND - system has JSONCPP
#  JSONCPP_INCLUDE_DIRS - the JSONCPP include directories
#  JSONCPP_LIBRARIES - link these to use JSONCPP

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(JSONCPP_PKGCONF QUIET jsoncpp)

find_path(JSONCPP_INCLUDE_DIR
  NAMES json/features.h json/json_features.h
  PATH_SUFFIXES jsoncpp
  PATHS ${JSONCPP_PKGCONF_INCLUDE_DIRS}
  )

# Finally the library itself
find_library(JSONCPP_LIBRARY
  NAMES jsoncpp
  PATHS ${JSONCPP_PKGCONF_LIBRARY_DIRS}
  )

set(JSONCPP_INCLUDE_DIRS ${JSONCPP_INCLUDE_DIR})
set(JSONCPP_LIBRARIES ${JSONCPP_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JsonCPP DEFAULT_MSG
  JSONCPP_LIBRARIES
  JSONCPP_INCLUDE_DIR
  JSONCPP_INCLUDE_DIRS)
mark_as_advanced(JSONCPP_INCLUDE_DIR JSONCPP_LIBRARIES)
