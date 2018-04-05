macro(buildsys_target_post_build_pathstrip target)
  add_custom_command(TARGET ${target}
                     POST_BUILD
                     COMMAND ${PATHSTRIP_BINARY}
                     ARGS $<TARGET_FILE:${target}> ${CMAKE_SOURCE_DIR}
                     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                     COMMENT "Stripping paths from target ${target}")
endmacro()

macro(find_pathstrip)
  get_filename_component(current_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

  find_program(PATHSTRIP_BINARY
    pathstrip
    HINTS ${current_dir})

  message(STATUS "using ${PATHSTRIP_BINARY} as pathstrip")
endmacro()

if(NOT WIN32)
  # path stripping is available only in non-windows build
  find_pathstrip()
endif()
