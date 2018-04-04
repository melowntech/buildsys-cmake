# Update Release build type

if(NOT WIN32)
  if(NOT BUILDSYS_RELEASE_NDEBUG)
    message(STATUS "Release mode: Compiling with debug symbols by default. To disable set the BUILDSYS_RELEASE_NDEBUG variable.")
    # update definitions
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g")
  else()
    message(STATUS "Release mode: Not compiling with debug symbols as instructed.")
  endif()
endif()
