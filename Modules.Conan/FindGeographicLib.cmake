find_package(geographiclib CONFIG)

if (TARGET GeographicLib::GeographicLib)
  set(GeographicLib_FOUND TRUE)
  set(GeographicLib_VERSION ${geographiclib_VERSION})
  set(GeographicLib_LIBRARIES GeographicLib::GeographicLib)
endif()
