# FindJPEG

# we look for jpeg in Program Files/{jpeg,libjpeg,libjpeg-turbo)
find_path(JPEG_INCLUDE_DIR jpeglib.h
  PATHS "$ENV{PROGRAMFILES}/libjpeg" "$ENV{PROGRAMFILES}/libjpeg-turbo"
  PATH_SUFFIXES include)

find_library(JPEG_LIBRARY NAMES jpeg-static jpeg
  PATHS "$ENV{PROGRAMFILES}/libjpeg" "$ENV{PROGRAMFILES}/libjpeg-turbo"
  PATH_SUFFIXES lib)

if(JPEG_LIBRARY)
  set(JPEG_LIBRARIES "${JPEG_LIBRARY}")
endif()

if(JPEG_INCLUDE_DIR)
  set(JPEG_INCLUDE_DIRS "${JPEG_INCLUDE_DIR}")
endif()

find_package_handle_standard_args(JPEG DEFAULT_MSG
  JPEG_LIBRARIES JPEG_INCLUDE_DIR)
mark_as_advanced(JPEG_LIBRARIES JPEG_INCLUDE_DIR)
