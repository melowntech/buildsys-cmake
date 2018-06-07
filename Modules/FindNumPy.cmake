include(FindPackageHandleStandardArgs)

# fail if no python executable is present
if(NOT PYTHON_EXECUTABLE)
  status(MESSAGE "No PYTHON_EXECUTABLE found. Use enable_python(version).")
  set(NUMPY_INCLUDE_DIR NUMPY_INCLUDE_DIR-NOTFOUND)
  find_package_handle_standard_args(NumPy REQUIRED_VARS NUMPY_INCLUDE_DIR)
endif()

execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
  "try: import numpy; print(numpy.get_include(), end='')\nexcept:pass\n"
  OUTPUT_VARIABLE NUMPY_INCLUDE_DIR)

execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
  "try: import numpy; print(numpy.__version__, end='')\nexcept:pass\n"
  OUTPUT_VARIABLE __numpy_version)

find_package_handle_standard_args(NumPy REQUIRED_VARS NUMPY_INCLUDE_DIR
  VERSION_VAR __numpy_version)
