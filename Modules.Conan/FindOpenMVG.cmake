find_package(openmvg REQUIRED CONFIG)

if (TARGET openmvg::openmvg)
  set(OPENMVG_FOUND TRUE)
  set(OPENMVG_VERSION ${openmvg_VERSION})
  set(OPENMVG_LIBRARIES openmvg::openmvg)
  set(vlsift_FOUND TRUE)
  set(vlsift_LIBRARIES openmvg::openmvg)
endif()
