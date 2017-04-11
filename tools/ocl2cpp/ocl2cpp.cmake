macro(opencl_to_cpp outfiles name input)
  if(NOT OPENCL_FOUND)
    message(FATAL_ERROR "OpenCL not enabled. Use enable_opencl macro first.")
  endif()

  if (NOT TARGET clpc)
    # pull in clpc target
    add_subdirectory(${BUILDSYS_ROOT}/tools/clpc
      ${BUILDSYS_BINARY_ROOT}/cmake-support/tools/clpc)
  endif()

  get_filename_component(infile ${input} ABSOLUTE)

  # we are asking not to add an extension
  buildsys_make_output_file(${infile} "" "" outfile_cl)
  buildsys_make_output_file(${infile} "" "dep" outfile_dep)

  # TODO: tear this into two parts:
  #     1) generate depends file
  #     2) generate output cl file
  add_custom_command(OUTPUT ${outfile_cl}
    COMMAND clpc
    ARGS -i ${infile} ${outfile_cl}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ${infile}
    IMPLICIT_DEPENDS C ${infile}
    )

  file_to_cpp(${outfiles} ${name} ${outfile_cl})
endmacro()

# add multiple OpenCL files from one directory to given namespace
# file
#     ${directory}/A.cl
# is added as C++ variable
#     ${namespace}::A
macro(opencl_to_cpp_multi outfiles namespace directory)
  foreach(name ${ARGN})
    opencl_to_cpp(${outfiles} ${namespace}::${name} ${directory}/${name}.cl)
  endforeach()
endmacro()
