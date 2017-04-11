macro(enable_python VERSION)
  if(NOT Boost_FOUND)
    message(FATAL_ERROR "Please use find_package(Boost) first.")
  endif()

  string(REPLACE "." "" SHORT_VERSION "${VERSION}")

  find_package(Boost ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION} QUIET
    COMPONENTS python-${VERSION} python-py${SHORT_VERSION})

  if(Boost_PYTHON-${VERSION}_FOUND)
    set(PYLIB Boost_PYTHON-${VERSION})
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

  find_package(PythonLibs ${VERSION} REQUIRED)
  if(PYTHONLIBS_FOUND)
    set(PYTHONLIBS_LIBRARIES ${PYTHON_LIBRARIES})
    set(PYTHONLIBS_INCLUDE_PATH ${PYTHON_INCLUDE_PATH})
    set(PYTHONLIBS_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
  endif()

  # find python interpteter
  find_program(PYTHON python${VERSION})
  if(NOT PYTHON)
    message(FATAL_ERROR "Cannot find python${VERSION}")
  endif()
  message(STATUS "Using ${PYTHON} as python${VERSION}")
  set(PYTHON_VERSION ${VERSION})
  set(PYTHON_MODULE_INSTALL_PATH "lib/python${PYTHON_VERSION}/dist-packages")
endmacro()
