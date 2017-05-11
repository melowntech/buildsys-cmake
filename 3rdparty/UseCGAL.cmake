#
# Tweaked to be usable in Melown's build system
#

#
# UseCGAL.cmake can be included in a project to set the needed compiler and
# linker settings to use CGAL in a program.
#
# The variables used here are defined in the CGALConfig.cmake generated when
# CGAL was installed.
#

set(ORIGINAL_CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH})

set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)

include(${CGAL_MODULES_DIR}/CGAL_Macros.cmake)
cgal_setup_module_path()

if(NOT USE_CGAL_FILE_INCLUDED)
  set(USE_CGAL_FILE_INCLUDED 1)

  include(${CGAL_MODULES_DIR}/CGAL_Common.cmake)
  include(${CGAL_MODULES_DIR}/CGAL_GeneratorSpecificSettings.cmake)

  set(CGAL_LIBRARIES)

  foreach(CGAL_COMPONENT ${CGAL_REQUESTED_COMPONENTS})
    if(COMMAND use_component)
      use_component(${CGAL_COMPONENT})
    else()
      if(WITH_CGAL_${CGAL_COMPONENT})
        if(TARGET CGAL_${CGAL_COMPONENT})
          add_to_list(CGAL_LIBRARIES CGAL_${CGAL_COMPONENT})
        else()
          add_to_list(CGAL_LIBRARIES ${CGAL_${CGAL_COMPONENT}_LIBRARY})
        endif()

        add_to_list(CGAL_3RD_PARTY_LIBRARIES
          ${CGAL_${CGAL_COMPONENT}_3RD_PARTY_LIBRARIES})

        add_to_list(CGAL_3RD_PARTY_INCLUDE_DIRS
          ${CGAL_${CGAL_COMPONENT}_3RD_PARTY_INCLUDE_DIRS})
        add_to_list(CGAL_3RD_PARTY_DEFINITIONS
          ${CGAL_${CGAL_COMPONENT}_3RD_PARTY_DEFINITIONS})
        add_to_list(CGAL_3RD_PARTY_LIBRARIES_DIRS
          ${CGAL_${CGAL_COMPONENT}_3RD_PARTY_LIBRARIES_DIRS})
      endif()
    endif()
  endforeach()

  if(COMMAND use_essential_libs)
    use_essential_libs()
  endif()

  include_directories("${CMAKE_CURRENT_BINARY_DIR}")

  if(NOT CGAL_LIBRARY)
    cache_get(CGAL_LIBRARY)
  endif()
  list(APPEND CGAL_LIBRARIES ${CGAL_LIBRARY})

  list(APPEND CGAL_INCLUDE_DIRS ${CGAL_3RD_PARTY_INCLUDE_DIRS})
  list(APPEND CGAL_DEFINITIONS ${CGAL_3RD_PARTY_DEFINITIONS})

  list(APPEND CGAL_LIBRARIES ${CGAL_3RD_PARTY_LIBRARIES})
endif()

set(CMAKE_MODULE_PATH ${ORIGINAL_CMAKE_MODULE_PATH})
