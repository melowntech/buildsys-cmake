macro(enable_torch_impl)
  if(NOT BUILDSYS_CONAN)
    if(NOT PYTHON_EXECUTABLE)
      message(STATUS "No PYTHON_EXECUTABLE found. Use enable_python(version).")
    else()
      execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
        "import torch.utils; print(torch.utils.cmake_prefix_path)\n"
        OUTPUT_VARIABLE TORCH_INSTALL_PREFIX
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET)
    endif()
    find_package(Torch REQUIRED PATHS ${TORCH_INSTALL_PREFIX} NO_DEFAULT_PATH)
  else()
    find_package(Torch REQUIRED)
  endif()
  
  if (MSVC)
    file(GLOB TORCH_DLLS "${TORCH_INSTALL_PREFIX}/lib/*.dll")
    foreach(_TORCH_DLL_PATH ${TORCH_DLLS})
      # copy torch dll
      get_filename_component(_TORCH_DLL_LIB ${_TORCH_DLL_PATH} NAME_WE)
      get_filename_component(_TORCH_DLL_NAME ${_TORCH_DLL_PATH} NAME)
      configure_file(${_TORCH_DLL_PATH} ${CMAKE_BINARY_DIR}/bin/${_TORCH_DLL_NAME} COPYONLY)
      set(_TORCH_DLL_LIB _torch_dll_lib_${_TORCH_DLL_LIB})
      add_library(${_TORCH_DLL_LIB} SHARED IMPORTED GLOBAL)
      set_target_properties(${_TORCH_DLL_LIB} PROPERTIES IMPORTED_LOCATION ${CMAKE_BINARY_DIR}/bin/${_TORCH_DLL_NAME})
    endforeach()
  endif()
endmacro()

macro(enable_torch)
  if(NOT BUILDSYS_DISABLE_TORCH)
    enable_torch_impl()
    message(STATUS "Enabling Torch support (can be disabled by setting BUILDSYS_DISABLE_TORCH variable).")
  else()
    message(STATUS "Disabling Torch support because of BUILDSYS_DISABLE_TORCH.")
    set(TORCH_FOUND OFF)
  endif()
endmacro()
