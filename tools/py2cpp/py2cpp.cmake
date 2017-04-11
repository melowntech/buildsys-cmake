macro(py_to_pyc outfiles name input)
  if(NOT PYTHON)
    message(FATAL_ERROR "Python not enabled. Use enable_python macro first.")
  endif()

  get_filename_component(infile ${input} ABSOLUTE)

  buildsys_make_output_file(${infile} "" pyc outfile_pyc)

  add_custom_command(OUTPUT ${outfile_pyc}
    COMMAND ${PYTHON}
    ARGS ${PY_TO_PYC_BINARY} ${infile} ${outfile_pyc}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${infile}
    )

  file_to_cpp(${outfiles} ${name} ${outfile_pyc})
endmacro()

macro(find_py_to_pyc)
  get_filename_component(current_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

  find_program(PY_TO_PYC_BINARY
    py2pyc
    HINTS ${current_dir})

  message(STATUS "using ${PY_TO_PYC_BINARY} as py2pyc")
endmacro()

find_py_to_pyc()
