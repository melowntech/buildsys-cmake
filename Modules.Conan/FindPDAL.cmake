find_package(PDAL REQUIRED CONFIG)

if (TARGET PDAL::PDAL)
  set(PDAL_FOUND TRUE)
  set(PDAL_VERSION ${PDAL_VERSION})
  set(PDAL_LIBRARIES PDAL::PDAL)
endif()