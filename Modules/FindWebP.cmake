# - Try to find WEBP
# Once done, this will define
#
#  WEBP_FOUND - system has WEBP
#  WEBP_INCLUDE_DIRS - the WEBP include directories
#  WEBP_LIBRARIES - link these to use WEBP

find_path(WEBP_INCLUDE_DIR
  NAMES webp/decode.h
)

# Finally the library itself
find_library(WEBP_LIBRARY
  NAMES webp
)

set(WEBP_INCLUDE_DIRS ${WEBP_INCLUDE_DIR})
set(WEBP_LIBRARIES ${WEBP_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(WebP DEFAULT_MSG
  WEBP_LIBRARIES
  WEBP_INCLUDE_DIRS)
mark_as_advanced(WEBP_INCLUDE_DIR WEBP_LIBRARIES)
