# - Try to find NVINFER
# Once done, this will define
#
#  NVINFER_FOUND - system has NVINFER
#  NVINFER_INCLUDE_DIRS - the NVINFER include directories
#  NVINFER_LIBRARIES - link these to use NVINFER

find_path(NVINFER_INCLUDE_DIR
  NAMES NvInfer.h
)

# Finally the library itself
find_library(NVINFER_LIBRARY NAMES nvinfer)

set(NVINFER_INCLUDE_DIRS ${NVINFER_INCLUDE_DIR})
list(APPEND NVINFER_LIBRARIES ${NVINFER_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(nvinfer DEFAULT_MSG
    NVINFER_LIBRARIES
    NVINFER_INCLUDE_DIRS)
mark_as_advanced(NVINFER_INCLUDE_DIRS NVINFER_LIBRARIES)
