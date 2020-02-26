# FindJsonCPP

# backup CMAKE_MODULE_PATH and remove this directory from it
# NB: find should return valid entry since this file has been found
set(backup_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
list(FIND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR} index)
list(REMOVE_AT CMAKE_MODULE_PATH ${index})

set(arguments)
foreach(name REQUIRED QUIETLY VERSION)
  set(var JsonCPP_FIND_${name})
  if(${var})
    list(APPEND arguments ${name})
    list(APPEND arguments ${var})
  endif()
endforeach()

# find jsoncpp module
find_package(jsoncpp ${arguments})

# and return back
set(CMAKE_MODULE_PATH "${backup_CMAKE_MODULE_PATH}")

# forward if found
if (TARGET jsoncpp_lib_static)
  set(JSONCPP_LIBRARIES jsoncpp_lib_static)
  set(JSONCPP_INCLUDE_DIR $<TARGET_PROPERTY:jsoncpp_lib_static,INTERFACE_INCLUDE_DIRECTORIES>)

  unset(jsoncpp_FOUND) # guickfix module version check

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(JsonCPP DEFAULT_MSG
    JSONCPP_LIBRARIES JSONCPP_INCLUDE_DIR)
  mark_as_advanced(JSONCPP_LIBRARIES JSONCPP_INCLUDE_DIR)
else()
  message(FATAL_ERROR "jsoncpp_lib_static was not found")
endif()
