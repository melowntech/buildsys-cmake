# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(proJ REQUIRED CONFIG)

if (TARGET PROJ::proj)
  set(PROJ_FOUND TRUE)
  set(PROJ_VERSION ${proJ_VERSION})
  set(PROJ_LIBRARIES PROJ::proj)
endif()

# add_library(PROJ ALIAS PROJ::proj)
# get_target_property(PROJ_INCLUDE_DIR PROJ::proj INTERFACE_INCLUDE_DIRECTORIES)
# get_target_property(PROJ_LIBRARIES PROJ::proj INTERFACE_LINK_LIBRARIES)