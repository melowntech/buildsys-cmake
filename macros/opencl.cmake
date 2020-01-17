macro(enable_opencl_impl)
  find_package(OpenCL REQUIRED)
  include_directories(${OPENCL_INCLUDE_DIRS})

  add_definitions(-DHAS_OPENCL)

  # needef for new OpenCL instalations, ignored in older ones
  add_definitions(-DCL_TARGET_OPENCL_VERSION=220)
endmacro()

macro(enable_opencl)
  if(NOT BUILDSYS_DISABLE_OPENCL)
    enable_opencl_impl()
    message(STATUS "Enabling OpenCL support (can be disabled by setting BUILDSYS_DISABLE_OPENCL variable).")
  else()
    message(STATUS "Disabling OpenCL support because of BUILDSYS_DISABLE_OPENCL.")
  endif()
endmacro()
