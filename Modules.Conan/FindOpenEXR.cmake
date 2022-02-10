# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(openexR REQUIRED CONFIG)

if (TARGET OpenEXR::OpenEXR)
  set(OpenEXR_FOUND TRUE)
  set(OpenEXR_VERSION ${openexR_VERSION})
  set(OpenEXR_LIBRARIES OpenEXR::OpenEXR)
endif()