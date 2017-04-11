# - Try to find exif library
# Once done, this will define
#
#  EXIF_FOUND - system has EXIF
#  EXIF_INCLUDE_DIRS - the EXIF include directories
#  EXIF_LIBRARIES - link these to use EXIF

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(EXIF_PKGCONF QUIET exif)

find_path(EXIF_INCLUDE_DIR
  NAMES exif-data.h
  PATHS ${EXIF_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(EXIF_LIBRARY
  NAMES exif
  PATHS ${EXIF_PKGCONF_LIBRARY_DIRS}
)

set(EXIF_INCLUDE_DIRS ${EXIF_INCLUDE_DIR})
set(EXIF_LIBRARIES ${EXIF_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EXIF DEFAULT_MSG
  EXIF_LIBRARIES
  EXIF_INCLUDE_DIRS)
mark_as_advanced(EXIF_INCLUDE_DIR EXIF_LIBRARIES)
