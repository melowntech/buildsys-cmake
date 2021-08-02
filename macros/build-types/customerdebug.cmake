# Create custom build type: Customerdebug

# cloned from Debug
set(CMAKE_CXX_FLAGS_CUSTOMERDEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_C_FLAGS_CUSTOMERDEBUG "${CMAKE_C_FLAGS_DEBUG}")
set(CMAKE_EXE_LINKER_FLAGS_CUSTOMERDEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}")

cmake_policy(GET CMP0043 CMP0043)
if(CMP0043 STREQUAL OLD)
  # Old way:
  # clone definitions from Debug and add custom definitions
  get_property(defs DIRECTORY PROPERTY COMPILE_DEFINITIONS_DEBUG)
  set_property(DIRECTORY PROPERTY COMPILE_DEFINITIONS_CUSTOMERDEBUG ${defs}
    BUILDSYS_CUSTOMER_BUILD=1)
else()
  # use generator
  # there are probably no compile definitions for Release (yet)
  set_property(DIRECTORY APPEND PROPERTY
    COMPILE_DEFINITIONS $<$<CONFIG:CustomerDebug>:BUILDSYS_CUSTOMER_BUILD=1>
    )
endif()

set(BUILDSYS_CUSTOMER_BUILD_CUSTOMERDEBUG TRUE)
