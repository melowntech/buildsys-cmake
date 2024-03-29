macro(enable_ccache)
  if (DEFINED ENV{DEB_RELEASE} AND (NOT "$ENV{DEB_NO_SIGN}" STREQUAL "YES"))
    message(STATUS "Not using ccache for compilation (building signed deb package).")
  else()
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
        # Note: /Zi debug info is not supported, use /Z7 (https://github.com/ccache/ccache/issues/1040)
        add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C,CXX,Fortran>,$<CONFIG:Debug,RelWithDebInfo>>:/Z7>)
        set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT $<$<CONFIG:Debug,RelWithDebInfo>:Embedded>) # /Z7
      endif()
    else()
      message(WARNING "Unable to find ccache for compilation.")
    endif()
  endif()
endmacro()
