# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(libexiF REQUIRED CONFIG) 

if (TARGET libexif::libexif)
  set(EXIF_FOUND TRUE)
  set(EXIF_VERSION ${libexiF_VERSION})
  set(EXIF_LIBRARIES libexif::libexif)
endif()