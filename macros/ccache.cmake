macro(enable_ccache)
  find_program(CCACHE_BINARY ccache)

  if (CCACHE_BINARY)
    message(STATUS "Using ccache for compilation.")
    add_definitions(-DWITH_CCACHE)
    
    if (UNIX OR (WIN32 AND CMAKE_GENERATOR STREQUAL "Ninja"))
      # if (WIN32)
      #   set(CMAKE_NINJA_FORCE_RESPONSE_FILE ON)
      # endif()
      set(CMAKE_C_COMPILER_LAUNCHER ${CCACHE_BINARY})
      set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE_BINARY})
      set(CMAKE_CUDA_COMPILER_LAUNCHER ${CCACHE_BINARY})
    elseif(WIN32)
      # https://github.com/ccache/ccache/wiki/MS-Visual-Studio
      # Note: /Zi debug info is not supported, use /Z7
      file(COPY_FILE
        ${CCACHE_BINARY} ${CMAKE_BINARY_DIR}/cl.exe
        ONLY_IF_DIFFERENT
      )
      set(CMAKE_VS_GLOBALS
        "CLToolExe=cl.exe"
        "CLToolPath=${CMAKE_BINARY_DIR}"
        "TrackFileAccess=false"
        "UseMultiToolTask=true"
        "DebugInformationFormat=OldStyle"
      )
    endif()
  else()
    message(WARNING "Unable to find ccache for compilation.")
  endif()

endmacro()
