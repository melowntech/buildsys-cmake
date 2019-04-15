# - Try to find Markdown
# Once done, this will define
#
#  Markdown_FOUND - system has Markdown
#  Markdown_INCLUDE_DIRS - the Markdown include directories
#  Markdown_LIBRARIES - link these to use Markdown

find_path(Markdown_INCLUDE_DIR
  NAMES mkdio.h
  )

# Finally the library itself
find_library(Markdown_LIBRARY
  NAMES markdown
  )

set(Markdown_INCLUDE_DIRS ${Markdown_INCLUDE_DIR})
set(Markdown_LIBRARIES ${Markdown_LIBRARY})

include_directories(${Markdown_INCLUDE_DIRS})

try_run(rr cr ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_LIST_DIR}/FindMarkdown.c
  LINK_LIBRARIES ${Markdown_LIBRARIES}
  RUN_OUTPUT_VARIABLE Markdown_VERSION)
if(NOT rr)
  string(STRIP "${Markdown_VERSION}" Markdown_VERSION)
else()
  unset(Markdown_VERSION)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Markdown
  VERSION_VAR Markdown_VERSION
  REQUIRED_VARS Markdown_LIBRARIES Markdown_INCLUDE_DIRS Markdown_VERSION
  )

mark_as_advanced(Markdown_INCLUDE_DIR Markdown_LIBRARIES Markdown_VERSION)
