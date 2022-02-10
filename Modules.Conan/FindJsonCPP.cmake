# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(jsoncpP REQUIRED CONFIG)

if (TARGET jsoncpp::jsoncpp)
  set(JSONCPP_FOUND TRUE)
  set(JSONCPP_VERSION ${jsoncpP_VERSION})
  set(JSONCPP_LIBRARIES jsoncpp::jsoncpp)
endif()