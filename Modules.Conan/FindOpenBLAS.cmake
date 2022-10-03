find_package(OpenBLAS CONFIG)

if (TARGET OpenBLAS::OpenBLAS)
  set(OpenBLAS_FOUND TRUE)
  set(OpenBLAS_VERSION ${OpenBLAS_VERSION})
  set(OpenBLAS_LIBRARIES OpenBLAS::OpenBLAS)
endif()
