find_package(TBB CONFIG)

if (TARGET TBB::TBB)
  set(TBB_FOUND TRUE)
  set(TBB_VERSION ${TBB_VERSION})
  set(TBB_LIBRARIES TBB::TBB)
  get_target_property(TBB_INCLUDE_DIRS TBB::TBB INTERFACE_INCLUDE_DIRECTORIES)
  set(TBB_INCLUDE_DIR ${TBB_INCLUDE_DIRS})
endif()

