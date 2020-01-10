# - Try to find GTS
# Once done, this will define
#
#  GTS_FOUND - system has GTS
#  GTS_INCLUDE_DIRS - the GTS include directories
#  GTS_LIBRARIES - link these to use GTS

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(GTS_PKGCONF QUIET gts)

find_path(GTS_INCLUDE_DIR
  NAMES gts.h
  PATHS ${GTS_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(GTS_LIBRARY NAMES gts)

set(GTS_LIBRARIES ${GTS_LIBRARY})
set(GTS_INCLUDE_DIRS ${GTS_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GTS DEFAULT_MSG
    GTS_LIBRARIES
    GTS_INCLUDE_DIRS)
mark_as_advanced(GTS_INCLUDE_DIR GTS_LIBRARIES)
