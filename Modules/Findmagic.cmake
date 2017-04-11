# - Try to find MAGIC
# Once done, this will define
#
#  MAGIC_FOUND - system has MAGIC
#  MAGIC_INCLUDE_DIRS - the MAGIC include directories
#  MAGIC_LIBRARIES - link these to use MAGIC

find_path(MAGIC_INCLUDE_DIR
  NAMES magic.h
)

# Finally the library itself
find_library(MAGIC_LIBRARY
  NAMES magic
)

set(MAGIC_INCLUDE_DIRS ${MAGIC_INCLUDE_DIR})
set(MAGIC_LIBRARIES ${MAGIC_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(magic DEFAULT_MSG
  MAGIC_LIBRARIES
  MAGIC_INCLUDE_DIRS)
mark_as_advanced(MAGIC_INCLUDE_DIR MAGIC_LIBRARIES)
