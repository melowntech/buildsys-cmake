# - Try to find GLIB
# Once done, this will define
#
#  GLIB_FOUND - system has GLIB
#  GLIB_INCLUDE_DIRS - the GLIB include directories
#  GLIB_LIBRARIES - link these to use GLIB

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(PKGCONF_GLIB QUIET glib-2.0)

find_path(GLIB_INCLUDE_DIR
    NAMES glib.h
    PATH_SUFFIXES glib-2.0
    HINTS ${PKGCONF_GLIB_INCLUDEDIR}
          ${PKGCONF_GLIB_INCLUDE_DIRS}
)

find_path(GLIBCONFIG_INCLUDE_DIR
    NAMES glibconfig.h
    PATH_SUFFIXES glib-2.0/include
    HINTS ${PKGCONF_GLIB_INCLUDEDIR}
          ${PKGCONF_GLIB_INCLUDE_DIRS}
)

find_library(GLIB_LIBRARY
    NAMES glib-2.0
    HINTS ${PKGCONF_GLIB_LIBDIR}
          ${PKGCONF_GLIB_LIBRARY_DIRS}
)

set(GLIB_INCLUDE_DIRS
    ${GLIB_INCLUDE_DIR}
    ${GLIBCONFIG_INCLUDE_DIR}
)
set(GLIB_LIBRARIES ${GLIB_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLIB DEFAULT_MSG
    GLIB_LIBRARIES
    GLIB_INCLUDE_DIRS)
mark_as_advanced(GLIB_INCLUDE_DIR GLIB_LIBRARIES)
