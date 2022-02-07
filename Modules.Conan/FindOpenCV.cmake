find_package(OpenCV REQUIRED CONFIG)

if (TARGET opencv::opencv)
  set(OpenCV_FOUND TRUE)
  set(OpenCV_LIBRARIES opencv::opencv)
endif()

#get_target_property(OpenCV_INCLUDE_DIRS opencv::opencv_core INTERFACE_INCLUDE_DIRECTORIES)