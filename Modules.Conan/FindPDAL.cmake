find_package(PDAL 2.3 REQUIRED CONFIG)
# TODO: Find other solution
message(WARNING "Force-using PDAL 2.3")

if (TARGET PDAL::PDAL)
  set(PDAL_FOUND TRUE)
  set(PDAL_VERSION ${PDAL_VERSION})
  set(PDAL_LIBRARIES PDAL::PDAL)
endif()