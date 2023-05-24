macro(enable_OpenMP_impl)
  find_package(OpenMP)

  if(OPENMP_FOUND)
    message(STATUS "Found OpenMP.")
    if (TARGET OpenMP::OpenMP_C)
      link_libraries(OpenMP::OpenMP_C)
    endif()
    if (TARGET OpenMP::OpenMP_CXX)
      link_libraries(OpenMP::OpenMP_CXX)
    endif()
    if (TARGET OpenMP::Fortran)
      link_libraries(OpenMP::Fortran)
    endif()

    if(NOT OpenMP_FOUND)
      # for compatibility with older cmake version
      set(OpenMP_FOUND TRUE)
    endif()
  else()
    message(STATUS "OpenMP not available. Your program will lack parallelism.")
  endif()
endmacro()

macro(enable_OpenMP_win_experimental)
  if (OPENMP_FOUND AND WIN32)
    if (TARGET OpenMP::OpenMP_CXX)
      message(STATUS "Using OpenMP::OpenMP_CXX with /openmp:llvm -openmp:experimental.")

      get_target_property(WIN_OMP_COMPILE_OPTIONS OpenMP::OpenMP_CXX INTERFACE_COMPILE_OPTIONS)
      string(REPLACE "-openmp" "/openmp:llvm -openmp:experimental" WIN_OMP_COMPILE_OPTIONS ${WIN_OMP_COMPILE_OPTIONS})
      set_target_properties(OpenMP::OpenMP_CXX PROPERTIES INTERFACE_COMPILE_OPTIONS ${WIN_OMP_COMPILE_OPTIONS})

      get_target_property(WIN_OMP_LINK_OPTIONS OpenMP::OpenMP_CXX INTERFACE_LINK_OPTIONS)
      string(REPLACE "-openmp" "/openmp:llvm -openmp:experimental" INTERFACE_LINK_OPTIONS ${WIN_OMP_LINK_OPTIONS})
      set_target_properties(OpenMP::OpenMP_CXX PROPERTIES INTERFACE_LINK_OPTIONS ${INTERFACE_LINK_OPTIONS})
    endif()

    if (TARGET OpenMP::OpenMP_C)
      message(STATUS "Using OpenMP::OpenMP_C with /openmp:llvm -openmp:experimental.")

      get_target_property(WIN_OMP_COMPILE_OPTIONS OpenMP::OpenMP_C INTERFACE_COMPILE_OPTIONS)
      string(REPLACE "-openmp" "/openmp:llvm -openmp:experimental" WIN_OMP_COMPILE_OPTIONS ${WIN_OMP_COMPILE_OPTIONS})
      set_target_properties(OpenMP::OpenMP_C PROPERTIES INTERFACE_COMPILE_OPTIONS ${WIN_OMP_COMPILE_OPTIONS})

      get_target_property(WIN_OMP_LINK_OPTIONS OpenMP::OpenMP_C INTERFACE_LINK_OPTIONS)
      string(REPLACE "-openmp" "/openmp:llvm -openmp:experimental" INTERFACE_LINK_OPTIONS ${WIN_OMP_LINK_OPTIONS})
      set_target_properties(OpenMP::OpenMP_C PROPERTIES INTERFACE_LINK_OPTIONS ${INTERFACE_LINK_OPTIONS})
    endif()

  endif()
endmacro()

option(BUILDSYS_DISABLE_OPENMP "Disable OpenMP support" OFF)
option(BUILDSYS_WIN_OPENMP_EXPERIMENTAL "Enable experimental OpenMP support for Windows" OFF)

macro(enable_OpenMP)
  set(enable TRUE)

  if(BUILDSYS_DISABLE_OPENMP)
    set(enable FALSE)
  elseif(INTERNAL_BUILDSYS_DISABLE_OPENMP)
    set(enable FALSE)
  endif()

  if(enable)
    enable_OpenMP_impl()
    if (BUILDSYS_WIN_OPENMP_EXPERIMENTAL)
      enable_OpenMP_win_experimental()
      add_compile_definitions(_WIN_OMP_EXPERIMENTAL)
    endif()
  else()
    message(STATUS "Disabling OpenMP support because of BUILDSYS_DISABLE_OPENMP.")
  endif()
endmacro()
