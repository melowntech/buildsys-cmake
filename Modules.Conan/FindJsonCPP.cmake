find_package(jsoncpp CONFIG)

if (TARGET jsoncpp::jsoncpp)
  set(JSONCPP_FOUND TRUE)
  set(JSONCPP_VERSION ${jsoncpp_VERSION})
  set(JSONCPP_LIBRARIES jsoncpp::jsoncpp)
endif()
