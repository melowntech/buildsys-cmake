macro(enable_cuda_impl)
  # To find and use the CUDA toolkit libraries manually, use the FindCUDAToolkit module instead. 
  # It works regardless of the CUDA language being enabled.
  find_package(CUDAToolkit REQUIRED)
  # WARNING: This is unfortunately overriden by Torch's TORCH_CUDA_ARCH_LIST
  if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.23.0")
    set(CMAKE_CUDA_ARCHITECTURES all-major CACHE STRING "") # cmake >= 3.23
  else()
    set(CMAKE_CUDA_ARCHITECTURES 61-real 75-real 86 CACHE STRING "")
  endif()
  add_definitions(-DHAS_CUDA)

  # Install CUDA DLLs
  if(BUILDSYS_CONAN)
    if (MSVC)
      file(GLOB CUDA_DLLS "$ENV{CUDA_PATH}/bin/*.dll")
      file(TO_CMAKE_PATH "${CUDA_DLLS}" CUDA_DLLS)
      install(FILES ${CUDA_DLLS} DESTINATION ${CMAKE_INSTALL_BINDIR} COMPONENT dynlibs)
    endif()
  endif()

endmacro()

set(_CUDA_LAMBDAS_ENABLED OFF)

macro(enable_cuda_lambdas TARGET)
  if(_CUDA_LAMBDAS_ENABLED)
    message(STATUS "Enabling CUDA lambdas support on target ${TARGET}.")
    set_source_files_properties(${ARGN} PROPERTIES LANGUAGE CUDA)
    target_compile_options(${TARGET} PRIVATE
      $<$<COMPILE_LANGUAGE:CUDA>:--expt-extended-lambda>)
    set_target_properties(${TARGET} PROPERTIES 
      CUDA_SEPARABLE_COMPILATION ON)
    if(WIN32)
      set_target_properties(${TARGET} PROPERTIES 
        CUDA_RESOLVE_DEVICE_SYMBOLS ON)
    endif()
    add_definitions(-DHAS_CUDA_LAMBDA)
  endif()
endmacro()

option(BUILDSYS_DISABLE_CUDA_LAMBDA "Disable CUDA lambdas support" OFF)

# for a given target and a list of sources, switch to nvcc compilation and enable extended lambdas
macro(enable_cuda_lambdas_impl)
  if(CMAKE_CUDA_COMPILER AND NOT BUILDSYS_DISABLE_CUDA_LAMBDA)
    message(STATUS "Enabling CUDA lambdas support (can be disabled by "
      "setting BUILDSYS_DISABLE_CUDA_LAMBDA variable).")
    set(_CUDA_LAMBDAS_ENABLED ON)
  else()
    message(STATUS "Disabling CUDA lambdas support because of BUILDSYS_DISABLE_CUDA_LAMBDA or no CMAKE_CUDA_COMPILER")
  endif()
endmacro()

# https://github.com/NVIDIA/thrust/blob/main/thrust/cmake/thrust-config.cmake#L564
# Wrap the OpenMP flags for CUDA targets
function(fix_omp_target_for_cuda omp_target)
get_target_property(opts ${omp_target} INTERFACE_COMPILE_OPTIONS)
if (opts MATCHES "\\$<\\$<COMPILE_LANGUAGE:CXX>:([^>]*)>")
  target_compile_options(${omp_target} INTERFACE
    $<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CUDA_COMPILER_ID:NVIDIA>>:-Xcompiler=${CMAKE_MATCH_1}>
  )
endif()
endfunction()

macro(enable_cuda)
  enable_cuda_impl(${ARGV})
  enable_cuda_lambdas_impl()
  if (TARGET OpenMP::OpenMP_CXX)
    fix_omp_target_for_cuda(OpenMP::OpenMP_CXX)
  endif()
endmacro()
