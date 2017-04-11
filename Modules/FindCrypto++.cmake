# - Try to find CRYPTO++
# Once done, this will define
#
#  CRYPTO++_FOUND - system has CRYPTO++
#  CRYPTO++_INCLUDE_DIRS - the CRYPTO++ include directories
#  CRYPTO++_LIBRARIES - link these to use CRYPTO++

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(CRYPTO++_PKGCONF QUIET crypto++)

find_path(CRYPTO++_INCLUDE_DIR
  NAMES crypto++/rsa.h
  PATHS ${CRYPTO++_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(CRYPTO++_LIBRARY
  NAMES crypto++
  PATHS ${CRYPTO++_PKGCONF_LIBRARY_DIRS}
)

set(CRYPTO++_INCLUDE_DIRS ${CRYPTO++_INCLUDE_DIR})
set(CRYPTO++_LIBRARIES ${CRYPTO++_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Crypto++ DEFAULT_MSG
  CRYPTO++_LIBRARIES
  CRYPTO++_INCLUDE_DIRS)
mark_as_advanced(CRYPTO++_INCLUDE_DIR CRYPTO++_LIBRARIES)
