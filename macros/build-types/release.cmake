# Update Release build type

option(BUILDSYS_RELEASE_NDEBUG "Compile release without debug symbols" OFF)

if(NOT BUILDSYS_EMBEDDED)
  if(NOT BUILDSYS_RELEASE_NDEBUG)
    message(STATUS "Release mode: Compiling with debug symbols by default. To disable set the BUILDSYS_RELEASE_NDEBUG variable.")
    if (MSVC)
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX,Fortran>,$<CONFIG:RELEASE>>:/DEBUG>)
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:RELEASE>>:-g>)
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:RELEASE>>:-G>)
    else()
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX,Fortran>,$<CONFIG:RELEASE>>:-g>)
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:RELEASE>>:-g>)
      add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:RELEASE>>:-G>)
    endif()
  else()
    message(STATUS "Release mode: Not compiling with debug symbols as instructed.")
  endif()
endif()
