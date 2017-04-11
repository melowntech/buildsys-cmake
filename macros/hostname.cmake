macro(compile_with_hostname)
  site_name(HOSTNAME)
  add_definitions("-DBUILDSYS_HOSTNAME=\"${HOSTNAME}\"")
endmacro()
