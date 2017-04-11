# - Try to find Sqlite3
# Once done, this will define
#
#  Sqlite3_FOUND - system has Sqlite3
#  Sqlite3_INCLUDE_DIRS - the Sqlite3 include directories
#  Sqlite3_LIBRARIES - link these to use Sqlite3
#  Sqlite3_PROGRAM - path to sqlite3 binary

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(Sqlite3_PKGCONF QUIET tinyxml2)

find_path(Sqlite3_INCLUDE_DIR
  NAMES sqlite3.h
  PATHS ${Sqlite3_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(Sqlite3_LIBRARY
  NAMES sqlite3
  PATHS ${Sqlite3_PKGCONF_LIBRARY_DIRS}
)

find_program(Sqlite3_PROGRAM
  sqlite3)

set(Sqlite3_INCLUDE_DIRS ${Sqlite3_INCLUDE_DIR})
set(Sqlite3_LIBRARIES ${Sqlite3_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Sqlite3
  FOUND_VAR Sqlite3_FOUND
  REQUIRED_VARS
  Sqlite3_LIBRARIES
  Sqlite3_INCLUDE_DIRS
  Sqlite3_PROGRAM)
mark_as_advanced(Sqlite3_INCLUDE_DIR Sqlite3_LIBRARIES Sqlite3_PROGRAM)
