macro(enable_torch_impl)
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
