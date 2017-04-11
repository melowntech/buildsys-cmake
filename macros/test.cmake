macro(add_subdirectory_with_tests DIRECTORY)
  add_subdirectory(${DIRECTORY})
  aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/${DIRECTORY}/test ALL_TEST_SOURCES)
endmacro()
