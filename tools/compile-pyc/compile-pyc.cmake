macro(find_compile_pyc)
  set(COMPILE_PYC_BINARY ${CMAKE_CURRENT_LIST_DIR}/compile-pyc)
  message(STATUS "using ${COMPILE_PYC_BINARY} as compile-pyc")
endmacro()

find_compile_pyc()
