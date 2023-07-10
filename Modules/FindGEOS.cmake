find_package(GEOS CONFIG)

if (TARGET GEOS::geos)
  set(GEOS_FOUND TRUE)
  set(GEOS_VERSION ${GEOS_VERSION})
  set(GEOS_LIBRARIES GEOS::geos GEOS::geos_cxx_flags)
endif()
