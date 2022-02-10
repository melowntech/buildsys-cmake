# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(libjpeg-turbO REQUIRED CONFIG)

if (TARGET libjpeg-turbo::libjpeg-turbo)
  set(JPEG_FOUND TRUE)
  set(JPEG_VERSION ${libjpeg-turbO_VERSION})
  set(JPEG_LIBRARIES libjpeg-turbo::libjpeg-turbo)
endif()

# add_library(JPEG ALIAS libjpeg-turbo::libjpeg-turbo)

# get_target_property(JPEG_INCLUDE_DIR libjpeg-turbo::turbojpeg-static INTERFACE_INCLUDE_DIRECTORIES)