# Inspired by Qt4Macros.cmake
#
# Creates output file inside build directory, adds optional prefix and appends
# or replaces extension:
#     * .ext -> replace extentsion
#     * ext -> append extenstion
macro(buildsys_make_output_file infile prefix ext outfile )
  string(LENGTH ${CMAKE_CURRENT_BINARY_DIR} _binlength)
  string(LENGTH ${infile} _infileLength)
  set(_checkinfile ${CMAKE_CURRENT_SOURCE_DIR})

  if(_infileLength GREATER _binlength)
    string(SUBSTRING "${infile}" 0 ${_binlength} _checkinfile)
    if(_checkinfile STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
      file(RELATIVE_PATH rel ${CMAKE_CURRENT_BINARY_DIR} ${infile})
    else()
      file(RELATIVE_PATH rel ${CMAKE_CURRENT_SOURCE_DIR} ${infile})
    endif()
  else()
    file(RELATIVE_PATH rel ${CMAKE_CURRENT_SOURCE_DIR} ${infile})
  endif()

  if(WIN32 AND rel MATCHES "^[a-zA-Z]:") # absolute path
    string(REGEX REPLACE "^([a-zA-Z]):(.*)$" "\\1_\\2" rel "${rel}")
  endif()

  set(_outfile "${CMAKE_CURRENT_BINARY_DIR}/${rel}")
  string(REPLACE ".." "__" _outfile ${_outfile})
  get_filename_component(outpath ${_outfile} PATH)
  get_filename_component(_outfile ${_outfile} NAME)
  file(MAKE_DIRECTORY ${outpath})

  set(_ext "${ext}")
  string(REGEX MATCH "^\\." _hasdot "${_ext}")

  # if extentsion start with dot (.) then we replace whole extentsion with new
  # one, instead of add
  if(_hasdot STREQUAL ".")
    get_filename_component(_outfile ${_outfile} NAME_WE)
    string(SUBSTRING "${_ext}" 1 -1 _ext)
  endif()

  if(_ext STREQUAL "")
    set(${outfile} ${outpath}/${prefix}${_outfile})
  else()
    set(${outfile} ${outpath}/${prefix}${_outfile}.${_ext})
  endif()
endmacro()
