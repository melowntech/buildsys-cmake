# Create custom build type: Customerrelease

# cloned from Release
set(CMAKE_CXX_FLAGS_CUSTOMERRELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_CUSTOMERRELEASE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_EXE_LINKER_FLAGS_CUSTOMERRELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")

cmake_policy(GET CMP0043 CMP0043)
if(CMP0043 STREQUAL OLD)
  # Old way:
  # clone definitions from Release and add custom definitions
  get_property(defs DIRECTORY PROPERTY COMPILE_DEFINITIONS_RELEASE)
  set_property(DIRECTORY PROPERTY COMPILE_DEFINITIONS_CUSTOMERRELEASE ${defs}
    BUILDSYS_CUSTOMER_BUILD=1)
else()
  # use generator
  # there are probably no compile definitions for Release (yet)
  set_property(DIRECTORY APPEND PROPERTY
    COMPILE_DEFINITIONS $<$<CONFIG:CustomerRelease>:BUILDSYS_CUSTOMER_BUILD=1>
    )
endif()

set(BUILDSYS_CUSTOMER_BUILD_CUSTOMERRELEASE TRUE)
