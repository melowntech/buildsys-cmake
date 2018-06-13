# buildsystem as a dependency: fake dependency (e.g. BuildSystem>=1.0)
set(BuildSystem_VERSION 1.0)
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
  message(FATAL_ERROR "Unsupported platform <${CMAKE_SYSTEM_NAME}>.")
endif()

# enable C++11
macro(enable_cpp11)
  if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    add_definitions(-Wall -Wextra -Werror -pedantic-errors)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -Wnon-virtual-dtor -Wno-unused-function")
    if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 5.0)
      # compiler newer than 4.x
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-date-time -Wno-misleading-indentation")
    endif()
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--as-needed")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -Wno-conversion")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
    set(CMAKE_CXX_STANDARD 11)
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()
  message(STATUS "Enabled C++11 for C++ (${CMAKE_CXX_COMPILER_ID})")
endmacro()

# enable C11
macro(enable_c11)
  if (CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c1x")
    if(NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 5.0)
      # compiler newer than 4.x
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-date-time")
    endif()
  elseif (CMAKE_C_COMPILER_ID MATCHES Clang)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c1x")
  elseif (CMAKE_C_COMPILER_ID MATCHES MSVC)
    set(CMAKE_C_STANDARD 11)
  else()
    message(FATAL_ERROR "Unknown C compiler: CMAKE_C_COMPILER_ID.")
  endif()
  message(STATUS "Enabled C11 for C (${CMAKE_C_COMPILER_ID})")
endmacro()

# enable C++14
macro(enable_cpp14)
  if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    add_definitions(-Wall -Wextra -Werror -pedantic-errors)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -Wnon-virtual-dtor")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-date-time -Wno-misleading-indentation")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--as-needed")
    message(STATUS "Enabled C++14 for C++ (${CMAKE_CXX_COMPILER_ID})")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -stdlib=libc++ -Wno-conversion")
    message(STATUS "Enabled C++14 for C++ (${CMAKE_CXX_COMPILER_ID})")
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()
endmacro()

# enable C++17
macro(enable_cpp17)
  if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    add_definitions(-Wall -Wextra -Werror -pedantic-errors)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -Wnon-virtual-dtor")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-date-time -Wno-misleading-indentation")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--as-needed")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--as-needed")
    message(STATUS "Enabled C++17 for C++ (${CMAKE_CXX_COMPILER_ID})")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -stdlib=libc++ -Wno-conversion")
    message(STATUS "Enabled C++17 for C++ (${CMAKE_CXX_COMPILER_ID})")
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()
endmacro()

# enable visibility=hidden
macro(enable_hidden_visibility)
  if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
    message(STATUS "Enabled hidden visibility for C++ (${CMAKE_CXX_COMPILER_ID})")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
    message(STATUS "Enabled hidden visibility for C++ (${CMAKE_CXX_COMPILER_ID})")
  elseif (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
    message(STATUS "For (${CMAKE_CXX_COMPILER_ID}), symbol visibility is controlled explicitly in code.")
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()

  if (CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
    message(STATUS "Enabled hidden visibility for C (${CMAKE_C_COMPILER_ID})")
  elseif (CMAKE_C_COMPILER_ID MATCHES Clang)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
    message(STATUS "Enabled hidden visibility for C (${CMAKE_C_COMPILER_ID})")
  elseif (CMAKE_C_COMPILER_ID MATCHES MSVC)
    message(STATUS "For (${CMAKE_C_COMPILER_ID}), symbol visibility is controlled explicitly in code.")
  else()
    message(FATAL_ERROR "Unknown C compiler: ${CMAKE_C_COMPILER_ID}.")
  endif()
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
  if(WIN32)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules.Win32)
  else()
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules)
  endif()

  if(BUILDSYS_CPP_STANDARD)
    if (BUILDSYS_CPP_STANDARD EQUAL 11)
      enable_cpp11()
    elseif (BUILDSYS_CPP_STANDARD EQUAL 14)
      enable_cpp14()
    elseif (BUILDSYS_CPP_STANDARD EQUAL 17)
      enable_cpp17()
    else()
      message(FATAL_ERROR "Unknown C++ standard ${BUILDSYS_CPP_STANDARD} requested.")
    endif()
  else()
    # fallback to cpp/c 11
    enable_cpp11()
  endif()

  # enable C11 by default
  enable_c11()
  enable_threads()

  # apply architecture
  if(ARCHITECTURE)
    set_architecture(${ARCHITECTURE})
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
  # on windows, search for python without version
  find_program(PYTHON2_BINARY python)
else()
  find_program(PYTHON2_BINARY python2)
  find_program(PYTHON3_BINARY python3)
endif()
if(NOT PYTHON2_BINARY)
  message(FATAL_ERROR "Please install python2.")
endif()

# load sub modules
foreach(submodule
    architecture
    module
    profiler
    openmp
    cuda
    opencl
    test
    legacy
    traceback
    hostname
    make-output-file
    install-prefix
    output-paths
    python
    compile-definitions
    customer
    debug
    dict
    clone
    library-support
    opengl
    symlink-fixes

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
    makerunnable
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
