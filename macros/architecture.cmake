set(ARCHITECTURE ""
  CACHE STRING "Target achitecture (default=not set)")

macro(set_architecture architecture)
  if (${CMAKE_CXX_COMPILER_ID} MATCHES GNU
      OR ${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=${architecture}")
    message(STATUS "Compiling C++ code for ${architecture}")
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()

  if (${CMAKE_C_COMPILER_ID} MATCHES GNU
      OR ${CMAKE_C_COMPILER_ID} MATCHES Clang)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=${architecture}")
    message(STATUS "Compiling C code for ${architecture}")
  else()
    message(FATAL_ERROR "Unknown C compiler: ${CMAKE_C_COMPILER_ID}.")
  endif()
endmacro()
