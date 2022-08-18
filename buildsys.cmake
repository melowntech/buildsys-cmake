# sanity check: no in-tree build
if("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
  message(FATAL_ERROR "In-source build is disabled. Remove the already"
    "generated files [CMakeCache.txt CMakFiles/] and start again"
    "from dedicated build directory.")
endif()
set(CMAKE_DISABLE_SOURCE_CHANGES ON)

# buildsystem as a dependency: fake dependency (e.g. BuildSystem>=1.0)
set(BuildSystem_VERSION 1.14)
set(BuildSystem_FOUND TRUE)
set(BuildSystem_LIBRARIES)
set(BuildSystem_DEFINITION)

# remember buildsystem root
set(BUILDSYS_ROOT ${CMAKE_CURRENT_LIST_DIR})

# remember buildsystem binary root
set(BUILDSYS_BINARY_ROOT ${CMAKE_CURRENT_BINARY_DIR})

## set(SUPPORTED_PLATFORMS "Linux;Darwin;"
string(TOLOWER ${CMAKE_SYSTEM_NAME} SYSTEM_SUFFIX)
set(_PLATFORM_FILE "${BUILDSYS_ROOT}/macros/buildsys.${SYSTEM_SUFFIX}.cmake")
if(EXISTS ${_PLATFORM_FILE})
  include(${_PLATFORM_FILE})
else()
  message(FATAL_ERROR "Unsupported platform <${CMAKE_SYSTEM_NAME}> (missing file <${_PLATFORM_FILE}>).")
endif()

if(WIN32 AND MSVC)
  # get rid of bin/Release, bin/Debug, etc. subdirectories
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif()

macro(cpp_msvc_overrides)
  # enable intrinsic functions, favor faster code (instead of smaller code)
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/arch:AVX>)
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/Oi>)
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/Ot>)

  # disable security checks (stack buffer overrun prevention)
  add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELEASE>>:/GS->)
  add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELEASE>>:/O2>)
  add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELWITHDEBINFO>>:/GS->)
  add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELWITHDEBINFO>>:/O2>)

  # # disable warning: class 'type' needs to have dll-interface
  # #   to be used by clients of class 'type2'
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4251>)
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4275>)

  # # disable warning: conversion from 'type' to 'type2', possible loss of data
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4305>)
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4244>)
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4305>)

  # # disable warning: unary minus operator applied
  # #   to unsigned type, result still unsigned
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4146>)

  # disable warning: deprecated declaration
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4996>)

  # not enough arguments for function-like macro invocation
  # should be fixed in newer VC https://developercommunity.visualstudio.com/t/
  # standard-conforming-preprocessor-invalid-warning-c/364698
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/wd4003>)

  # strict warnings, all errors
  # TODO: allow W4 or Wall
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/W3>)
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/WX>)

  # disable external warnings
  # https://devblogs.microsoft.com/cppblog/broken-warnings-theory/
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/external:anglebrackets>)
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/external:W0>)
  # TODO(?): allow external warnings stemming from internal template init.
  # add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/external:templates->)

  # enable multi process compilation
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/MP>)

  # stricter conformance with c++ standard
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/permissive->)

  # avoid fatal error: number of sections exceeded object file format limit
  add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:/bigobj>)

  # disable linker warning: PDB (debug symbols) not found
  add_link_options(/ignore:4099)

  # eliminate unreferenced functions
  add_link_options(/OPT:REF)

  # not possible with /OPT:REF
  add_link_options(/INCREMENTAL:NO)

  # avoid some especially obtrusive macro definitions in windows.h
  add_definitions(/DWIN32_LEAN_AND_MEAN)
  add_definitions(/DNOMINMAX)
  add_definitions(/D_USE_MATH_DEFINES)
  add_definitions(/D_ENABLE_EXTENDED_ALIGNED_STORAGE)
  add_definitions(/D_CRT_SECURE_NO_WARNINGS)
endmacro()

