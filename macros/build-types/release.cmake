# Update Release build type

option(BUILDSYS_RELEASE_NDEBUG "Compile release without debug symbols" OFF)

if(NOT BUILDSYS_EMBEDDED)
  if(NOT BUILDSYS_RELEASE_NDEBUG)
    message(STATUS "Release mode: Compiling with debug symbols by default. To disable set the BUILDSYS_RELEASE_NDEBUG variable.")
    if (MSVC)
      # Note: /Zi is not compatible with CCache
      # - https://github.com/ccache/ccache/wiki/MS-Visual-Studio
      # - https://github.com/ccache/ccache/issues/1040
      # add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX,Fortran>,$<CONFIG:Release>>:/Zi>)
      set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT $<$<CONFIG:Debug,RelWithDebInfo,Release>:Embedded> CACHE STRING "" FORCE) #/Z7
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX,Fortran>,$<CONFIG:Release>>:/Z7>)
      add_link_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX,Fortran>,$<CONFIG:Release>>:/debug>)
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:Release>>:-g>)
      # add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:Release>>:-G>) # Note: this turns off all optimizations
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:Release>>:-lineinfo>)
    else()
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX,Fortran>,$<CONFIG:Release>>:-g>)
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:Release>>:-g>)
      # add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:Release>>:-G>) # Note: this turns off all optimizations
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:Release>>:-lineinfo>)
    endif()
  else()
    message(STATUS "Release mode: Not compiling with debug symbols as instructed.")
  endif()
endif()
