find_package(coin-cbc REQUIRED CONFIG)

if (TARGET coin-cbc::coin-cbc)
  set(Cbc_FOUND TRUE)
  set(Cbc_LIBRARIES coin-cbc::coin-cbc)
endif()

# get_target_property(Cbc_LIBRARIES coin-cbc::libcbc INTERFACE_LINK_LIBRARIES)
# get_target_property(Cbc_INCLUDE_DIRS coin-cbc::libcbc INTERFACE_INCLUDE_DIRECTORIES)

# include(FindPackageHandleStandardArgs)

# find_package_handle_standard_args(Cbc
#   FOUND_VAR Cbc_FOUND
#   REQUIRED_VARS
#   Cbc_LIBRARIES
#   Cbc_INCLUDE_DIRS)
  
# mark_as_advanced(Cbc_INCLUDE_DIRS Cbc_LIBRARIES)