# enable C++11
macro(enable_cpp11)
  if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror -pedantic-errors")
    if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 5.0)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    else()
      # old compilers, use C++0x
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-unused-function")

    if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 5.0)
      # compiler newer than 4.x
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-date-time")
    else()
      # 4.x or older
      set(BUILDSYS_LIMITED_CPP11 TRUE)
    endif()
    if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 6.0)
      # compiler newer than 5.x
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-misleading-indentation")
    endif()
    if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 6.0)
      # compiler newer than 8.x; needed by Eigen3
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-copy")
    endif()

    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--as-needed")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -Wno-conversion")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-missing-braces")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
    set(CMAKE_CXX_STANDARD 11)
    cpp_msvc_overrides()
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()
  message(STATUS "Enabled C++11 for C++ (${CMAKE_CXX_COMPILER_ID})")
endmacro()

# enable C11
macro(enable_c11)
  if (CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Werror -pedantic-errors")
    if(NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 5.0)
      # compiler newer than 4.x
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-date-time")
    endif()
  elseif (CMAKE_C_COMPILER_ID MATCHES Clang)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c1x")
  elseif (CMAKE_C_COMPILER_ID MATCHES MSVC)
    set(CMAKE_C_STANDARD 11)
    cpp_msvc_overrides()
  else()
    message(FATAL_ERROR "Unknown C compiler: ${CMAKE_C_COMPILER_ID}.")
  endif()
  message(STATUS "Enabled C11 for C (${CMAKE_C_COMPILER_ID})")
endmacro()

# enable C++14
macro(enable_cpp14)
  if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror -pedantic-errors")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -Wnon-virtual-dtor")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-date-time -Wno-misleading-indentation")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-function")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--as-needed")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -stdlib=libc++ -Wno-conversion")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-missing-braces")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
    set(CMAKE_CXX_STANDARD 14)
    cpp_msvc_overrides()
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()
  message(STATUS "Enabled C++14 for C++ (${CMAKE_CXX_COMPILER_ID})")
endmacro()

# enable C++17
macro(enable_cpp17)
  if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror -pedantic-errors")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -Wnon-virtual-dtor")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-date-time -Wno-misleading-indentation")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--as-needed")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -stdlib=libc++ -Wno-conversion")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-missing-braces")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
    set(CMAKE_CXX_STANDARD 17)
    cpp_msvc_overrides()
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()
  message(STATUS "Enabled C++17 for C++ (${CMAKE_CXX_COMPILER_ID})")
endmacro()

# enable visibility=hidden
macro(enable_hidden_visibility)
  set(CMAKE_C_VISIBILITY_PRESET hidden)
  set(CMAKE_CXX_VISIBILITY_PRESET hidden)
  set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)
endmacro()

macro(set_visibility TARGET VISIBILITY)
  if (${VISIBILITY} STREQUAL hidden)
    set(inline_hidden ON)
  else()
    set(inline_hidden OFF)
  endif()

  set_target_properties(${TARGET} PROPERTIES
    C_VISIBILITY_PRESET ${VISIBILITY}
    CXX_VISIBILITY_PRESET ${VISIBILITY}
    VISIBILITY_INLINES_HIDDEN ${inline_hidden})
endmacro()

macro(unset_visibility TARGET)
  # unseall all visibility-related flags
  set_property(TARGET ${TARGET} PROPERTY C_VISIBILITY_PRESET)
  set_property(TARGET ${TARGET} PROPERTY CXX_VISIBILITY_PRESET)
  set_property(TARGET ${TARGET} PROPERTY VISIBILITY_INLINES_HIDDEN)
endmacro()

macro(enable_threads)
  find_package(Threads REQUIRED)
  set(THREADS_LIBRARIES ${CMAKE_THREAD_LIBS_INIT})
endmacro()

macro(setup_project NAME VERSION)
  # obsoleted
  message(FATAL_ERROR "Use project(${NAME}) before including buildsys/cmake/buildsys.cmake")
endmacro()

macro(append_parent_directory_list_property PROPERTY)
  get_directory_property(PARENT_DIRECTORY
    DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    PARENT_DIRECTORY)

  set_property(DIRECTORY ${PARENT_DIRECTORY} APPEND
    PROPERTY ${PROPERTY} ${ARGN})
