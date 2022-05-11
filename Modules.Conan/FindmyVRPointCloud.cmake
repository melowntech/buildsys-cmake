find_package(myVRPointCloud CONFIG)

if (TARGET myVRPointCloud::myVRPointCloud)
  set(myVRPointCloud_FOUND TRUE)
  set(myVRPointCloud_VERSION ${myVRPointCloud_VERSION})
  set(myVRPointCloud_LIBRARIES myVRPointCloud::myVRPointCloud)
  add_library(myVRPointCloud ALIAS myVRPointCloud::myVRPointCloud)
endif()
