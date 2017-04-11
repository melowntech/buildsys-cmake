# - Try to find OpenCL
# Once done this will define
#  OPENCL_FOUND - system has OpenCL
#  OPENCL_INCLUDE_DIRS - the OpenCL include directory
#  OPENCL_LIBRARIES - link these to use OpenCL
#
# WIN32 should work, but is untested

set(OPENCL_VERSION_MAJOR 0)
set(OPENCL_VERSION_MINOR 1)
set(OPENCL_VERSION_PATCH 0)
set(OPENCL_VERSION_STRING "${OPENCL_VERSION_MAJOR}.${OPENCL_VERSION_MINOR}.${OPENCL_VERSION_PATCH}")

find_library(OPENCL_LIBRARIES OpenCL
  PATHS
  ENV LD_LIBRARY_PATH
  )

get_filename_component(OPENCL_LIB_DIR ${OPENCL_LIBRARIES} PATH)
get_filename_component(_OPENCL_INC_CAND ${OPENCL_LIB_DIR}/../../include ABSOLUTE)

find_path(OPENCL_INCLUDE_DIRS CL/cl.h
  PATHS ENV OpenCL_INCPATH)
find_path(_OPENCL_CPP_INCLUDE_DIRS CL/cl.hpp PATHS ${_OPENCL_INC_CAND})

find_package(PackageHandleStandardArgs)
find_package_handle_standard_args(OpenCL
  DEFAULT_MSG OPENCL_LIBRARIES OPENCL_INCLUDE_DIRS)

mark_as_advanced(OPENCL_LIBRARIES OPENCL_INCLUDE_DIRS)
