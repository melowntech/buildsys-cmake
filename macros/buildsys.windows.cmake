# Windows specific stuff goes here

message(STATUS "Configuring build system on Windows machine")

macro(setup_build_system_os_specific)
  find_package(PowerShell REQUIRED)
endmacro()

macro(buildsys_fix_sources)
  message(STATUS "fixing sources on windows")
  execute_process(COMMAND ${POWERSHELL_COMMAND}
    "${BUILDSYS_ROOT}/macros/scripts/windows-fix-symlinks.ps1"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src)
endmacro()
