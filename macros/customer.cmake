# add custom sources to VAR based on customer_build and customer values
macro(add_customer_sources WHAT VAR)
  if (BUILDSYS_CUSTOMER_BUILD)
    message(STATUS "Building ${WHAT} customized for customer "
      "'${BUILDSYS_CUSTOMER}'.")
    set(customer ${BUILDSYS_CUSTOMER})
  elseif(DEFINED BUILDSYS_DEFAULT_CUSTOMER_NAME)
    message(STATUS "Building ${WHAT} without customization for "
      "${BUILDSYS_DEFAULT_CUSTOMER_NAME}.")
    set(customer "${BUILDSYS_DEFAULT_CUSTOMER_NAME}")
  else()
    message(STATUS "Building ${WHAT} without any customization.")
    set(customer "none")
  endif()

  foreach(file ${ARGN})
    string(REPLACE "{CUSTOMER}" ${customer} cfile ${file})
    list(APPEND ${VAR} ${cfile})
  endforeach()
endmacro()

# add custom sources to VAR based on customer_build and customer values
macro(add_customer_sources_with_default WHAT VAR)
  if (BUILDSYS_CUSTOMER_BUILD)
    message(STATUS "Building ${WHAT} customized for customer "
      "'${BUILDSYS_CUSTOMER}'.")
    set(customer ${BUILDSYS_CUSTOMER})
  elseif(DEFINED BUILDSYS_DEFAULT_CUSTOMER_NAME)
    message(STATUS "Building ${WHAT} without customization for "
      "${BUILDSYS_DEFAULT_CUSTOMER_NAME}.")
    set(customer "${BUILDSYS_DEFAULT_CUSTOMER_NAME}")
  else()
    message(STATUS "Building ${WHAT} without any customization.")
    set(customer "none")
  endif()

  foreach(file ${ARGN})
    string(REPLACE "{CUSTOMER}" ${customer} cfile ${file})
    get_filename_component(absfile "${cfile}" ABSOLUTE)

    if(NOT EXISTS ${absfile})
      string(REPLACE "{CUSTOMER}" none cfile ${file})
    endif()
    list(APPEND ${VAR} ${cfile})
  endforeach()
endmacro()
