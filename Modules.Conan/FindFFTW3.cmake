# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(fftW3 REQUIRED CONFIG) 

if (TARGET FFTW3::fftw3)
  set(FFTW3_FOUND TRUE)
  set(FFTW3_VERSION ${fftW3_VERSION})
  set(FFTW3_LIBRARIES FFTW3::fftw3)
endif()