find_package(OpenMesh CONFIG)

if (TARGET OpenMesh::OpenMesh)
  set(OPENMESH_FOUND TRUE)
  set(OPENMESH_VERSION ${openmesh_VERSION})
  set(OPENMESH_LIBRARIES OpenMesh::OpenMesh)
endif()
