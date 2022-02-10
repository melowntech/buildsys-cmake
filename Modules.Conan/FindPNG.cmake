# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(pnG REQUIRED CONFIG)

if (TARGET PNG::PNG)
  set(PNG_FOUND TRUE)
  set(PNG_VERSION ${pnG_VERSION})
  set(PNG_LIBRARIES PNG::PNG)
endif()

# set(PNG_LIBRARIES PNG::PNG)

# add_library(PNG ALIAS PNG::PNG)
# get_target_property(PNG_INCLUDE_DIRS PNG::PNG INTERFACE_INCLUDE_DIRECTORIES)
# get_target_property(PNG_LIBRARY PNG::PNG INTERFACE_LINK_LIBRARIES)

# if(PNG_LIBRARY)
#   set(PNG_LIBRARIES "${PNG_LIBRARY}")
# endif()

# if(PNG_INCLUDE_DIR)
#   set(PNG_INCLUDE_DIRS "${PNG_INCLUDE_DIR}")
# endif()

# find_package_handle_standard_args(PNG DEFAULT_MSG
#   PNG_LIBRARIES PNG_INCLUDE_DIR)
# mark_as_advanced(PNG_LIBRARIES PNG_INCLUDE_DIR)
