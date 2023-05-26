macro(enable_TensorRT_impl)
  if(MSVC)
    if(NOT ENV{TENSORRT_ROOT})
      message(FATAL_ERROR "Environment variable TENSORRT_ROOT not defined! Unable to find TensorRT!")
    endif()

    # Copy TensorRT DLLs and create cmake targets
    file(GLOB TensorRT_DLLS "$ENV{TENSORRT_ROOT}/lib/*.dll")
    foreach(_TensorRT_DLL_PATH ${TensorRT_DLLS})
      get_filename_component(_TensorRT_DLL_LIB ${_TensorRT_DLL_PATH} NAME_WE)
      get_filename_component(_TensorRT_DLL_NAME ${_TensorRT_DLL_PATH} NAME)
      get_filename_component(_TensorRT_DLL_DIR ${_TensorRT_DLL_PATH} DIRECTORY )
      configure_file(${_TensorRT_DLL_PATH} ${CMAKE_BINARY_DIR}/bin/${_TensorRT_DLL_NAME} COPYONLY)
      set(_TensorRT_DLL_TARGET _TensorRT_dll_target_${_TensorRT_DLL_LIB})
      add_library(${_TensorRT_DLL_TARGET} SHARED IMPORTED GLOBAL)
      set_target_properties(${_TensorRT_DLL_TARGET} PROPERTIES
        IMPORTED_LOCATION "${CMAKE_BINARY_DIR}/bin/${_TensorRT_DLL_NAME}"
        IMPORTED_IMPLIB "${_TensorRT_DLL_DIR}/${_TensorRT_DLL_LIB}.lib")
    endforeach()
  endif()

  find_package(nvinfer MODULE REQUIRED)
  find_package(nvonnxparser MODULE REQUIRED)

  add_library(nvinfer INTERFACE)
  target_include_directories(nvinfer INTERFACE ${NVINFER_INCLUDE_DIRS})
  if(NOT MSVC)
    target_link_libraries(nvinfer INTERFACE ${NVINFER_LIBRARIES})
  else()
    foreach(_NVINFER_LIB_ ${NVINFER_LIBRARIES})
      get_filename_component(_LIB_NAME_ ${_NVINFER_LIB_} NAME_WE)
      target_link_libraries(nvinfer INTERFACE _TensorRT_dll_target_${_LIB_NAME_})
    endforeach()
  endif()

  add_library(nvonnxparser INTERFACE)
  target_include_directories(nvonnxparser INTERFACE ${NVONNXPARSER_INCLUDE_DIRS})
  if(NOT MSVC)
    target_link_libraries(nvonnxparser INTERFACE ${NVONNXPARSER_LIBRARIES})
  else()
    foreach(_NVONNXPARSER_LIB_ ${NVONNXPARSER_LIBRARIES})
      get_filename_component(_LIB_NAME_ ${_NVONNXPARSER_LIB_} NAME_WE)
      target_link_libraries(nvonnxparser INTERFACE _TensorRT_dll_target_${_LIB_NAME_})
    endforeach()
  endif()

  add_definitions(-DHAS_TENSORRT)

endmacro()

macro(enable_TensorRT)
  enable_TensorRT_impl()
endmacro()
