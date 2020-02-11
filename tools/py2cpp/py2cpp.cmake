macro(py_to_pyc outfiles name input)
  if(NOT PYTHON_BINARY)
    message(FATAL_ERROR "Python not enabled. Use enable_python macro first.")
  endif()

  get_filename_component(infile ${input} ABSOLUTE)

  buildsys_make_output_file(${infile} "" pyc outfile_pyc)

  add_custom_command(OUTPUT ${outfile_pyc}
    COMMAND ${PYTHON_BINARY}
    ARGS ${PY_TO_PYC_BINARY} ${infile} ${outfile_pyc}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${infile}
    )

  file_to_cpp(${outfiles} ${name} ${outfile_pyc})
endmacro()

macro(find_py_to_pyc)
  get_filename_component(current_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

  set(PY_TO_PYC_BINARY ${CMAKE_CURRENT_LIST_DIR}/py2pyc)
  message(STATUS "using ${PY_TO_PYC_BINARY} as py2pyc")
endmacro()

find_py_to_pyc()
