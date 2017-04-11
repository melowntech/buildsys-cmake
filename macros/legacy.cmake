# call add_subdirectory and ask included CMakeLists.txt to feed its source files
# to passed ${output_var}
# ${path} is prepended to any grabbed source file
macro(add_subdirectory_and_grab_sources path output_var)
  set(${output_var} )
  set(add_subdirectory_and_grab_sources_var )
  set(Add_Subdirectory_And_Grab_Sources_Var
    add_subdirectory_and_grab_sources_var)
  add_subdirectory(${path})
  foreach(fn ${add_subdirectory_and_grab_sources_var})
    set(${output_var} ${${output_var}};${CMAKE_SOURCE_DIR}/${path}/${fn})
  endforeach()
endmacro()
