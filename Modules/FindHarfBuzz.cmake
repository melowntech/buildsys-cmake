# - Try to find HarfBuzz
# Once done this will define
#
# HARFBUZZ_FOUND        - system has HarfBuzz
# HARFBUZZ_INCLUDE_DIR  - the HarfBuzz include directory
# HARFBUZZ_LIBRARIES    - Link these to use HarfBuzz
# HARFBUZZ_LIBRARY_DIR  - Library DIR of HarfBuzz
#

find_path(HARFBUZZ_INCLUDE_DIR harfbuzz/hb.h
  HINTS ${PC_HARFBUZZ_INCLUDE_DIRS} ${PC_HARFBUZZ_INCLUDEDIR}
)

set(HARFBUZZ_INCLUDE_DIRS ${HARFBUZZ_INCLUDE_DIR})

# Finally libraries
find_library(HARFBUZZ_LIBRARIES NAMES harfbuzz libharfbuzz
  HINTS ${PC_HARFBUZZ_LIBRARY_DIRS} ${PC_HARFBUZZ_LIBDIR}
  )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(HarfBuzz DEFAULT_MSG
  HARFBUZZ_LIBRARIES
  HARFBUZZ_INCLUDE_DIRS)
mark_as_advanced(HARFBUZZ_INCLUDE_DIR HARFBUZZ_LIBRARIES)


#if (HARFBUZZ_FOUND)
#  add_library(harfbuzz UNKNOWN IMPORTED)
#  set_target_properties(harfbuzz PROPERTIES IMPORTED_LOCATION ${HARFBUZZ_LIBRARIES})
#  set_target_properties(harfbuzz PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${HARFBUZZ_INCLUDE_DIRS})
#endif()

