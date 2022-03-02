find_package(mgts REQUIRED CONFIG)

if (TARGET mgts::mgts)
  set(MGTS_FOUND TRUE)
  set(MGTS_VERSION ${mgts_VERSION})
  set(MGTS_LIBRARIES mgts::mgts)
endif()
