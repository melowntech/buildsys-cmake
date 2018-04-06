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

macro(buildsys_fix_sources)
  message(STATUS "fixing sources on windows")
  execute_process(COMMAND ${POWERSHELL_COMMAND}
    "${BUILDSYS_ROOT}/macros/scripts/windows-fix-symlinks.ps1"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src)
endmacro()
