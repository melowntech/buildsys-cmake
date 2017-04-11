macro(enable_opencl_impl)
  find_package(OpenCL REQUIRED)
  include_directories(${OPENCL_INCLUDE_DIRS})

  add_definitions(-DHAS_OPENCL)

  # we must ask for 1.1 API support
  add_definitions(-DCL_USE_DEPRECATED_OPENCL_1_1_APIS)
endmacro()

macro(enable_opencl)
  if(NOT BUILDSYS_DISABLE_OPENCL)
    enable_opencl_impl()
    message(STATUS "Enabling OpenCL support (can be disabled by setting BUILDSYS_DISABLE_OPENCL variable).")
  else()
    message(STATUS "Disabling OpenCL support because of BUILDSYS_DISABLE_OPENCL.")
  endif()
endmacro()
