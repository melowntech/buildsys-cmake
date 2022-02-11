# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(cereS REQUIRED CONFIG) 

if (TARGET Ceres::ceres)
  set(Ceres_FOUND TRUE)
  set(Ceres_VERSION ${cereS_VERSION})
  set(Ceres_LIBRARIES Ceres::ceres)
endif()