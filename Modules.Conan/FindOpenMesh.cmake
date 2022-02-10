# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(openmesH 8.1 REQUIRED CONFIG)
# TODO: Find other solution
message(WARNING "Force-using OpenMesh 8.1")

if (TARGET OpenMesh::OpenMesh)
  set(OPENMESH_FOUND TRUE)
  set(OPENMESH_VERSION ${openmesH_VERSION})
  set(OPENMESH_LIBRARIES OpenMesh::OpenMesh)
endif()

# get_target_property(OPENMESH_LIBRARIES OpenMesh::OpenMesh INTERFACE_LINK_LIBRARIES)
# get_target_property(OPENMESH_INCLUDE_DIRS OpenMesh::OpenMeshCore INTERFACE_INCLUDE_DIRECTORIES)

# include(FindPackageHandleStandardArgs)

# find_package_handle_standard_args(OpenMesh DEFAULT_MSG
#   OPENMESH_LIBRARIES
#   OPENMESH_INCLUDE_DIRS)

# mark_as_advanced(OPENMESH_INCLUDE_DIR OPENMESH_LIBRARIES)


