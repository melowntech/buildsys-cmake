# - Try to find GEOS
# Once done, this will define
#
#  GEOS_FOUND - system has GEOS
#  GEOS_INCLUDE_DIRS - the GEOS include directories
#  GEOS_LIBRARIES - link these to use GEOS

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(GEOS_PKGCONF QUIET geos)

find_path(GEOS_INCLUDE_DIR
  NAMES geos_c.h
  PATHS ${GEOS_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(GEOS_LIBRARY
  NAMES geos_c
  PATHS ${GEOS_PKGCONF_LIBRARY_DIRS}
)

set(GEOS_INCLUDE_DIRS ${GEOS_INCLUDE_DIR})
set(GEOS_LIBRARIES ${GEOS_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GEOS
  FOUND_VAR GEOS_FOUND
  REQUIRED_VARS
  GEOS_LIBRARIES
  GEOS_INCLUDE_DIRS
  )

mark_as_advanced(GEOS_INCLUDE_DIR GEOS_LIBRARIES)
