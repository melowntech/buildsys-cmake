# - Try to find NVONNXPARSER
# Once done, this will define
#
#  NVONNXPARSER_FOUND - system has NVONNXPARSER
#  NVONNXPARSER_INCLUDE_DIRS - the NVONNXPARSER include directories
#  NVONNXPARSER_LIBRARIES - link these to use NVONNXPARSER

find_path(NVONNXPARSER_INCLUDE_DIR
  NAMES NvOnnxParser.h
)

# Finally the library itself
find_library(NVONNXPARSER_LIBRARY NAMES nvonnxparser)

set(NVONNXPARSER_INCLUDE_DIRS ${NVONNXPARSER_INCLUDE_DIR})
list(APPEND NVONNXPARSER_LIBRARIES ${NVONNXPARSER_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(nvonnxparser DEFAULT_MSG
  NVONNXPARSER_LIBRARIES
  NVONNXPARSER_INCLUDE_DIRS)
mark_as_advanced(NVONNXPARSER_INCLUDE_DIRS NVONNXPARSER_LIBRARIES)
