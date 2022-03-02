find_package(OpenMesh 8.1 REQUIRED CONFIG)
# TODO: Find other solution
message(WARNING "Force-using OpenMesh 8.1")

if (TARGET OpenMesh::OpenMesh)
  set(OPENMESH_FOUND TRUE)
  set(OPENMESH_VERSION ${openmesh_VERSION})
  set(OPENMESH_LIBRARIES OpenMesh::OpenMesh)
endif()