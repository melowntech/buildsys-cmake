find_package(libjpeg-turbo REQUIRED CONFIG)

if (TARGET libjpeg-turbo::libjpeg-turbo)
  set(JPEG_FOUND TRUE)
  set(JPEG_VERSION ${libjpeg-turbo_VERSION})
  set(JPEG_LIBRARIES libjpeg-turbo::libjpeg-turbo)
endif()
