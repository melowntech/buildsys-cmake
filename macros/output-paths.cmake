macro(buildsys_binary target)
  get_target_property(TYPE ${target} TYPE)
  if(NOT TYPE STREQUAL "EXECUTABLE")
    message(FATAL_ERROR "Target ${target} is not a binary.")
  endif()

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
  if(TYPE STREQUAL "EXECUTABLE")
    message(FATAL_ERROR "Target ${target} is not a library.")
  endif()

  if(NOT TYPE STREQUAL "STATIC_LIBRARY")
    if(BUILDSYS_CUSTOMER_BUILD)
      buildsys_target_post_build_pathstrip(${target})
    endif()
  endif()

  set_target_properties(${target} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}/lib)
  set_target_properties(${target} PROPERTIES LIBRARY_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}/lib)
  set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}/bin)

  set_target_properties(${target} PROPERTIES BUILDSYS_HOME_DIR
    ${CMAKE_CURRENT_LIST_DIR})
endmacro()

macro(buildsys_module target)
  get_target_property(TYPE ${target} TYPE)

  if(NOT TYPE STREQUAL "MODULE_LIBRARY")
    message(FATAL_ERROR "Target ${target} is not a module library.")
  endif()

  # drop lib prefix
  set_target_properties(melownmodule PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/module
    PREFIX "")
  set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}/bin)

  set_target_properties(${target} PROPERTIES BUILDSYS_HOME_DIR
    ${CMAKE_CURRENT_LIST_DIR})
endmacro()
