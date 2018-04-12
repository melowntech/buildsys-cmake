# FindPNG

# we look for png in Program Files
find_path(PNG_INCLUDE_DIR png.h
  PATHS "$ENV{PROGRAMFILES}/libpng"
  PATH_SUFFIXES include)

find_library(PNG_LIBRARY NAMES libpng16_static libpng17_static
  PATHS "$ENV{PROGRAMFILES}/libpng"
  PATH_SUFFIXES lib)

if(PNG_LIBRARY)
  set(PNG_LIBRARIES "${PNG_LIBRARY}")
endif()

if(PNG_INCLUDE_DIR)
  set(PNG_INCLUDE_DIRS "${PNG_INCLUDE_DIR}")
endif()

find_package_handle_standard_args(PNG DEFAULT_MSG
  PNG_LIBRARIES PNG_INCLUDE_DIR)
mark_as_advanced(PNG_LIBRARIES PNG_INCLUDE_DIR)
