find_package(HSPC REQUIRED CONFIG)

if (TARGET HSPC::HSPC)
  set(myVRPointCloud_FOUND TRUE)
  set(myVRPointCloud_VERSION ${HSPC_VERSION})
  set(myVRPointCloud_LIBRARIES HSPC::HSPC)
  add_library(myVRPointCloud ALIAS HSPC::HSPC)
endif()
