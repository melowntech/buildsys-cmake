
# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(shapeliB REQUIRED CONFIG) 

if (TARGET shapelib::shp)
  set(libshp_FOUND TRUE)
  set(libshp_VERSION ${shapeliB_VERSION})
  set(libshp_LIBRARIES shapelib::shp)
endif()