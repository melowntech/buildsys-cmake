find_package(coin-cbc REQUIRED CONFIG)
find_package(coin-cgl REQUIRED CONFIG)
find_package(coin-clp REQUIRED CONFIG)
find_package(coin-osi REQUIRED CONFIG)
find_package(coin-utils REQUIRED CONFIG)

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
  set(Cbc_VERSION ${coin-cbc_VERSION})
  set(Cbc_LIBRARIES Cbc)

  # Add additional include directory "include"
  get_target_property(coin_cgl_INCLUDE_DIRS coin-cgl::coin-cgl INTERFACE_INCLUDE_DIRECTORIES)
  string(REPLACE "include/coin" "include" coin_cgl_ADDITIONAL_INCLUDE_DIRS ${coin_cgl_INCLUDE_DIRS})
  set_target_properties(coin-cgl::coin-cgl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${coin_cgl_INCLUDE_DIRS};${coin_cgl_ADDITIONAL_INCLUDE_DIRS}")

endif()