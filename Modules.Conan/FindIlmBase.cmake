# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(openexR REQUIRED CONFIG)

if (TARGET OpenEXR::OpenEXR)
  set(IlmBase_FOUND TRUE)
  set(IlmBase_VERSION ${openexR_VERSION})
  set(IlmBase_LIBRARIES OpenEXR::OpenEXR)
endif()