function(add_tensorflow_oplib TARGET)
  string(REPLACE "-" "_" output_name ${TARGET})

  define_module(LIBRARY ${TARGET}
    DEPENDS TENSORFLOW)

  add_library(${TARGET} MODULE ${ARGN})

  set_target_properties(${TARGET} PROPERTIES
    PREFIX ""
    OUTPUT_NAME ${output_name}
    SKIP_BUILD_RPATH TRUE
    )

  buildsys_library(${TARGET})
  target_link_libraries(${TARGET} ${MODULE_LIBRARIES})
  target_include_directories(${TARGET} SYSTEM PRIVATE ${TENSORFLOW_INCLUDE_DIR})
  target_link_directories(${TARGET} PRIVATE ${TENSORFLOW_LIBRARY_DIR})
  target_compile_definitions(${TARGET} PRIVATE ${TENSORFLOW_DEFINITIONS})
endfunction()
