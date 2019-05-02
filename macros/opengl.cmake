macro(enable_openGL_impl_pre_3_10)
  find_package(OpenGL REQUIRED)

  foreach(lib ${ARGN})
    set(lib_name OPENGL_${lib}_LIBRARY)
    if (NOT TARGET OpenGL::${lib})
      find_library(${lib_name} NAMES ${lib})
      if (NOT ${lib_name})
        message(FATAL_ERROR "OpenGL library ${lib} was not found.")
      endif()

      add_library(OpenGL::${lib} UNKNOWN IMPORTED)
      set_target_properties(OpenGL::${lib} PROPERTIES IMPORTED_LOCATION
        "${${lib_name}}")

      message(STATUS "Found OpenGL library ${lib}: ${${lib_name}}; "
        "using as target OpenGL::${lib}.")
    else()
      message(STATUS "Using OpenGL library target OpenGL::${lib}.")
    endif()
  endforeach()
endmacro()

macro(enable_openGL_impl)
  if(CMAKE_VERSION VERSION_LESS 3.10)
    find_package(OpenGL REQUIRED)
    enable_openGL_impl_pre_3_10(${ARGN})
  else()
    # TODO: update when 3.11 is ready
    find_package(OpenGL REQUIRED COMPONENTS ${ARGN})
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
