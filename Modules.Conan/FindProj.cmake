find_package(proj REQUIRED CONFIG)

if (TARGET PROJ::proj)
  set(PROJ_FOUND TRUE)
  set(PROJ_VERSION ${proj_VERSION})
  set(PROJ_LIBRARIES PROJ::proj)
endif()
