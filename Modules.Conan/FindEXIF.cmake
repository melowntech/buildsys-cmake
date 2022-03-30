find_package(libexif CONFIG) 

if (TARGET libexif::libexif)
  set(EXIF_FOUND TRUE)
  set(EXIF_VERSION ${libexif_VERSION})
  set(EXIF_LIBRARIES libexif::libexif)
endif()
