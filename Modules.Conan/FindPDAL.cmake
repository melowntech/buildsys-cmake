# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(pdaL 2.3 REQUIRED CONFIG)
# TODO: Find other solution
message(WARNING "Force-using PDAL 2.3")

if (TARGET PDAL::PDAL)
  set(PDAL_FOUND TRUE)
  set(PDAL_VERSION ${pdaL_VERSION})
  set(PDAL_LIBRARIES PDAL::PDAL)
endif()

# get_target_property(PDAL_LIBRARIES PDAL::PDAL INTERFACE_LINK_LIBRARIES)
# get_target_property(PDAL_INCLUDE_DIRS PDAL::PDAL INTERFACE_INCLUDE_DIRECTORIES)