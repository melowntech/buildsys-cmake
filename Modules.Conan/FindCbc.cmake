# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(coin-cbC REQUIRED CONFIG)
find_package(coin-cgL REQUIRED CONFIG)
find_package(coin-clP REQUIRED CONFIG)
find_package(coin-osI REQUIRED CONFIG)
find_package(coin-utilS REQUIRED CONFIG)

if (
  TARGET coin-cbc::coin-cbc AND 
  TARGET coin-cgl::coin-cgl AND 
  TARGET coin-clp::coin-clp AND 
  TARGET coin-osi::coin-osi AND 
  TARGET coin-utils::coin-utils
)
  add_library(Cbc INTERFACE)
  target_link_libraries(Cbc INTERFACE 
    coin-cbc::coin-cbc
    coin-cgl::coin-cgl
    coin-clp::coin-clp
    coin-osi::coin-osi
    coin-utils::coin-utils
  )
  
  set(Cbc_FOUND TRUE)
  set(Cbc_VERSION ${coin-cbC_VERSION})
  set(Cbc_LIBRARIES Cbc)

  # Add additional include directory "include"
  get_target_property(coin_cgl_INCLUDE_DIRS coin-cgl::coin-cgl INTERFACE_INCLUDE_DIRECTORIES)
  string(REPLACE "include/coin" "include" coin_cgl_ADDITIONAL_INCLUDE_DIRS ${coin_cgl_INCLUDE_DIRS})
  set_target_properties(coin-cgl::coin-cgl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${coin_cgl_INCLUDE_DIRS};${coin_cgl_ADDITIONAL_INCLUDE_DIRS}")

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
