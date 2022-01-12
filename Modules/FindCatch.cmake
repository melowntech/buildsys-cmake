# - Try to find CATCH library
# Once done, this will define
#
#  CATCH_FOUND - system has CATCH
#  CATCH_INCLUDE_DIRS - the CATCH include directories
#  CATCH_VERSION - version of the CATCH library

find_path(CATCH_INCLUDE_DIR
    NAMES
	catch.hpp
)

if(CATCH_INCLUDE_DIR)
  file(
    STRINGS
        ${CATCH_INCLUDE_DIR}/catch.hpp
    CATCH_VERSION_STRING
    REGEX
        "[ ]+Catch[ ]+v([0-9]*\\.[0-9]*\\.[0-9]*)"
    LIMIT_COUNT 1
  )

  string(
    REGEX REPLACE
    ".*[ ]+Catch[ ]+v([0-9]*\\.[0-9]*\\.[0-9]*)"
    "\\1"
    CATCH_VERSION
    "${CATCH_VERSION_STRING}"
  )
endif()

set(CATCH_INCLUDE_DIRS ${CATCH_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Catch
    REQUIRED_VARS
        CATCH_INCLUDE_DIRS
    VERSION_VAR
        CATCH_VERSION
)
mark_as_advanced(CATCH_INCLUDE_DIR)
