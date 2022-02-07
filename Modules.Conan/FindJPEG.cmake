find_package(libjpeg-turbo REQUIRED CONFIG)

if (TARGET libjpeg-turbo::libjpeg-turbo)
  set(JPEG_FOUND TRUE)
  set(JPEG_LIBRARIES libjpeg-turbo::libjpeg-turbo)
endif()

# add_library(JPEG ALIAS libjpeg-turbo::libjpeg-turbo)

# get_target_property(JPEG_INCLUDE_DIR libjpeg-turbo::turbojpeg-static INTERFACE_INCLUDE_DIRECTORIES)