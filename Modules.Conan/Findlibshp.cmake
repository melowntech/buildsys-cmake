find_package(shapelib CONFIG) 

if (TARGET shapelib::shp)
  set(LIBSHP_FOUND TRUE)
  set(LIBSHP_VERSION ${shapelib_VERSION})
  set(LIBSHP_LIBRARIES shapelib::shp)
endif()
