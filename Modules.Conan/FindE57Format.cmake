find_package(E57Format CONFIG) 

if (TARGET E57Format::E57Format)
  set(E57Format_FOUND TRUE)
  set(E57Format_VERSION ${E57Format_VERSION})
  set(E57Format_LIBRARIES E57Format::E57Format)
endif()
