# - Try to find libmodbus

# Use pkg-config to get hints about paths
find_package(PkgConfig)
pkg_check_modules(MODBUS_PKGCONF QUIET libmodbus)

find_path(MODBUS_INCLUDE_DIR
  NAMES modbus.h
  PATHS ${MODBUS_PKGCONF_INCLUDE_DIRS}
)

# Finally the library itself
find_library(MODBUS_LIBRARY
  NAMES modbus
  PATHS ${MODBUS_PKGCONF_LIBRARY_DIRS}
)

set(MODBUS_INCLUDE_DIRS ${MODBUS_INCLUDE_DIR})
set(MODBUS_LIBRARIES ${MODBUS_LIBRARY})
set(MODBUS_VERSION ${MODBUS_PKGCONF_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Modbus DEFAULT_MSG
  MODBUS_LIBRARIES
  MODBUS_INCLUDE_DIRS
  MODBUS_VERSION)
mark_as_advanced(MODBUS_INCLUDE_DIR MODBUS_LIBRARIES MODBUS_VERSION)
