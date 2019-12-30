# - Try to find FFTW3
# Once done, this will define
#
#  FFTW3_FOUND - system has Proj library
#  FFTW3_INCLUDE_DIRS - the Proj include directories
#  FFTW3_LIBRARIES - link these to use Proj library

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(FFTW3_PKGCONF QUIET fftw3)

find_path(FFTW3_INCLUDE_DIR
  NAMES fftw3.h
  PATHS ${FFTW3_PKGCONF_INCLUDE_DIRS}
)

find_library(FFTW3_LIBRARY
  NAMES fftw3
  PATHS ${FFTW3_PKGCONF_LIBRARY_DIRS}
  )

set(FFTW3_INCLUDE_DIRS ${FFTW3_INCLUDE_DIR})
set(FFTW3_LIBRARIES ${FFTW3_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FFTW3 DEFAULT_MSG
  FFTW3_LIBRARIES
  FFTW3_INCLUDE_DIRS)
mark_as_advanced(FFTW3_INCLUDE_DIR FFTW3_LIBRARIES)
