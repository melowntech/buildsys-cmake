# - Try to find LIBPROC
# Once done, this will define
#
#  LIBPROC_FOUND - system has LIBPROC
#  LIBPROC_INCLUDE_DIRS - the LIBPROC include directories
#  LIBPROC_LIBRARIES - link these to use LIBPROC

find_path(LIBPROC_INCLUDE_DIR
  NAMES proc/readproc.h
  )

# Finally the library itself
find_library(LIBPROC_LIBRARY
  NAMES procps
  )

set(LIBPROC_INCLUDE_DIRS ${LIBPROC_INCLUDE_DIR})
set(LIBPROC_LIBRARIES ${LIBPROC_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibProc DEFAULT_MSG
  LIBPROC_LIBRARIES
  LIBPROC_INCLUDE_DIRS)
mark_as_advanced(LIBPROC_INCLUDE_DIR LIBPROC_LIBRARIES)
