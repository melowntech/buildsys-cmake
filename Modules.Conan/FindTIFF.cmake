# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(tifF REQUIRED CONFIG) 

if (TARGET TIFF::TIFF)
  set(TIFF_FOUND TRUE)
  set(TIFF_VERSION ${tifF_VERSION})
  set(TIFF_LIBRARIES TIFF::TIFF)
endif()

# add_library(TIFF ALIAS TIFF::TIFF)
# get_target_property(TIFF_INCLUDE_DIRS TIFF::TIFF INTERFACE_INCLUDE_DIRECTORIES)
# get_target_property(TIFF_LIBRARIES TIFF::TIFF INTERFACE_LINK_LIBRARIES)

# set(TIFF_LIBRARIES TIFF::TIFF)

# include(FindPackageHandleStandardArgs)
# find_package_handle_standard_args(TIFF
#   FOUND_VAR TIFF_FOUND
#   REQUIRED_VARS
#   TIFF_LIBRARIES
#   TIFF_INCLUDE_DIRS)
# mark_as_advanced(TIFF_INCLUDE_DIRS TIFF_LIBRARIES)