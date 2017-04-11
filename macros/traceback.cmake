macro(enable_traceback)
  if (IS_DIRECTORY "${CMAKE_SOURCE_DIR}/src/cpp-traceback/")
    # OK
  else()
    # warn
    message(STATUS "cpp-traceback module not present, compiling without "
      "traceback support")
    return()
  endif()

  add_subdirectory(src/cpp-traceback)

  if (${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -rdynamic")
  elseif (${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -rdynamic")
  else()
    message(STATUS "traceback: Unknown C++ compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()

  # add cpp-traceback to all binaries
  list(APPEND BINARY_MODULES_LINK_LIBRARIES cpp-traceback)

  # tell that we use traceback
  add_definitions(-DHAS_CPP_TRACEBACK)
endmacro()
