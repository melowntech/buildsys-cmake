find_package(glog CONFIG)

if (TARGET glog::glog)
  set(GLOG_FOUND TRUE)
  set(GLOG_VERSION ${glog_VERSION})
  set(GLOG_LIBRARIES glog::glog)
endif()
