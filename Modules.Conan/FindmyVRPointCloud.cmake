# --------- backup variables ---------
set(_jsoncpp_FOUND ${jsoncpp_FOUND})
set(_jsoncpp_VERSION ${jsoncpp_VERSION})
set(_jsoncpp_LIBRARIES ${jsoncpp_LIBRARIES})
set(_jsoncpp_INCLUDE_DIRS ${jsoncpp_INCLUDE_DIRS})
# ------------------------------------

find_package(myVRArchive CONFIG)
find_package(myVRPointCloud CONFIG)

if (TARGET myVRPointCloud::myVRPointCloud)
  set(myVRPointCloud_FOUND TRUE)
  set(myVRPointCloud_VERSION ${myVRPointCloud_VERSION})
  set(myVRPointCloud_LIBRARIES myVRPointCloud::myVRPointCloud)
  add_library(myVRPointCloud ALIAS myVRPointCloud::myVRPointCloud)
endif()

# --------- restore variables ---------
set(jsoncpp_FOUND ${_jsoncpp_FOUND})
set(jsoncpp_VERSION ${_jsoncpp_VERSION})
set(jsoncpp_LIBRARIES ${_jsoncpp_LIBRARIES})
set(jsoncpp_INCLUDE_DIRS ${_jsoncpp_INCLUDE_DIRS})
# ------------------------------------