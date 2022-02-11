# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(cryptopP REQUIRED CONFIG) 

if (TARGET cryptopp::cryptopp)
  set(CRYPTO++_FOUND TRUE)
  set(CRYPTO++_VERSION ${cryptopP_VERSION})
  set(CRYPTO++_LIBRARIES cryptopp::cryptopp)
elseif(TARGET cryptopp::cryptopp-shared)
  set(CRYPTO++_FOUND TRUE)
  set(CRYPTO++_VERSION ${cryptopP_VERSION})
  set(CRYPTO++_LIBRARIES cryptopp::cryptopp-shared)
endif()