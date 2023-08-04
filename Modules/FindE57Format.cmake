find_package(E57Format CONFIG PATHS /usr/lib/cmake NO_DEFAULT_PATH)

if (TARGET E57Format)
  set(E57Format_FOUND TRUE)
  set(E57Format_LIBRARIES E57Format)
  # get version from soname
  get_target_property(E57Format_VERSION E57Format IMPORTED_SONAME_RELEASE)
  string(REGEX MATCH "\\.([0-9])([0-9])([0-9])" _ "${E57Format_VERSION}")
  set(E57Format_VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")
endif()
