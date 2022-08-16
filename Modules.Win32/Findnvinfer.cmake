# - Try to find NVINFER
# Once done, this will define
#
#  NVINFER_FOUND - system has NVINFER
#  NVINFER_INCLUDE_DIRS - the NVINFER include directories
#  NVINFER_LIBRARIES - link these to use NVINFER

find_path(NVINFER_INCLUDE_DIR NvInfer.h
  HINTS ${TENSORRT_ROOT} ${CUDA_TOOLKIT_ROOT_DIR}
  PATH_SUFFIXES include)

find_library(NVINFER_LIBRARY_INFER nvinfer
  HINTS ${TENSORRT_ROOT} ${TENSORRT_BUILD} ${CUDA_TOOLKIT_ROOT_DIR}
  PATH_SUFFIXES lib lib64 lib/x64)
find_library(NVINFER_LIBRARY_INFER_PLUGIN nvinfer_plugin
  HINTS  ${TENSORRT_ROOT} ${TENSORRT_BUILD} ${CUDA_TOOLKIT_ROOT_DIR}
  PATH_SUFFIXES lib lib64 lib/x64)

set(NVINFER_INCLUDE_DIRS ${NVINFER_INCLUDE_DIR})
list(APPEND NVINFER_LIBRARIES ${NVINFER_LIBRARY_INFER} ${NVINFER_LIBRARY_INFER_PLUGIN})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(nvinfer DEFAULT_MSG
    NVINFER_LIBRARIES
    NVINFER_INCLUDE_DIRS)
mark_as_advanced(NVINFER_INCLUDE_DIRS NVINFER_LIBRARIES)
