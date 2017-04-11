macro(enable_cuda_impl)
  find_package(CUDA 5.5 REQUIRED)
  include_directories(${CUDA_INCLUDE_DIRS})
  list(APPEND CUDA_LIBRARIES ${CUDA_CUDA_LIBRARY})

  if(CUDA_VERSION_MAJOR LESS 6)
    set(CUDA_ARCH_BIN "2.0 3.0 3.5" CACHE STRING
      "Specify GPU architectures to build binaries for.")
  else()
    set(CUDA_ARCH_BIN "2.0 3.0 3.5 5.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")
  endif()

  message(STATUS "CUDA: compiling code for ${CUDA_ARCH_BIN} binary arch.")

  # do not propagate host flags; C++11 doesn't work
  set(CUDA_PROPAGATE_HOST_FLAGS OFF)

  # >>> copied from opencv build
  set(NVCC_FLAGS_EXTRA "")
  string(REGEX REPLACE "\\." "" ARCH_BIN_NO_POINTS "${CUDA_ARCH_BIN}")
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

  set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} ${NVCC_FLAGS_EXTRA})
  # <<< copied from opencv build

  # compiler options
  if (${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
    list(APPEND CUDA_NVCC_FLAGS -Xcompiler;-Wall,-Wno-unused-but-set-variable)
    list(APPEND CUDA_NVCC_FLAGS_DEBUG -g)
    list(APPEND CUDA_NVCC_FLAGS_RELEASE -O3)
    list(APPEND CUDA_NVCC_FLAGS_RELWITHDEBINFO -O2;-g)
  elseif (${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    message(WARNING "No CUDA Clang-specific flags. Implement me pls :P.")
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()

  add_definitions(-DHAS_CUDA)
endmacro()

macro(enable_cuda)
  if(NOT BUILDSYS_DISABLE_CUDA)
    enable_cuda_impl()
    message(STATUS "Enabling CUDA support (can be disabled by setting BUILDSYS_DISABLE_CUDA variable).")
  else()
    message(STATUS "Disabling CUDA support because of BUILDSYS_DISABLE_CUDA.")
  endif()
endmacro()
