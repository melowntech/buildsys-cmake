macro(enable_python VERSION)
  if(NOT Boost_FOUND)
    message(FATAL_ERROR "Please use find_package(Boost) first.")
  endif()

  find_package(PythonInterp ${VERSION} REQUIRED)

  set(LONG_VERSION "${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}")
  set(SHORT_VERSION "${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")

  find_package(Boost ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION} QUIET
    COMPONENTS
    python-${LONG_VERSION}
    python${SHORT_VERSION}
    python-py${SHORT_VERSION}
    )

  if(Boost_PYTHON-${LONG_VERSION}_FOUND)
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

  find_package(PythonLibs ${PYTHON_VERSION_STRING} EXACT REQUIRED)
  if(PYTHONLIBS_FOUND)
    set(PYTHONLIBS_LIBRARIES ${PYTHON_LIBRARIES})
    set(PYTHONLIBS_INCLUDE_PATH ${PYTHON_INCLUDE_PATH})
    set(PYTHONLIBS_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
  endif()

  # find python interpteter
  set(PYTHON ${PYTHON_EXECUTABLE})
  message(STATUS "Using ${PYTHON} as python${VERSION}")
  set(PYTHON_VERSION ${VERSION_LONG})
  set(PYTHON_MODULE_INSTALL_PATH "lib/python${PYTHON_VERSION}/dist-packages")
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
  set_target_properties(vadstena-test-pymodule PROPERTIES
    PREFIX ""
    OUTPUT_NAME ${name}
    )
  buildsys_library(${TARGET})
endmacro()
