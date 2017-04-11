# - Try to find OSMESA
# Once done, this will define
#
#  OSMESA_FOUND - system has OSMESA
#  OSMESA_INCLUDE_DIRS - the OSMESA include directories
#  OSMESA_LIBRARIES - link these to use OSMESA

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(OSMESA_PKGCONF QUIET tinyxml2)

find_path(OSMESA_INCLUDE_DIR
  NAMES GL/osmesa.h
  PATHS ${OSMESA_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(OSMESA_OSMESA_LIBRARY
  NAMES OSMesa
  PATHS ${OSMESA_PKGCONF_LIBRARY_DIRS}
)

# Finally the library itself
find_library(OSMESA_GLUE_LIBRARY
  NAMES GLU
  PATHS ${OSMESA_PKGCONF_LIBRARY_DIRS}
)

set(OSMESA_INCLUDE_DIRS ${OSMESA_INCLUDE_DIR})
list(APPEND OSMESA_LIBRARIES ${OSMESA_OSMESA_LIBRARY})
list(APPEND OSMESA_LIBRARIES ${OSMESA_GLU_LIBRARY})

check_library_exists(${OSMESA_OSMESA_LIBRARY} glBegin "" OSMESSAFULL)
if(NOT OSMESSAFULL)
  message(STATUS "OSMesa does not provide core OpenGL functionality. Including full OpenGL.")
  find_package(OpenGL 3.0 REQUIRED)
  set(OSMESA_INCLUDE_DIR "${OSMESA_INCLUDE_DIR} ${OPENGL_INCLUDE_DIR}")
  list(APPEND OSMESA_LIBRARIES ${OPENGL_LIBRARIES})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OSMesa DEFAULT_MSG
  OSMESA_LIBRARIES
  OSMESA_INCLUDE_DIRS)
mark_as_advanced(OSMESA_INCLUDE_DIR OSMESA_LIBRARIES)
