# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(mgtS REQUIRED CONFIG)

if (TARGET mgts::mgts)
  set(MGTS_FOUND TRUE)
  set(MGTS_VERSION ${mgtS_VERSION})
  set(MGTS_LIBRARIES mgts::mgts)
endif()

# get_target_property(MGTS_LIBRARIES mgts::mgts INTERFACE_LINK_LIBRARIES)
# get_target_property(MGTS_INCLUDE_DIRS mgts::mgts INTERFACE_INCLUDE_DIRECTORIES)

# include(FindPackageHandleStandardArgs)

# find_package_handle_standard_args(MGTS DEFAULT_MSG
#     MGTS_LIBRARIES
#     MGTS_INCLUDE_DIRS)

# mark_as_advanced(MGTS_INCLUDE_DIR MGTS_LIBRARIES)
