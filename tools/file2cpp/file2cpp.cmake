macro(file_to_cpp outfiles name input)
  get_filename_component(infile ${input} ABSOLUTE)

  # grab extra prefix from argument #3
  set(prefix "")

  buildsys_make_output_file(${infile} "${prefix}" hpp outfile_hpp)
  buildsys_make_output_file(${infile} "${prefix}" cpp outfile_cpp)

  set(file_to_cpp_extra_args)

  set(file_to_cpp_version 0)
  set(file_to_cpp_version_file 0)

  foreach(var ${ARGN})
    if (${var} STREQUAL "VERSION")
      if (NOT file_to_cpp_version EQUAL 0)
        message(FATAL_ERROR "file_to_cpp: version is already set")
      endif()
      set(file_to_cpp_version 1)
    elseif(file_to_cpp_version EQUAL 1)
      set(file_to_cpp_version 2)
      set(file_to_cpp_next_is_version OFF)
      list(APPEND file_to_cpp_extra_args --version ${var})
    elseif (${var} STREQUAL "VERSION_FILE")
      if (NOT file_to_cpp_version_file EQUAL 0)
        message(FATAL_ERROR "file_to_cpp: version-file is already set")
      endif()
      set(file_to_cpp_version_file 1)
    elseif(file_to_cpp_version_file EQUAL 1)
      set(file_to_cpp_version_file 2)
      set(file_to_cpp_next_is_version_file OFF)
      list(APPEND file_to_cpp_extra_args --version-file ${var})
    endif()
  endforeach()

  if (file_to_cpp_version EQUAL 1)
    message(FATAL_ERROR "file_to_cpp: missing version after VERSION")
  endif()

  if (file_to_cpp_version_file EQUAL 1)
    message(FATAL_ERROR "file_to_cpp: missing version-file after VERSION_FILE")
  endif()

  add_custom_command(OUTPUT ${outfile_hpp} ${outfile_cpp}
    COMMAND ${PYTHON2_BINARY}
    ARGS ${FILE_TO_CPP_BINARY} --name ${name} ${infile} ${outfile_cpp} ${file_to_cpp_extra_args}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${infile} ${FILE_TO_CPP_BINARY}
    )

  set(${outfiles} ${${outfiles}} ${outfile_cpp} ${outfile_hpp})
endmacro()

macro(find_file_to_cpp)
  set(FILE_TO_CPP_BINARY ${CMAKE_CURRENT_LIST_DIR}/file2cpp)
  message(STATUS "using ${FILE_TO_CPP_BINARY} as file2cpp")
endmacro()

find_file_to_cpp()
