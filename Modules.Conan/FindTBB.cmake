find_package(TBB CONFIG)

if (TARGET TBB::TBB)
  set(TBB_FOUND TRUE)
  set(TBB_VERSION ${TBB_VERSION})
  set(TBB_LIBRARIES TBB::TBB)
endif()
