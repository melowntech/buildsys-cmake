include(FindPackageHandleStandardArgs)

# fail if no python executable is present
if(NOT PYTHON_EXECUTABLE)
  status(MESSAGE "No PYTHON_EXECUTABLE found. Use enable_python(version).")
  set(TENSORFLOW_INCLUDE_DIR TENSORFLOW_INCLUDE_DIR-NOTFOUND)
  find_package_handle_standard_args(TensorFlow REQUIRED_VARS TENSORFLOW_INCLUDE_DIR)
endif()

execute_process(COMMAND "${PYTHON_EXECUTABLE}"
  ${CMAKE_CURRENT_LIST_DIR}/FindTensorFlow.py
  OUTPUT_VARIABLE __var_list
  OUTPUT_STRIP_TRAILING_WHITESPACE
  ERROR_QUIET
  )

# list of variables that are list (separated by TAB ('\t'))
set(LIST_VARS TENSORFLOW_DEFINITIONS TENSORFLOW_LIBRARIES)

list(LENGTH __var_list __var_list_len)
math(EXPR end "${__var_list_len} - 1")

foreach(i RANGE 0 ${end} 2)
  list(GET __var_list ${i} name)
  math(EXPR j "${i} + 1")
  list(GET __var_list ${j} value)

  if(name IN_LIST LIST_VARS)
    string(REGEX MATCHALL "[^\t]+" value "${value}") 
  endif()
  set("${name}" "${value}")
endforeach()

find_package_handle_standard_args(TensorFlow REQUIRED_VARS
  TENSORFLOW_INCLUDE_DIR
  TENSORFLOW_LIBRARY_DIR
  TENSORFLOW_LIBRARIES
  TENSORFLOW_DEFINITIONS
  VERSION_VAR __tensorflow_version)
