find_package(Catch2 CONFIG)

if (TARGET Catch2::Catch2)
  set(Catch2_FOUND TRUE)
  set(Catch2_VERSION ${Catch2_VERSION})
  set(Catch2_LIBRARIES Catch2::Catch2)

  # Add additional include directory "include/catch2"
  get_target_property(Catch2_INCLUDE_DIRS Catch2::Catch2 INTERFACE_INCLUDE_DIRECTORIES)
  string(REPLACE "/include" "/include/catch2" Catch2_ADDITIONAL_INCLUDE_DIRS ${Catch2_INCLUDE_DIRS})
  set_target_properties(Catch2::Catch2 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${Catch2_INCLUDE_DIRS};${Catch2_ADDITIONAL_INCLUDE_DIRS}")
endif()
