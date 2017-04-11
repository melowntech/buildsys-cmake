# - Try to find READLINE
# Once done, this will define
#
#  READLINE_FOUND - system has READLINE
#  READLINE_INCLUDE_DIRS - the READLINE include directories
#  READLINE_LIBRARIES - link these to use READLINE

find_path(READLINE_INCLUDE_DIR
  NAMES readline/readline.h
  )

# Finally the library itself
find_library(READLINE_LIBRARY
  NAMES readline
  )

set(READLINE_INCLUDE_DIRS ${READLINE_INCLUDE_DIR})
set(READLINE_LIBRARIES ${READLINE_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Readline DEFAULT_MSG
  READLINE_LIBRARIES
  READLINE_INCLUDE_DIRS)
mark_as_advanced(READLINE_INCLUDE_DIR READLINE_LIBRARIES)
