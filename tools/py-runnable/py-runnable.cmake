macro(buildsys_py_runnable src dst hashbang)
  if(NOT PYTHON3_BINARY)
    message(FATAL_ERROR "buildsys_py_runnable needs python3")
  endif()
  add_custom_command(OUTPUT ${dst}
    COMMAND ${PYTHON3_BINARY}
    ARGS ${PY_RUNNABLE_BINARY} "${src}" "${dst}" "${hashbang}"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${src}
    COMMENT "Making ${dst} runnable"
    )
endmacro()

macro(find_py_runnable)
  find_program(PY_RUNNABLE_BINARY
    py-runnable
    HINTS ${CMAKE_CURRENT_LIST_DIR})

  message(STATUS "using ${PY_RUNNABLE_BINARY} as py-runnable")
endmacro()

find_py_runnable()
