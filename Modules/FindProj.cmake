# - Try to find PROJ
# Once done, this will define
#
#  PROJ_FOUND - system has Proj library
#  PROJ_INCLUDE_DIRS - the Proj include directories
#  PROJ_LIBRARIES - link these to use Proj library

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(PROJ_PKGCONF QUIET proj)

find_path(PROJ_INCLUDE_DIR
  NAMES proj_api.h
  PATHS ${PROJ_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(PROJ_LIBRARY
  NAMES proj proj_i
  PATHS ${PROJ_PKGCONF_LIBRARY_DIRS}
)

set(PROJ_INCLUDE_DIRS ${PROJ_INCLUDE_DIR})
set(PROJ_LIBRARIES ${PROJ_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Proj DEFAULT_MSG
  PROJ_LIBRARIES
  PROJ_INCLUDE_DIRS)
mark_as_advanced(PROJ_INCLUDE_DIR PROJ_LIBRARIES)
