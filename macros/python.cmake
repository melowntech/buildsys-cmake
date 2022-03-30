macro(enable_python_impl VERSION)
  if(NOT Boost_FOUND)
    message(FATAL_ERROR "Please use find_package(Boost) first.")
  endif()

  if (BUILDSYS_CONAN)
    find_package(Python REQUIRED COMPONENTS Interpreter)
    set(PYTHON_EXECUTABLE ${Python_EXECUTABLE})
  else()
    find_package(PythonInterp ${VERSION} REQUIRED)
  endif()

  set(LONG_VERSION "${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}")
  set(SHORT_VERSION "${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")

  if (BUILDSYS_CONAN)
    find_package(Boost COMPONENTS python)  
  else()    
    find_package(Boost ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION} QUIET
      COMPONENTS
      python-${LONG_VERSION}
      python${SHORT_VERSION}
      python-py${SHORT_VERSION})
  endif()
  
  if(Boost_PYTHON_FOUND)
    set(PYLIB Boost_PYTHON)
  elseif(Boost_PYTHON-${LONG_VERSION}_FOUND)
    set(PYLIB Boost_PYTHON-${LONG_VERSION})
  elseif(Boost_PYTHON${SHORT_VERSION}_FOUND OR Boost_python${SHORT_VERSION}_FOUND)
    set(PYLIB Boost_PYTHON${SHORT_VERSION})
  elseif(Boost_PYTHON-PY${SHORT_VERSION}_FOUND)
    set(PYLIB Boost_PYTHON-PY${SHORT_VERSION})
  else()
    message(FATAL_ERROR "No boost python libraries found.")
  endif()

  # this must be manually set
  set(Boost_FOUND TRUE)

  foreach(var
      FOUND
      LIBRARY
      LIBRARIES
      LIBRARY_RELEASE
      LIBRARY_DEBUG
      LIBRARY-ADVANCED
      LIBRARY_RELEASE-ADVANCED
      LIBRARY_DEBUG-ADVANCED
      )
    set(Boost_PYTHON_${var} ${${PYLIB}_${var}})
  endforeach()

  # force for cmake-3.15
  set(Boost_PYTHON_FOUND ON)

  if (BUILDSYS_CONAN)
    find_package(Python REQUIRED COMPONENTS Interpreter Development)  
    set(PYTHON_EXECUTABLE ${Python_EXECUTABLE})
    set(PYTHONLIBS_FOUND ${PYTHON_FOUND})
  else()    
    find_package(PythonLibs ${PYTHON_VERSION_STRING} EXACT REQUIRED)
  endif()
  
  if(PYTHONLIBS_FOUND)
    set(PYTHONLIBS_LIBRARIES ${PYTHON_LIBRARIES})
    set(PYTHONLIBS_INCLUDE_PATH ${PYTHON_INCLUDE_PATH})
    set(PYTHONLIBS_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
  endif()

  # find python interpteter
  set(PYTHON ${PYTHON_EXECUTABLE})
  message(STATUS "Using ${PYTHON} as python${VERSION}")
  set(PYTHON_VERSION ${LONG_VERSION})
  set(PYTHON_MODULE_INSTALL_PATH "lib/python${PYTHON_VERSION}/dist-packages")
endmacro()

macro(enable_python VERSION)
  if (NOT PYTHON_VERSION)
    enable_python_impl(${VERSION})
  endif()
endmacro()

macro(check_python_module module found_var interpretter)
  execute_process(COMMAND "${interpretter}" -c
    "import sys\ntry: import ${module}\nexcept: sys.exit(-1)\nsys.exit(0)\n"
    RESULT_VARIABLE RETURN_CODE)
  if(RETURN_CODE EQUAL 0)
    set(${found_var} ON)
  else()
    set(${found_var} OFF)
  endif()
endmacro()

macro(add_python_extension TARGET)
  string(REPLACE "-" "_" name ${TARGET})

  add_library(${TARGET} MODULE ${ARGN})

  set_target_properties(${TARGET} PROPERTIES
    PREFIX ""
    OUTPUT_NAME ${name}
    )
  buildsys_library(${TARGET})
endmacro()
