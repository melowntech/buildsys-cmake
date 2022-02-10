# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(lasziP REQUIRED CONFIG)

if (TARGET laszip::laszip)
  set(LASzip_FOUND TRUE)
  set(LASzip_VERSION ${lasziP_VERSION})
  set(LASzip_LIBRARIES laszip::laszip)
endif()