find_package(yaml-cpp CONFIG) 

if (TARGET yaml-cpp::yaml-cpp)
  set(yaml-cpp_FOUND TRUE)
  set(yaml-cpp_VERSION ${yaml-cpp_VERSION})
  set(yaml-cpp_LIBRARIES yaml-cpp::yaml-cpp)
  set(YAML_CPP_FOUND ${yaml-cpp_FOUND})
  set(YAML_CPP_VERSION ${yaml-cpp_VERSION})
  set(YAML_CPP_LIBRARIES ${yaml-cpp_LIBRARIES})
endif()
