include(FindPackageHandleStandardArgs)

# fail if no python executable is present
if(NOT PYTHON_EXECUTABLE)
  status(MESSAGE "No PYTHON_EXECUTABLE found. Use enable_python(version).")
  set(TENSORFLOW_INCLUDE_DIR TENSORFLOW_INCLUDE_DIR-NOTFOUND)
  find_package_handle_standard_args(TensorFlow REQUIRED_VARS TENSORFLOW_INCLUDE_DIR)
endif()

string(TIMESTAMP THEN "%s")
message(STATUS "TF...")
execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
  "try: import tensorflow; print(tensorflow.__version__, end='')\nexcept:pass\n"
  OUTPUT_VARIABLE __tensorflow_version
  ERROR_QUIET)

execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
  "try: import tensorflow; print(tensorflow.sysconfig.get_include(), end='')\nexcept:pass\n"
  OUTPUT_VARIABLE TENSORFLOW_INCLUDE_DIR
  ERROR_QUIET)

execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
  "try: import tensorflow; print(tensorflow.sysconfig.get_lib(), end='')\nexcept:pass\n"
  OUTPUT_VARIABLE TENSORFLOW_LIBRARY_DIR
  ERROR_QUIET)

execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
  "try: import tensorflow; print(tensorflow.sysconfig._CXX11_ABI_FLAG, end='')\nexcept:pass\n"
  OUTPUT_VARIABLE _CXX11_ABI_FLAG
  ERROR_QUIET)

string(TIMESTAMP NOW "%s")
math(EXPR DIFF "${NOW} - ${THEN}")
message(STATUS "TF... done: ${DIFF}")

set(TENSORFLOW_LIBRARIES "tensorflow_framework")

set(TENSORFLOW_DEFINITIONS _GLIBCXX_USE_CXX11_ABI=${_CXX11_ABI_FLAG})

find_package_handle_standard_args(TensorFlow REQUIRED_VARS
  TENSORFLOW_INCLUDE_DIR
  TENSORFLOW_LIBRARY_DIR
  TENSORFLOW_LIBRARIES
  TENSORFLOW_DEFINITIONS
  VERSION_VAR __tensorflow_version)
