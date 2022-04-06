find_package(OpenEXR CONFIG)

if (TARGET OpenEXR::OpenEXR)
  set(IlmBase_FOUND TRUE)
  set(IlmBase_VERSION ${OpenEXR_VERSION})
  set(IlmBase_LIBRARIES OpenEXR::OpenEXR)
endif()