endmacro()

macro(append_parent_directory_property PROPERTY)
  get_directory_property(PARENT_DIRECTORY
    DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    PARENT_DIRECTORY)

  set_property(DIRECTORY ${PARENT_DIRECTORY} APPEND_STRING
    PROPERTY ${PROPERTY} ${ARGN})
endmacro()

# Set target version to ${VERSION} or ${VERSION}-${CMAKE_BUILD_TYPE}
macro(set_target_version TARGET VERSION)
  if (0)
  if (CMAKE_BUILD_TYPE)
    string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE)
    set_target_properties(${TARGET} PROPERTIES VERSION
      ${VERSION}-${BUILD_TYPE})
  else()
    set_target_properties(${TARGET} PROPERTIES VERSION
      ${VERSION})
  endif()
  endif()
  set_property(TARGET ${TARGET} APPEND
    PROPERTY COMPILE_DEFINITIONS
    BUILD_TARGET_VERSION=\"${VERSION}\"
    BUILD_TARGET_NAME=\"${TARGET}\")
endmacro()

macro(setup_build_system_overrides)
  # enable profiler if forced to
  if(BUILDSYS_FORCE_PROFILER)
    message(STATUS "Forcing GNU profiler.")
    set(INTERNAL_BUILDSYS_DISABLE_OPENMP TRUE)
    enable_profiler()
  else()
    set(INTERNAL_BUILDSYS_DISABLE_OPENMP FALSE)
  endif()
endmacro()

macro(setup_customer)
  string(TOUPPER "${CMAKE_BUILD_TYPE}" BT)
  if (BUILDSYS_CUSTOMER_BUILD_${BT})
    set(BUILDSYS_CUSTOMER_BUILD TRUE)
    if (NOT BUILDSYS_CUSTOMER)
      message(FATAL_ERROR "Custom build requested but no customer is set. "
        "Please, set BUILDSYS_CUSTOMER variable.")
    endif()
    add_definitions("-DBUILDSYS_CUSTOMER=\"${BUILDSYS_CUSTOMER}\"")
    message(STATUS "Custom build for '${BUILDSYS_CUSTOMER}'.")

    # create shell variable
    string(TOUPPER ${BUILDSYS_CUSTOMER} BUILDSYS_CUSTOMER_SHELL)
    string(REPLACE "-" "_" BUILDSYS_CUSTOMER_SHELL ${BUILDSYS_CUSTOMER_SHELL})
    string(REPLACE "." "_" BUILDSYS_CUSTOMER_SHELL ${BUILDSYS_CUSTOMER_SHELL})
  else()
    set(BUILDSYS_CUSTOMER_SHELL "")
  endif()
endmacro()

# setup common build system options
macro(setup_build_system)
  if (${PROJECT_NAME} STREQUAL Project)
    message(FATAL_ERROR "Use project(projecname) before including buildsys/cmake/buildsys.cmake")
  endif()

  # set default buildsys version
  if (NOT BUILDSYS_PACKAGE_VERSION)
    set(BUILDSYS_PACKAGE_VERSION "test")
  endif()

  message(STATUS "Setting up project <${PROJECT_NAME}>, version <${BUILDSYS_PACKAGE_VERSION}>.")
  set(${PROJECT_NAME}_VERSION ${BUILDSYS_PACKAGE_VERSION})

  if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
      "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel."
      FORCE)
    message(STATUS "*** Defaulting to ${CMAKE_BUILD_TYPE} build type.")
  else()
    message(STATUS "Build type: <${CMAKE_BUILD_TYPE}>.")
  endif()

  # pass build type to compiler
  string(TOUPPER "${CMAKE_BUILD_TYPE}" BT)
  add_definitions("-DCMAKE_BUILD_TYPE_${BT}=1")

  # add install prefix
  buildsys_compile_with_install_prefix()
  # add this directory to the modules path
  if(BUILDSYS_CONAN)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules.Conan)
  endif()
  if(WIN32)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules.Win32)
  else()
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules)
    if (CMAKE_VERSION VERSION_LESS 3.7)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules.xenial)
    endif()
  endif()

  if(NOT BUILDSYS_CPP_STANDARD)
    # fallback to cpp/c 11
    set(BUILDSYS_CPP_STANDARD 11)
  endif()

  if (BUILDSYS_CPP_STANDARD EQUAL 11)
    enable_cpp11()
  elseif (BUILDSYS_CPP_STANDARD EQUAL 14)
    enable_cpp14()
  elseif (BUILDSYS_CPP_STANDARD EQUAL 17)
    enable_cpp17()
  else()
    message(FATAL_ERROR "Unknown C++ standard ${BUILDSYS_CPP_STANDARD} requested.")
  endif()

  # C++ standard as a fake dependency
  set(C++_FOUND TRUE)
  set(C++_VERSION ${BUILDSYS_CPP_STANDARD})
  set(C++_LIBRARIES)
  set(C++_DEFINITION)

  # enable C11 by default
  enable_c11()
  enable_threads()

  if(CMAKE_Fortran_COMPILER)
    set(Fortran_FOUND TRUE)
    set(Fortran_VERSION 95)
    set(Fortran_LIBRARIES)
    set(Fortran_DEFINITION)
  endif()

  # setup include dirs
  include_directories(${CMAKE_CURRENT_BINARY_DIR})
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

  # operating system specific stuff
  setup_build_system_os_specific()

  # overrides
  setup_build_system_overrides()

  # customer setup
  setup_customer()
