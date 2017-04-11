# - Try to find MYSQL++
# Once done, this will define
#
#  MYSQL++_FOUND - system has MYSQL++
#  MYSQL++_INCLUDE_DIRS - the MYSQL++ include directories
#  MYSQL++_LIBRARIES - link these to use MYSQL++

find_path(MYSQL++_INCLUDE_DIR
  NAMES mysql++/mysql++.h
)

# Finally the library itself
find_library(MYSQL++_LIBRARY
  NAMES mysqlpp
)

set(MYSQL++_INCLUDE_DIRS ${MYSQL++_INCLUDE_DIR})
set(MYSQL++_LIBRARIES ${MYSQL++_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MySQL++ DEFAULT_MSG
  MYSQL++_LIBRARIES
  MYSQL++_INCLUDE_DIRS)
mark_as_advanced(MYSQL++_INCLUDE_DIR MYSQL++_LIBRARIES)
