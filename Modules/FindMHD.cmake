# - Try to find libmicrophttpd
# Once done, this will define
#
#  MHD_FOUND - system has MHD
#  MHD_INCLUDE_DIRS - the MHD include directories
#  MHD_LIBRARIES - link these to use MHD

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(MHD_PKGCONF QUIET tinyxml2)

find_path(MHD_INCLUDE_DIR
  NAMES microhttpd.h
  PATHS ${MHD_PKGCONF_INCLUDE_DIRS}
  )

# Finally the library itself
find_library(MHD_LIBRARY
  NAMES microhttpd
  PATHS ${MHD_PKGCONF_LIBRARY_DIRS}
  )

set(MHD_INCLUDE_DIRS ${MHD_INCLUDE_DIR})
set(MHD_LIBRARIES ${MHD_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MHD DEFAULT_MSG
  MHD_LIBRARIES
  MHD_INCLUDE_DIRS)
mark_as_advanced(MHD_INCLUDE_DIR MHD_LIBRARIES)