endmacro()

# find python2 binary to be used in tools
if (WIN32)
  find_package(Python2 COMPONENTS Interpreter)
  set(PYTHON3_BINARY ${Python2_EXECUTABLE})
  find_package(Python3 COMPONENTS Interpreter)
  set(PYTHON3_BINARY ${Python3_EXECUTABLE})
else()
  find_program(PYTHON2_BINARY python2)
  find_program(PYTHON3_BINARY python3)
endif()

if(PYTHON3_BINARY)
  set(PYTHON_BINARY ${PYTHON3_BINARY})
else()
  set(PYTHON_BINARY ${PYTHON2_BINARY})
endif()

if(NOT PYTHON_BINARY)
  message(FATAL_ERROR "Please install python2 and/or python3.")
else()
  message(STATUS "Using ${PYTHON_BINARY} as buildsys python.")
endif()

# load sub modules
foreach(submodule
    module
    profiler
    openmp
    cuda
    opencl
    opencv
    test
    legacy
    traceback
    hostname
    make-output-file
    install-conan-deps
    install-prefix
    output-paths
    python
    customer
    debug
    dict
    clone
    library-support
    opengl
    symlink-fixes
    tensorflow
    torch
    exclude-from-all

    build-types/release
    build-types/customerdebug
    build-types/customerrelease
    )
  include(${CMAKE_CURRENT_LIST_DIR}/macros/${submodule}.cmake)
endforeach()

# load tools
foreach(tool
    file2cpp
    sqlite32cpp
    py2cpp
    pathstrip
    ocl2cpp
    pandoc
    py-runnable
    compile-pyc
    )
  include(${CMAKE_CURRENT_LIST_DIR}/tools/${tool}/${tool}.cmake)
endforeach()

# ------------------------------------------------------------------------
# setup the build system now
# ------------------------------------------------------------------------
setup_build_system()


# ------------------------------------------------------------------------
# load extra project configuration if exists
# ------------------------------------------------------------------------

# main stuff
include(${CMAKE_SOURCE_DIR}/cmake/config.cmake OPTIONAL
  RESULT_VARIABLE file_included)
if(file_included)
  message(STATUS "Loaded configuration from ${file_included}.")
endif()

# customer stuff
if(BUILDSYS_CUSTOMER_BUILD)
  include(${CMAKE_SOURCE_DIR}/cmake/config.${BUILDSYS_CUSTOMER}.cmake
    OPTIONAL RESULT_VARIABLE file_included)
  if(file_included)
    message(STATUS "Loaded customer configuration from ${file_included}.")
  endif()
endif()

if(COMMAND buildsys_fix_sources)
  buildsys_fix_sources()
endif()
