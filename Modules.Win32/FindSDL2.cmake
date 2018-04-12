# FindSDL2: compatibility

# backup CMAKE_MODULE_PATH and remove this directory from it
# NB: find should return valid entry since this file has been found
set(backup_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
list(FIND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR} index)
list(REMOVE_AT CMAKE_MODULE_PATH ${index})

set(arguments)
foreach(name REQUIRED QUIETLY VERSION)
  set(var SDL2_FIND_${name})
  if(${var})
    list(APPEND arguments ${name})
    list(APPEND arguments ${var})
  endif()
endforeach()

# find SDL2 module
find_package(SDL2 ${arguments})

# and return back
set(CMAKE_MODULE_PATH "${backup_CMAKE_MODULE_PATH}")

# forward if found
if(SDL2_FOUND)
  set(SDL2_LIBRARIES SDL2::SDL2)
  set(SDL2_INCLUDE_DIR $<TARGET_PROPERTY:SDL2::SDL2,INTERFACE_INCLUDE_DIRECTORIES>)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(SDL2 DEFAULT_MSG
    SDL2_LIBRARIES SDL2_INCLUDE_DIR)
  mark_as_advanced(SDL2_LIBRARIES SDL2_INCLUDE_DIR)
endif()
