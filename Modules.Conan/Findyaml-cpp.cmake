# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(yaml-cpP REQUIRED CONFIG) 

if (TARGET yaml-cpp::yaml-cpp)
  set(yaml-cpp_FOUND TRUE)
  set(yaml-cpp_VERSION ${yaml-cpP_VERSION})
  set(yaml-cpp_LIBRARIES yaml-cpp::yaml-cpp)
endif()