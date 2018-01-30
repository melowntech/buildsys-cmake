macro(enable_openGL_impl_pre_3_10)
  find_package(OpenGL REQUIRED)

  foreach(lib ${ARGN})
    set(lib_name OPENGL_${lib}_LIBRARY)
    find_library(${lib_name} NAMES ${lib})
    if (${${lib_name}} STREQUAL ${lib_name}-NOTFOUND)
      message(FATAL_ERROR "OpenGL library ${lib} was not found.")
    endif()

    message(STATUS "Found OpenGL library ${lib}: ${${lib_name}}")

    # set(${lib_name} ${${lib_name}} )
    set(OPENGL_${lib}_FOUND TRUE)
    add_library(OpenGL::${lib} UNKNOWN IMPORTED)
    set_target_properties(OpenGL::${lib} PROPERTIES IMPORTED_LOCATION
      "${${lib_name}}")
  endforeach()
endmacro()

macro(enable_openGL_impl)
  find_package(OpenGL REQUIRED)
  if(CMAKE_VERSION VERSION_LESS 3.10)
    enable_openGL_impl_pre_3_10(${ARGN})
  else()
    # TODO: update when 3.10 is ready
    find_package(OpenGL REQUIRED)
  endif()
endmacro()

macro(enable_opengl)
  if(NOT BUILDSYS_DISABLE_OPENGL)
    enable_opengl_impl(${ARGN})
    message(STATUS "Enabling OpenGL support (can be disabled by setting BUILDSYS_DISABLE_OPENGL variable).")
  else()
    message(STATUS "Disabling OpenGL support because of BUILDSYS_DISABLE_OPENGL.")
  endif()
endmacro()
