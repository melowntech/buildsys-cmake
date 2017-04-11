# - Try to find HISTORY
# Once done, this will define
#
#  HISTORY_FOUND - system has HISTORY
#  HISTORY_INCLUDE_DIRS - the HISTORY include directories
#  HISTORY_LIBRARIES - link these to use HISTORY

find_path(HISTORY_INCLUDE_DIR
  NAMES history/history.h
  )

# Finally the library itself
find_library(HISTORY_LIBRARY
  NAMES history
  )

set(HISTORY_INCLUDE_DIRS ${HISTORY_INCLUDE_DIR})
set(HISTORY_LIBRARIES ${HISTORY_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(History DEFAULT_MSG
  HISTORY_LIBRARIES
  HISTORY_INCLUDE_DIRS)
mark_as_advanced(HISTORY_INCLUDE_DIR HISTORY_LIBRARIES)
