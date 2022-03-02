find_package(OpenCV REQUIRED CONFIG)

if (TARGET opencv::opencv)
  set(OpenCV_FOUND TRUE)
  set(OpenCV_VERSION ${OpenCV_VERSION})
  set(OpenCV_LIBRARIES opencv::opencv)
endif()