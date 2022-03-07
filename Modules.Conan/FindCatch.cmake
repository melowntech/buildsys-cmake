find_package(Catch2 REQUIRED CONFIG)

if (TARGET Catch2::Catch2)
  set(Catch_FOUND TRUE)
  set(Catch_VERSION ${Catch2_VERSION})
  set(Catch_LIBRARIES Catch2::Catch2)

  # Add additional include directory "include/catch2"
  get_target_property(Catch_INCLUDE_DIRS Catch2::Catch2 INTERFACE_INCLUDE_DIRECTORIES)
  string(REPLACE "/include" "/include/catch2" Catch_ADDITIONAL_INCLUDE_DIRS ${Catch_INCLUDE_DIRS})
  set_target_properties(Catch2::Catch2 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${Catch_INCLUDE_DIRS};${Catch_ADDITIONAL_INCLUDE_DIRS}")
endif()
