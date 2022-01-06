# Try to find Cbc (https://projects.coin-or.org/Cbc)
# Once done, this will define
#
#  Cbc_FOUND - system has Cbc libraries
#  Cbc_INCLUDE_DIRS - the Cbc include directories
#  Cbc_LIBRARIES - link these to use Cbc libraries

find_package(PkgConfig)
pkg_check_modules(Cbc_PKGCONF QUIET cbc)

set(Cbc_INCLUDE_DIRS ${Cbc_PKGCONF_INCLUDE_DIRS})
set(Cbc_LIBRARIES ${Cbc_PKGCONF_LIBRARIES})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cbc
  FOUND_VAR Cbc_FOUND
  REQUIRED_VARS
  Cbc_LIBRARIES
  Cbc_INCLUDE_DIRS)
mark_as_advanced(Cbc_INCLUDE_DIRS Cbc_LIBRARIES)
