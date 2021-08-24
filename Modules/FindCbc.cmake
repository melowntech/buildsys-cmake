# Try to find Cbc (https://projects.coin-or.org/Cbc)
# Once done, this will define
#
#  CBC_FOUND - system has Cbc library
#  CBC_INCLUDE_DIRS - the Cbc include directories
#  CBC_LIBRARIES - link these to use Cbc library

find_path(CBC_INCLUDE_DIR
  NAMES coin/CbcConfig.h
  )

find_library(CBC_LIBRARY
  NAMES Cbc
  )

find_library(OSICLP_LIBRARY
  NAMES OsiClp
  )

set(CBC_INCLUDE_DIRS ${CBC_INCLUDE_DIR})
set(CBC_LIBRARIES ${CBC_LIBRARY} ${OSICLP_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cbc; DEFAULT_MSG
  CBC_LIBRARIES
  CBC_INCLUDE_DIRS)
mark_as_advanced(CBC_INCLUDE_DIRS CBC_LIBRARIES)
