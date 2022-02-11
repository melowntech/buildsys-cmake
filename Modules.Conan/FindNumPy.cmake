# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(Python3 REQUIRED COMPONENTS NumPy) 

if (TARGET Python3::NumPy)
  set(NumPy_FOUND TRUE)
  set(NUMPY_FOUND TRUE)
  set(NumPy_LIBRARIES Python3::NumPy)
  set(NUMPY_LIBRARIES Python3::NumPy)
  set(NumPy_INCLUDE_DIR ${Python3_NumPy_INCLUDE_DIRS})
  set(NUMPY_INCLUDE_DIR ${Python3_NumPy_INCLUDE_DIRS})
endif()