# --------- backup variables ---------
set(_jsoncpp_FOUND ${jsoncpp_FOUND})
set(_jsoncpp_VERSION ${jsoncpp_VERSION})
set(_jsoncpp_LIBRARIES ${jsoncpp_LIBRARIES})
set(_jsoncpp_INCLUDE_DIRS ${jsoncpp_INCLUDE_DIRS})
# ------------------------------------

find_package(jsoncpp REQUIRED CONFIG)

if (TARGET jsoncpp::jsoncpp)
  set(JSONCPP_FOUND TRUE)
  set(JSONCPP_VERSION ${jsoncpp_VERSION})
  set(JSONCPP_LIBRARIES jsoncpp::jsoncpp)
endif()

# --------- restore variables ---------
set(jsoncpp_FOUND ${_jsoncpp_FOUND})
set(jsoncpp_VERSION ${_jsoncpp_VERSION})
set(jsoncpp_LIBRARIES ${_jsoncpp_LIBRARIES})
set(jsoncpp_INCLUDE_DIRS ${_jsoncpp_INCLUDE_DIRS})
# ------------------------------------