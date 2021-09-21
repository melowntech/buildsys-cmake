# Try to find Cbc (https://projects.coin-or.org/Cbc)
# Once done, this will define
#
#  Cbc_FOUND - system has Cbc libraries
#  Cbc_INCLUDE_DIRS - the Cbc include directories
#  Cbc_LIBRARIES - link these to use Cbc libraries

find_path(Cbc_INCLUDE_DIR
  NAMES coin/CbcConfig.h
  )

find_library(Osi_LIBRARY
  NAMES Osi
  )

find_library(CoinUtils_LIBRARY
  NAMES CoinUtils
  )

find_library(OsiClp_LIBRARY
  NAMES OsiClp
  )

find_library(Cbc_LIBRARY
  NAMES Cbc
  )

set(Cbc_INCLUDE_DIRS ${Cbc_INCLUDE_DIR})
set(Cbc_LIBRARIES ${Osi_LIBRARY} ${CoinUtils_LIBRARY} ${Cbc_LIBRARY} ${OsiClp_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cbc; DEFAULT_MSG
  Cbc_LIBRARIES
  Cbc_INCLUDE_DIRS)
mark_as_advanced(CBC_INCLUDE_DIRS CBC_LIBRARIES)
