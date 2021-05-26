###############################################################################
#
# CMake module to search for LASzip library
#
# On success, the macro sets the following variables:
# LASZIP_FOUND       = if the library found
# LASZIP_LIBRARIES   = full path to the library
# LASZIP_INCLUDE_DIR = where to find the library headers also defined,
#                       but not for general use are
# LASZIP_LIBRARY     = where to find the laszip library.
# LASZIP_VERSION     = version of library which was found, e.g. "1.2.5"
#
# Copyright (c) 2009 Mateusz Loskot <mateusz@loskot.net>
#
# Module source: http://github.com/mloskot/workshop/tree/master/cmake/
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
#
# Modified by Vaclav Blazek <vaclav.blazek@melowntech.com>
#
###############################################################################

if(LASZIP_INCLUDE_DIR)
  # Already in cache, be silent
  set(LASZIP_FIND_QUIETLY TRUE) #
endif()

find_path(LASZIP_INCLUDE_DIR
  NAMES laszip/laszip_api_version.h
  )

find_library(LASZIP_LIBRARY
  NAMES laszip
  )

if(LASZIP_INCLUDE_DIR)
  set(LASZIP_VERSION_H "${LASZIP_INCLUDE_DIR}/laszip/laszip_api_version.h")
  file(READ ${LASZIP_VERSION_H} LASZIP_VERSION_H_CONTENTS)

  if (DEFINED LASZIP_VERSION_H_CONTENTS)
    string(REGEX REPLACE ".*#define[ \t]LASZIP_API_VERSION_MAJOR[ \t]+([0-9]+).*" "\\1" LASZIP_VERSION_MAJOR "${LASZIP_VERSION_H_CONTENTS}")
    string(REGEX REPLACE ".*#define[ \t]LASZIP_API_VERSION_MINOR[ \t]+([0-9]+).*" "\\1" LASZIP_VERSION_MINOR "${LASZIP_VERSION_H_CONTENTS}")
    string(REGEX REPLACE ".*#define[ \t]LASZIP_API_VERSION_PATCH[ \t]+([0-9]+).*"   "\\1" LASZIP_VERSION_PATCH   "${LASZIP_VERSION_H_CONTENTS}")

    if(NOT "${LASZIP_VERSION_MAJOR}" MATCHES "^[0-9]+$")
      message(FATAL_ERROR "LASzip version parsing failed for \"LASZIP_API_VERSION_MAJOR\"")
    endif()
    if(NOT "${LASZIP_VERSION_MINOR}" MATCHES "^[0-9]+$")
      message(FATAL_ERROR "LASzip version parsing failed for \"LASZIP_VERSION_MINOR\"")
    endif()
    if(NOT "${LASZIP_VERSION_PATCH}" MATCHES "^[0-9]+$")
      message(FATAL_ERROR "LASzip version parsing failed for \"LASZIP_VERSION_PATCH\"")
    endif()

    set(LASZIP_VERSION "${LASZIP_VERSION_MAJOR}.${LASZIP_VERSION_MINOR}.${LASZIP_VERSION_PATCH}"
      CACHE INTERNAL "The version string for LASzip library")
  endif()
else()
  unset(LASZIP_VERSION)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LASzip
  VERSION_VAR LASZIP_VERSION
  REQUIRED_VARS LASZIP_LIBRARY LASZIP_INCLUDE_DIR LASZIP_VERSION
  )

if(LASZIP_FOUND)
  set(LASZIP_LIBRARIES ${LASZIP_LIBRARY})
endif()

