# Windows specific stuff goes here

message(STATUS "Configuring build system on Windows machine")

macro(setup_build_system_os_specific)
  # find powershell
  find_package(PowerShell REQUIRED)

  # damn you, MSVC!
  add_definitions(-DWIN32_LEAN_AND_MEAN)
  add_definitions(-DNOGDI)
  add_definitions(-DNOMINMAX)
  add_definitions(-D_USE_MATH_DEFINES)
  add_definitions(-D_ENABLE_EXTENDED_ALIGNED_STORAGE)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)

  if (CMAKE_GENERATOR STREQUAL "Ninja")
    configure_file(
      ${BUILDSYS_ROOT}/manifest/windows.manifest 
      ${CMAKE_CURRENT_BINARY_DIR}/windows.manifest
    )
  else()
    # use manifest file
    add_link_options(
      "LINKER:/MANIFEST:EMBED" 
      "LINKER:/MANIFESTINPUT:${BUILDSYS_ROOT}/manifest/windows.manifest"
    )
  endif()
endmacro()

set(BUILDSYS_SYMLINKS_FIX_SCRIPT
  "${BUILDSYS_ROOT}/macros/scripts/windows-fix-symlinks.ps1"
  CACHE STRING "Path to script used for fixing symlinks mismatches on windows")

macro(buildsys_fix_symlinks_platform directory)
  message(STATUS "Fixing symlinks in directory ${directory}")

  execute_process(COMMAND ${POWERSHELL_COMMAND}
    "\"${BUILDSYS_SYMLINKS_FIX_SCRIPT}\""
    WORKING_DIRECTORY ${directory}
    RESULT_VARIABLE result)

  if(NOT result STREQUAL "0")
    message(FATAL_ERROR "Cannot fix symlinks.")
  endif()
endmacro(buildsys_fix_symlinks_platform)

macro(buildsys_fix_sources)
  buildsys_fix_symlinks_platform(${CMAKE_CURRENT_SOURCE_DIR}/src)
endmacro()
