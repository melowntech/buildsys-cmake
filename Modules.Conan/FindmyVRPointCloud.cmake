find_package(myVRPointCloud CONFIG)

if (TARGET myVRPointCloud)
  set(myVRPointCloud_FOUND TRUE)
  set(myVRPointCloud_VERSION ${myVRPointCloud_VERSION})
  set(myVRPointCloud_LIBRARIES myVRPointCloud)
endif()
