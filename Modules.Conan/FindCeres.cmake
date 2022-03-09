find_package(Ceres REQUIRED CONFIG) 

if (TARGET Ceres::ceres)
  set(Ceres_FOUND TRUE)
  set(Ceres_VERSION ${Ceres_VERSION})
  set(Ceres_LIBRARIES Ceres::ceres)
endif()
