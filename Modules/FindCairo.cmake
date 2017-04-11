# - Try to find cairo library
# Once done, this will define
#
#  CAIRO_FOUND - system has CAIRO
#  CAIRO_INCLUDE_DIRS - the CAIRO include directories
#  CAIRO_LIBRARIES - link these to use CAIRO

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(CAIRO_PKGCONF QUIET cairo)

find_path(CAIRO_INCLUDE_DIR
  NAMES cairo/cairo.h
  PATHS ${CAIRO_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(CAIRO_LIBRARY
  NAMES cairo
  PATHS ${CAIRO_PKGCONF_LIBRARY_DIRS}
)

set(CAIRO_INCLUDE_DIRS ${CAIRO_INCLUDE_DIR})
set(CAIRO_LIBRARIES ${CAIRO_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cairo DEFAULT_MSG
  CAIRO_LIBRARIES
  CAIRO_INCLUDE_DIRS)
mark_as_advanced(CAIRO_INCLUDE_DIR CAIRO_LIBRARIES)
