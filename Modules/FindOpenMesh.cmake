# - Try to findOPENMESH
# Once done this will define
#
# OPENMESH_FOUND        - system has OPENMESH
# OPENMESH_INCLUDE_DIR  - theOPENMESH include directory
# OPENMESH_LIBRARIES    - Link these to use OPENMESH
# OPENMESH_LIBRARY_DIR  - Library DIR of OPENMESH
#

find_path(OPENMESH_INCLUDE_DIR
  NAMES OpenMesh/Core/Mesh/TriMeshT.hh
)

# Finally libraries
find_library(OPENMESH_CORE_LIBRARY
  NAMES OpenMeshCore
  )

find_library(OPENMESH_TOOLS_LIBRARY
  NAMES OpenMeshTools
  )

set(OPENMESH_INCLUDE_DIRS ${OPENMESH_INCLUDE_DIR})
list(APPEND OPENMESH_LIBRARIES ${OPENMESH_CORE_LIBRARY})
list(APPEND OPENMESH_LIBRARIES ${OPENMESH_TOOLS_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OpenMesh DEFAULT_MSG
  OPENMESH_LIBRARIES
  OPENMESH_INCLUDE_DIRS)
mark_as_advanced(OPENMESH_INCLUDE_DIR OPENMESH_LIBRARIES)
