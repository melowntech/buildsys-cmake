find_package(mgts CONFIG)

if (TARGET mgts::mgts)
  set(MGTS_FOUND TRUE)
  set(MGTS_VERSION ${mgts_VERSION})
  set(MGTS_LIBRARIES mgts::mgts)
endif()
