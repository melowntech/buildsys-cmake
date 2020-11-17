macro(enable_cuda_impl)
  find_package(CUDA 5.5 REQUIRED)
  include_directories(${CUDA_INCLUDE_DIRS})
  list(APPEND CUDA_LIBRARIES ${CUDA_CUDA_LIBRARY})
  set(__HOST_COMPILER_ID ${CMAKE_CXX_COMPILER_ID})

  if(CUDA_VERSION_MAJOR LESS 6)
    # CUDA 5.x
    set(CUDA_ARCH_BIN "2.0 3.0 3.5" CACHE STRING
      "Specify GPU architectures to build binaries for.")
    set(CUDA_ARCH_PTX "3.5" CACHE STRING
      "Specify PTX architectures to build PTX intermediate code for.")
  elseif(CUDA_VERSION_MAJOR LESS 8)
    # CUDA 7.x
    set(CUDA_ARCH_BIN "2.0 3.0 3.5 5.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")
    set(CUDA_ARCH_PTX "5.0" CACHE STRING
      "Specify PTX architectures to build PTX intermediate code for.")
  elseif(CUDA_VERSION_MAJOR LESS 9)
    # CUDA 8.x
    set(CUDA_ARCH_BIN "2.0 3.0 3.5 5.0 6.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")
    set(CUDA_ARCH_PTX "6.0" CACHE STRING
      "Specify PTX architectures to build PTX intermediate code for.")

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
  elseif(CUDA_VERSION VERSION_LESS 9.2)
    # CUDA < 9.2
    set(CUDA_ARCH_BIN "3.0 3.5 5.0 6.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")
    set(CUDA_ARCH_PTX "6.0" CACHE STRING
      "Specify PTX architectures to build PTX intermediate code for.")

    if (CMAKE_CXX_COMPILER_ID MATCHES GNU
        AND NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.0.0")
      message(STATUS "Too new gcc for cuda ${CUDA_VERSION_MAJOR}; "
        "clang<=4.0.")
      find_program(__CLANG_CUDA9 NAMES clang++-4.0 clang++-3.9)

      if(NOT __CLANG_CUDA9)
        message(FATAL_ERROR "Please, install clang-4.0 or clang-3.9")
      endif()

      set(CUDA_HOST_COMPILER ${__CLANG_CUDA9})
      set(__HOST_COMPILER_ID Clang)
    endif()
  elseif(CUDA_VERSION VERSION_LESS 10.0)
    # CUDA >= 9.2 && < 10.0
    set(CUDA_ARCH_BIN "3.0 3.5 5.0 6.0" CACHE STRING
      "Specify GPU architectures to build binaries for.")
    set(CUDA_ARCH_PTX "6.0" CACHE STRING
      "Specify PTX architectures to build PTX intermediate code for.")

    if (CMAKE_CXX_COMPILER_ID MATCHES GNU
        AND NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.0.0")
      message(STATUS "Too new gcc for cuda ${CUDA_VERSION_MAJOR}; "
        "forcing g++-<=8.")
      find_program(__GPP_CUDA92 NAMES g++-8 g++-7)

      if(NOT __GPP_CUDA92)
        message(FATAL_ERROR "Please, install g++-8 or g++-7")
      endif()

      set(CUDA_HOST_COMPILER ${__GPP_CUDA92})
    endif()
  else()
    # CUDA >= 10.0
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
  endif()

  message(STATUS "CUDA: compiling code for ${CUDA_ARCH_BIN} binary arch.")

  # do not propagate host flags; C++11 doesn't work
  set(CUDA_PROPAGATE_HOST_FLAGS OFF)

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
      $<$<COMPILE_LANGUAGE:CUDA>:--expt-extended-lambda -Xcompiler "-fopenmp" >)
    set_target_properties(${TARGET} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
    add_definitions(-DHAS_CUDA_LAMBDA)
  endif()
endmacro()

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

macro(enable_cuda)
  if(NOT BUILDSYS_DISABLE_CUDA)
    enable_cuda_impl()
    message(STATUS "Enabling CUDA support (can be disabled by setting BUILDSYS_DISABLE_CUDA variable).")
    enable_cuda_lambdas_impl()
  else()
    message(STATUS "Disabling CUDA support because of BUILDSYS_DISABLE_CUDA.")
    # unset global varibale CUDA_FOUND because some 3rdparty libraries use CUDA
    # and clutter global namespace (I'm looking at you, OpenCV).
    set(CUDA_FOUND OFF)
  endif()
endmacro()
