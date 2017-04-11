macro(buildsys_compile_with_install_prefix)
  add_definitions("-DBUILDSYS_INSTALL_PREFIX=\"${CMAKE_INSTALL_PREFIX}\"")
endmacro()
