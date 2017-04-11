macro(sqlite_to_db outfiles name input)
  get_filename_component(infile ${input} ABSOLUTE)

  buildsys_make_output_file(${infile} "" db outfile_db)
  buildsys_make_output_file(${infile} "" version outfile_version)

  add_custom_command(OUTPUT ${outfile_db} ${outfile_version}
    COMMAND ${SQLITE3_TO_DB_BINARY}
    ARGS ${infile} ${outfile_db} ${outfile_version}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${infile}
    )

  file_to_cpp(${outfiles} ${name} ${outfile_db} VERSION_FILE ${outfile_version})
endmacro()

macro(find_sqlite3_to_db)
  get_filename_component(current_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

  find_program(SQLITE3_TO_DB_BINARY
    sqlite32db
    HINTS ${current_dir})

  message(STATUS "using ${SQLITE3_TO_DB_BINARY} as sqlite32db")
endmacro()

find_sqlite3_to_db()
