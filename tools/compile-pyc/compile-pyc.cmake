macro(find_compile_pyc)
  find_program(COMPILE_PYC_BINARY
    compile-pyc
    HINTS ${CMAKE_CURRENT_LIST_DIR})

  message(STATUS "using ${COMPILE_PYC_BINARY} as compile-pyc")
endmacro()

find_compile_pyc()
