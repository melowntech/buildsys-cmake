macro(enable_cuda_impl)
  find_package(CUDA 5.5 REQUIRED)
  include_directories(${CUDA_INCLUDE_DIRS})
  list(APPEND CUDA_LIBRARIES ${CUDA_CUDA_LIBRARY})
  set(__HOST_COMPILER_ID ${CMAKE_CXX_COMPILER_ID})

  if(CUDA_VERSION_MAJOR LESS 6)
    # CUDA 5.x
    set(CUDA_ARCH_BIN "2.0 3.0 3.5" CACHE STRING
      "Specify GPU architectures to build binaries for.")
  elseif(CUDA_VERSION_MAJOR LESS 8)
    # CUDA 7.x
    set(CUDA_ARCH_BIN "2.0 3.0 3.5 5.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")
  elseif(CUDA_VERSION_MAJOR LESS 9)
    # CUDA 8.x
    set(CUDA_ARCH_BIN "2.0 3.0 3.5 5.0 6.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")

    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -Wno-deprecated-gpu-targets")

    if (CMAKE_CXX_COMPILER_ID MATCHES GNU
        AND NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.0.0")
      message(STATUS "Too new gcc for cuda ${CUDA_VERSION_MAJOR}; "
        "forcing clang-3.8.")
      find_program(__CLANG_CUDA8 clang++-3.8)

      if(NOT __CLANG_CUDA8)
        message(FATAL_ERROR "Please, install clang-3.8")
      endif()

      set(CUDA_HOST_COMPILER ${__CLANG_CUDA8})
      set(__HOST_COMPILER_ID Clang)
    endif()
  else()
    # CUDA 9.x
    set(CUDA_ARCH_BIN "3.0 3.5 5.0 6.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")

    if (CMAKE_CXX_COMPILER_ID MATCHES GNU
        AND NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.0.0")
      message(STATUS "Too new gcc for cuda ${CUDA_VERSION_MAJOR}; "
        "forcing clang<=4.0.")
      find_program(__CLANG_CUDA9 NAMES clang++-4.0 clang++-3.9)

      if(NOT __CLANG_CUDA9)
        message(FATAL_ERROR "Please, install clang-4.0 or clang-3.9")
      endif()

      set(CUDA_HOST_COMPILER ${__CLANG_CUDA9})
      set(__HOST_COMPILER_ID Clang)
    endif()
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
  if (${__HOST_COMPILER_ID} MATCHES GNU)
    list(APPEND CUDA_NVCC_FLAGS -Xcompiler;-Wall,-Wno-unused-but-set-variable)
    list(APPEND CUDA_NVCC_FLAGS_DEBUG -g)
    list(APPEND CUDA_NVCC_FLAGS_RELEASE -O3)
    list(APPEND CUDA_NVCC_FLAGS_RELWITHDEBINFO -O2;-g)
  elseif (${__HOST_COMPILER_ID} MATCHES Clang)
    list(APPEND CUDA_NVCC_FLAGS -Xcompiler;-Wall;--compiler-options;-fPIC)
    list(APPEND CUDA_NVCC_FLAGS_DEBUG -g)
    list(APPEND CUDA_NVCC_FLAGS_RELEASE -O3)
    list(APPEND CUDA_NVCC_FLAGS_RELWITHDEBINFO -O2;-g)
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${__HOST_COMPILER_ID}.")
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
