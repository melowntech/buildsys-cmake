# - Try to find AVAHI
# Once done, this will define
#
#  AVAHI_FOUND - system has Avahi
#  AVAHI_INCLUDE_DIRS - the Avahi include directories
#  AVAHI_LIBRARIES - link these to use Avahi

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(AVAHI_PKGCONF QUIET avahi-client)
set(AVAHI_DEFINITIONS ${PC_AVAHI-CLIENT_CFLAGS_OTHER})

find_path(AVAHI_INCLUDE_DIR
  NAMES avahi-client/client.h
  HINTS ${PC_AVAHI-CLIENT_LIBDIR} ${PC_AVAHI-CLIENT_LIBRARY_DIRS}
  )

# Finally the library itself
find_library(AVAHI_LIBRARY_COMMON
  NAMES avahi-common
  HINTS ${PC_AVAHI-CLIENT_LIBDIR} ${PC_AVAHI-CLIENT_LIBRARY_DIRS}
  )

find_library(AVAHI_LIBRARY_CLIENT
  NAMES avahi-client
  HINTS ${PC_AVAHI-CLIENT_LIBDIR} ${PC_AVAHI-CLIENT_LIBRARY_DIRS}
  )

set(AVAHI_LIBRARIES ${AVAHI_LIBRARY_COMMON} ${AVAHI_LIBRARY_CLIENT})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Avahi DEFAULT_MSG
  AVAHI_LIBRARIES
  AVAHI_INCLUDE_DIR)
mark_as_advanced(AVAHI_INCLUDE_DIR AVAHI_LIBRARIES)
