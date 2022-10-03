# - Try to find PROJ
# Once done, this will define
#
#  PROJ_FOUND - system has Proj library
#  PROJ_INCLUDE_DIRS - the Proj include directories
#  PROJ_LIBRARIES - link these to use Proj library
#  PROJ_VERSION - Proj library version

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(PROJ_PKGCONF QUIET proj)

find_path(PROJ_INCLUDE_DIR
  NAMES proj.h
  PATHS ${PROJ_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(PROJ_LIBRARY
  NAMES proj proj_i
  PATHS ${PROJ_PKGCONF_LIBRARY_DIRS}
)

set(PROJ_INCLUDE_DIRS ${PROJ_INCLUDE_DIR})
set(PROJ_LIBRARIES ${PROJ_LIBRARY})
set(PROJ_VERSION ${PROJ_PKGCONF_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PROJ DEFAULT_MSG
  PROJ_LIBRARIES
  PROJ_INCLUDE_DIRS
  PROJ_VERSION)
mark_as_advanced(PROJ_INCLUDE_DIR PROJ_LIBRARIES PROJ_VERSION)

# Some of the 3rd party libs require PROJ::proj target
if(PROJ_FOUND AND NOT TARGET PROJ::proj)
  add_library(PROJ::proj SHARED IMPORTED)
  set_target_properties(PROJ::proj PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
    IMPORTED_LOCATION "${PROJ_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES
      "${PROJ_INCLUDE_DIR}"
    )
endif()
