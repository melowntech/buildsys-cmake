macro(enable_cuda_impl)
  set(__version 5.5)
  if (${ARGC} GREATER_EQUAL 1)
    set(__version ${ARGV0})
  endif()
  
  if(WIN32)
    # disable static CUDA runtime
    set(CUDA_USE_STATIC_CUDA_RUNTIME OFF CACHE BOOL "")
    set(CMAKE_CUDA_RUNTIME_LIBRARY Shared CACHE STRING "")
  endif()

  find_package(CUDA ${__version} REQUIRED)
  if(NOT WIN32)
    # TODO: may not be needed
    include_directories(${CUDA_INCLUDE_DIRS})
    list(APPEND CUDA_LIBRARIES ${CUDA_CUDA_LIBRARY})
  endif()
  set(__HOST_COMPILER_ID ${CMAKE_CXX_COMPILER_ID})

  if(CUDA_VERSION VERSION_LESS 11.0)
    # CUDA >= 10.0 && < 11.0
    set(CUDA_ARCH_BIN "3.0 3.5 5.0 6.0 7.5" CACHE STRING
      "Specify GPU architectures to build binaries for.")
    set(CUDA_ARCH_PTX "6.0" CACHE STRING
      "Specify PTX architectures to build PTX intermediate code for.")

    if (CMAKE_CXX_COMPILER_ID MATCHES GNU
        AND NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
      message(STATUS "Too new gcc for cuda ${CUDA_VERSION_MAJOR}; "
        "forcing g++-<=8.")
      find_program(__GPP_CUDA10 NAMES g++-8 g++-7)

      if(NOT __GPP_CUDA10)
        message(FATAL_ERROR "Please, install g++-8 or g++-7")
      endif()

      set(CUDA_HOST_COMPILER ${__GPP_CUDA10})
    endif()
  else()
    # CUDA >= 11.0
    set(CUDA_ARCH_BIN "6.1 7.5 8.6" CACHE STRING
      "Specify GPU architectures to build binaries for.")
    set(CUDA_ARCH_PTX "8.6" CACHE STRING
      "Specify PTX architectures to build PTX intermediate code for.")

    if (CMAKE_CXX_COMPILER_ID MATCHES GNU
        AND NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "11.0.0")
      message(STATUS "Too new gcc for cuda ${CUDA_VERSION_MAJOR}; "
        "forcing g++-<=10.")
      find_program(__GPP_CUDA11 NAMES g++-10 g++-9 g++-8 g++-7)

      if(NOT __GPP_CUDA11)
        message(FATAL_ERROR "Please, install g++-10 g++-9, g++-8 or g++-7")
      endif()

      set(CUDA_HOST_COMPILER ${__GPP_CUDA11})
    endif()
  endif()

  message(STATUS "CUDA: compiling code for ${CUDA_ARCH_BIN} binary arch.")

  # do not propagate host flags; C++11 doesn't work
  if(NOT WIN32)
    # TODO: may not be needed
    set(CUDA_PROPAGATE_HOST_FLAGS OFF)
  endif()

  # >>> copied from opencv build
  set(NVCC_FLAGS_EXTRA "")
  string(REGEX REPLACE "\\." "" ARCH_BIN_NO_POINTS "${CUDA_ARCH_BIN}")
  string(REGEX REPLACE "\\." "" ARCH_PTX_NO_POINTS "${CUDA_ARCH_PTX}")

  string(REGEX MATCHALL "[0-9()]+" ARCH_LIST "${ARCH_BIN_NO_POINTS}")
  foreach(ARCH IN LISTS ARCH_LIST)
    if(ARCH MATCHES "([0-9]+)\\(([0-9]+)\\)")
      # User explicitly specified PTX for the concrete BIN
      set(NVCC_FLAGS_EXTRA ${NVCC_FLAGS_EXTRA} -gencode arch=compute_${CMAKE_MATCH_2},code=sm_${CMAKE_MATCH_1})
    else()
      # User didn't explicitly specify PTX for the concrete BIN, we assume PTX=BIN
      set(NVCC_FLAGS_EXTRA ${NVCC_FLAGS_EXTRA} -gencode arch=compute_${ARCH},code=sm_${ARCH})
    endif()
  endforeach()

  string(REGEX MATCHALL "[0-9]+" ARCH_LIST "${ARCH_PTX_NO_POINTS}")
  foreach(ARCH IN LISTS ARCH_LIST)
    set(NVCC_FLAGS_EXTRA ${NVCC_FLAGS_EXTRA} -gencode arch=compute_${ARCH},code=compute_${ARCH})
  endforeach()

  set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} ${NVCC_FLAGS_EXTRA})
  # <<< copied from opencv build

  # compiler options
  if (${__HOST_COMPILER_ID} MATCHES GNU)
    list(APPEND CUDA_NVCC_FLAGS -Xcompiler;-Wall,-Wno-unused-but-set-variable)
    list(APPEND CUDA_NVCC_FLAGS_DEBUG -g)
    list(APPEND CUDA_NVCC_FLAGS_RELEASE -O3;-g)
    list(APPEND CUDA_NVCC_FLAGS_RELWITHDEBINFO -O2;-g)
  elseif (${__HOST_COMPILER_ID} MATCHES Clang)
    list(APPEND CUDA_NVCC_FLAGS -Xcompiler;-Wall;--compiler-options;-fPIC)
    list(APPEND CUDA_NVCC_FLAGS_DEBUG -g)
    list(APPEND CUDA_NVCC_FLAGS_RELEASE -O3;-g)
    list(APPEND CUDA_NVCC_FLAGS_RELWITHDEBINFO -O2;-g)
  elseif (${__HOST_COMPILER_ID}_ STREQUAL "MSVC_") # MSVC is a keyword
    message(STATUS "Todo configure cuda for msvc")
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${__HOST_COMPILER_ID}.")
  endif()

  add_definitions(-DHAS_CUDA)
endmacro()

set(_CUDA_LAMBDAS_ENABLED OFF)
set(BUILDSYS_CUDA_HOST_OPTION " ")

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
    set(BUILDSYS_CUDA_HOST_OPTION "-Xcompiler ")
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
