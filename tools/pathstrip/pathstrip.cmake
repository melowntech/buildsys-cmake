macro(buildsys_target_post_build_pathstrip target)
  if(NOT elftools_FOUND)
    check_python_module(elftools elftools_FOUND ${PYTHON_BINARY})
  endif()
  if(NOT elftools_FOUND)
    message(FATAL_ERROR "pathstrip utility needs pyelftools module installed")
  endif()

  add_custom_command(TARGET ${target}
                     POST_BUILD
                     COMMAND ${PYTHON_BINARY}
                     ARGS ${PATHSTRIP_BINARY}
                     $<TARGET_FILE:${target}> ${CMAKE_SOURCE_DIR}
                     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                     COMMENT "Stripping paths from target ${target}")
endmacro()

macro(find_pathstrip)
  set(PATHSTRIP_BINARY ${CMAKE_CURRENT_LIST_DIR}/pathstrip)
  message(STATUS "using ${PATHSTRIP_BINARY} as pathstrip")
endmacro()

if(NOT WIN32)
  # path stripping is available only in non-windows build
  find_pathstrip()
endif()
