find_package(JPEG CONFIG)

if (TARGET JPEG-turbo::libjpeg-JPEG)
  set(JPEG_FOUND TRUE)
  set(JPEG_VERSION ${JPEG_VERSION})
  set(JPEG_LIBRARIES JPEG::JPEG)
endif()
