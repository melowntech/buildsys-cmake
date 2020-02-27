# - Try to find MGTS
# Once done, this will define
#
#  MGTS_FOUND - system has MGTS
#  MGTS_INCLUDE_DIRS - the MGTS include directories
#  MGTS_LIBRARIES - link these to use MGTS

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(MGTS_PKGCONF QUIET mgts)

find_path(MGTS_INCLUDE_DIR
  NAMES mgts.h
  PATHS ${MGTS_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(MGTS_LIBRARY NAMES mgts)

set(MGTS_LIBRARIES ${MGTS_LIBRARY})
set(MGTS_INCLUDE_DIRS ${MGTS_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MGTS DEFAULT_MSG
    MGTS_LIBRARIES
    MGTS_INCLUDE_DIRS)
mark_as_advanced(MGTS_INCLUDE_DIR MGTS_LIBRARIES)
