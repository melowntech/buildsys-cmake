find_package(JSONCPP REQUIRED CONFIG)

if (TARGET jsoncpp::jsoncpp)
  set(JSONCPP_FOUND TRUE)
  set(JSONCPP_LIBRARIES jsoncpp::jsoncpp)
endif()