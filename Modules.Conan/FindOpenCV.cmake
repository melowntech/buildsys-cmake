# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(opencV REQUIRED CONFIG)

if (TARGET opencv::opencv)
  set(OpenCV_FOUND TRUE)
  set(OpenCV_VERSION ${opencV_VERSION})
  set(OpenCV_LIBRARIES opencv::opencv)
endif()

#get_target_property(OpenCV_INCLUDE_DIRS opencv::opencv_core INTERFACE_INCLUDE_DIRECTORIES)