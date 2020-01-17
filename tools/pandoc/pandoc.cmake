macro(find_pandoc)
  if(NOT PANDOC_BINARY)
    find_program(PANDOC_BINARY pandoc)

    execute_process(COMMAND "sh" -c
      "pandoc --version | head -n1 | cut -d' ' -f2"
      OUTPUT_VARIABLE __pandoc_version)
    string(STRIP ${__pandoc_version} __pandoc_version)

    message(STATUS "using ${PANDOC_BINARY} (v. ${__pandoc_version}) as pandoc")

    if(__pandoc_version VERSION_LESS 2)
      set(PANDOC_EXTRA_ARGS --smart)
      set(PANDOC_EXTRA_FORMAT)
    else()
      set(PANDOC_EXTRA_ARGS)
      set(PANDOC_EXTRA_FORMAT +smart)
    endif()
  endif()
endmacro()

set(_pandoc_ext2format_mapping
  .md markdown
  .rst rst
  .html html
  )

macro(_pandoc_ext2format file format_var)
  get_filename_component(ext ${file} EXT)

  list(FIND _pandoc_ext2format_mapping ${ext} index)
  if(index EQUAL -1)
    message(FATAL_ERROR "File ${file} has unknown format.")
  endif()

  math(EXPR index "${index} + 1")
  list(GET _pandoc_ext2format_mapping ${index} value)
  set(${format_var} ${value}${PANDOC_EXTRA_FORMAT})
endmacro()

macro(add_website target)
  find_pandoc()

  set(outfiles)

  foreach(input ${ARGN})
    get_filename_component(infile ${input} ABSOLUTE)
    buildsys_make_output_file(${infile} "" .html outfile)
    _pandoc_ext2format(${infile} in_format)

    add_custom_command(OUTPUT ${outfile}
      COMMAND ${PANDOC_BINARY}
      ARGS -f ${in_format} -o ${outfile} ${infile} --standalone ${PANDOC_EXTRA_ARGS}
      DEPENDS ${infile} ${PANDOC_BINARY}
      )

    list(APPEND outfiles ${outfile})

  endforeach()

  add_custom_target(${target} ALL
    DEPENDS ${outfiles}
    )

  set_target_properties(${target}
    PROPERTIES BUILDSYS_WEBSITE_FILES "${outfiles}")
endmacro()

macro(install_website target)
  get_target_property(outfiles ${target} BUILDSYS_WEBSITE_FILES)
  install(FILES ${outfiles} ${ARGN})
endmacro()

macro(pandoc_to_cpp outfiles name input)
  find_pandoc()

  get_filename_component(infile ${input} ABSOLUTE)
  buildsys_make_output_file(${infile} "" html outfile)
  _pandoc_ext2format(${infile} in_format)

  add_custom_command(OUTPUT ${outfile}
    COMMAND ${PANDOC_BINARY}
    ARGS -f ${in_format} -o ${outfile} ${infile} --standalone ${PANDOC_EXTRA_ARGS}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${infile} ${PANDOC_BINARY}
    )

  file_to_cpp(${outfiles} ${name} ${outfile})
endmacro()
