# compatibility stuff

if (NOT COMMAND target_compile_definitions)

  macro(target_compile_definitions TARGET)
    foreach(atom ${ARGN})
      if(${atom} STREQUAL "INTERFACE")
      elseif(${atom} STREQUAL "PUBLIC")
      elseif(${atom} STREQUAL "PRIVATE")
      else()
        # definitions
        set_property(TARGET ${TARGET} APPEND
          PROPERTY COMPILE_DEFINITIONS ${atom})
      endif()
    endforeach()
  endmacro()

endif()

macro(buildsys_target_compile_definitions TARGET)
  if(NOT "${ARGN}" STREQUAL "")
    target_compile_definitions(${TARGET} PRIVATE ${ARGN})
  endif()
endmacro()
