macro(buildsys_make_runnable src dst hashbang)
  if(NOT PYTHON3_BINARY)
    message(FATAL_ERROR "buildsys_make_runnable needs python3")
  endif()
  add_custom_command(OUTPUT ${dst}
    COMMAND ${PYTHON3_BINARY}
    ARGS ${MAKERUNNABLE_BINARY} "${src}" "${dst}" "${hashbang}"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${src}
    COMMENT "Making ${dst} runnable"
    )
endmacro()

macro(find_makerunnable)
  find_program(MAKERUNNABLE_BINARY
    makerunnable
    HINTS ${CMAKE_CURRENT_LIST_DIR})

  message(STATUS "using ${MAKERUNNABLE_BINARY} as makerunnable")
endmacro()

find_makerunnable()
