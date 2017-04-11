macro(buildsys_binary target)
  set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}/bin)

  if(BUILDSYS_CUSTOMER_BUILD)
    buildsys_target_post_build_pathstrip(${target})
  endif()

  set_target_properties(${target} PROPERTIES BUILDSYS_HOME_DIR
    ${CMAKE_CURRENT_LIST_DIR})
endmacro()

macro(buildsys_library target)
  get_target_property(TYPE ${target} TYPE)
  if(TYPE STREQUAL "STATIC_LIBRARY")
    set_target_properties(${target} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY
      ${CMAKE_BINARY_DIR}/lib)
  else()
    set_target_properties(${target} PROPERTIES LIBRARY_OUTPUT_DIRECTORY
      ${CMAKE_BINARY_DIR}/lib)

    if(BUILDSYS_CUSTOMER_BUILD)
      buildsys_target_post_build_pathstrip(${target})
    endif()
  endif()

  set_target_properties(${target} PROPERTIES BUILDSYS_HOME_DIR
    ${CMAKE_CURRENT_LIST_DIR})
endmacro()
