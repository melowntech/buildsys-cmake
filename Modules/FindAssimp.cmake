# - Try to find ASSIMP
# Once done, this will define
#
#  ASSIMP_FOUND - system has ASSIMP
#  ASSIMP_INCLUDE_DIRS - the ASSIMP include directories
#  ASSIMP_LIBRARIES - link these to use ASSIMP

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(ASSIMP_PKGCONF QUIET tinyxml2)

find_path(ASSIMP_INCLUDE_DIR
  NAMES assimp/mesh.h
  PATHS ${ASSIMP_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(ASSIMP_LIBRARY
  NAMES assimp
  PATHS ${ASSIMP_PKGCONF_LIBRARY_DIRS}
)

set(ASSIMP_INCLUDE_DIRS ${ASSIMP_INCLUDE_DIR})
set(ASSIMP_LIBRARIES ${ASSIMP_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Assimp DEFAULT_MSG
  ASSIMP_LIBRARIES
  ASSIMP_INCLUDE_DIRS)
mark_as_advanced(ASSIMP_INCLUDE_DIR ASSIMP_LIBRARIES)
