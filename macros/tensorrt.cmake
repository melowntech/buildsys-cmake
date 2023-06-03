macro(enable_TensorRT_impl)

  if(BUILDSYS_CONAN)
    find_package(TensorRT REQUIRED)
  else()
    find_package(nvinfer MODULE REQUIRED)
    find_package(nvonnxparser MODULE REQUIRED)
  endif()
  
  add_definitions(-DHAS_TENSORRT)

endmacro()

macro(enable_TensorRT)
  enable_TensorRT_impl()
endmacro()
