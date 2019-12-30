# - Try to find glog
# Once done, this will define
#
#  GLOG_FOUND - system has glog library
#  GLOG_INCLUDE_DIRS - the glog include directories
#  GLOG_LIBRARIES - link these to use Glog library

find_path(GLOG_INCLUDE_DIR
  NAMES glog/logging.h
  )

# Finally the library itself
find_library(GLOG_LIBRARY
  NAMES glog
  )

set(GLOG_INCLUDE_DIRS ${GLOG_INCLUDE_DIR})
set(GLOG_LIBRARIES ${GLOG_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(glog DEFAULT_MSG
  GLOG_LIBRARIES
  GLOG_INCLUDE_DIRS)
mark_as_advanced(GLOG_INCLUDE_DIR GLOG_LIBRARIES)
