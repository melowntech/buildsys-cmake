# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(hspC REQUIRED CONFIG)

if (TARGET HSPC::HSPC)
  set(myVRPointCloud_FOUND TRUE)
  set(myVRPointCloud_VERSION ${hspC_VERSION})
  set(myVRPointCloud_LIBRARIES HSPC::HSPC)
  add_library(myVRPointCloud ALIAS HSPC::HSPC)
endif()