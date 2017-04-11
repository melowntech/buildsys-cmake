# add custom sources to VAR based on customer_build and customer values
macro(add_customer_sources WHAT VAR)
  if (BUILDSYS_CUSTOMER_BUILD)
    message(STATUS "Building ${WHAT} customized for customer "
      "'${BUILDSYS_CUSTOMER}'.")
    set(customer ${BUILDSYS_CUSTOMER})
  else()
    message(STATUS "Building ${WHAT} without any customization.")
    set(customer "none")
  endif()

  foreach(file ${ARGN})
    string(REPLACE "{CUSTOMER}" ${customer} cfile ${file})
    list(APPEND ${VAR} ${cfile})
  endforeach()
endmacro()
