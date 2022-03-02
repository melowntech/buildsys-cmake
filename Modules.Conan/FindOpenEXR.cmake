find_package(OpenEXR REQUIRED CONFIG)

if (TARGET OpenEXR::OpenEXR)
  set(OpenEXR_FOUND TRUE)
  set(OpenEXR_VERSION ${OpenEXR_VERSION})
  set(OpenEXR_LIBRARIES OpenEXR::OpenEXR)
endif()