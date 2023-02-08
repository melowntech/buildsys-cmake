include(FindPackageHandleStandardArgs)

# fail if no python executable is present
if(NOT PYTHON_EXECUTABLE)
  message(STATUS "No PYTHON_EXECUTABLE found. Use enable_python(version).")
  set(PYTORCH_DIR PYTORCH_DIR-NOTFOUND)
  find_package_handle_standard_args(TensorFlow REQUIRED_VARS PYTORCH_DIR)
endif()

execute_process(COMMAND "${PYTHON_EXECUTABLE}"
  ${CMAKE_CURRENT_LIST_DIR}/FindPyTorch.py
  OUTPUT_VARIABLE __var_list
  OUTPUT_STRIP_TRAILING_WHITESPACE
  ERROR_QUIET
  )

list(LENGTH __var_list __var_list_len)
math(EXPR end "${__var_list_len} - 1")

# skip if __var_list is empty
if (__var_list_len GREATER 0)
  foreach(i RANGE 0 ${end} 2)
    list(GET __var_list ${i} name)
    math(EXPR j "${i} + 1")
    list(GET __var_list ${j} value)

    if(name IN_LIST LIST_VARS)
      string(REGEX MATCHALL "[^\t]+" value "${value}")
    endif()
    set("${name}" "${value}")
  endforeach()
endif()

find_package_handle_standard_args(PyTorch REQUIRED_VARS
  PYTORCH_DIR
  VERSION_VAR __pytorch_version)
