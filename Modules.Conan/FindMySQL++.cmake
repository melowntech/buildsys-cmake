find_package(mysqlpp REQUIRED CONFIG)

if (TARGET mysqlpp::mysqlpp)
  set(MYSQL++_FOUND TRUE)
  set(MYSQL++_VERSION ${mysqlpp_VERSION})
  set(MYSQL++_LIBRARIES mysqlpp::mysqlpp)
endif()