macro(enable_profiler)
  if (${CMAKE_CXX_COMPILER_ID} MATCHES GNU
      OR ${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
    message(STATUS "Building profile binaries (C++).")
  else()
    message(FATAL_ERROR "Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()

  if (${CMAKE_C_COMPILER_ID} MATCHES GNU
      OR ${CMAKE_C_COMPILER_ID} MATCHES Clang)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg")
    message(STATUS "Building profile binaries (C).")
  else()
    message(FATAL_ERROR "Unknown C compiler: ${CMAKE_C_COMPILER_ID}.")
  endif()
endmacro()

macro(enable_google_profiler)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-as-needed -lprofiler")
endmacro()
