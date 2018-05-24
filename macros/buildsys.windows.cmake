# Windows specific stuff goes here

message(STATUS "Configuring build system on Windows machine")

macro(setup_build_system_os_specific)
  # find powershell
  find_package(PowerShell REQUIRED)

  # damn you, MSVC!
  add_definitions(-D_USE_MATH_DEFINES)
  add_definitions(-DNOMINMAX)

  # noway
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endmacro()

macro(buildsys_fix_symlinks_platform directory)
  message(STATUS "Fixing symlinks in directory ${directory}")

  execute_process(COMMAND ${POWERSHELL_COMMAND}
    "\"${BUILDSYS_ROOT}/macros/scripts/windows-fix-symlinks.ps1\""
    WORKING_DIRECTORY ${directory}
    RESULT_VARIABLE result)

  if(NOT result STREQUAL "0")
    message(FATAL_ERROR "Cannot fix symlinks.")
  endif()
endmacro(buildsys_fix_symlinks_platform)

macro(buildsys_fix_sources)
  buildsys_fix_symlinks_platform(${CMAKE_CURRENT_SOURCE_DIR}/src)
endmacro()
