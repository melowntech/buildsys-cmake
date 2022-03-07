find_package(yaml-cpp REQUIRED CONFIG) 

if (TARGET yaml-cpp::yaml-cpp)
  set(yaml-cpp_FOUND TRUE)
  set(yaml-cpp_VERSION ${yaml-cpp_VERSION})
  set(yaml-cpp_LIBRARIES yaml-cpp::yaml-cpp)
endif()
