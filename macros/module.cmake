# helper macro for define_module
macro(define_module_check_dependency name libs missing)
  set(FOUND TRUE)

  if(${name} STREQUAL Boost)
    if(NOT Boost_FOUND)
      list(APPEND ${missing} Boost)
    endif()
  else()
    unset(FOUND)
  endif()
endmacro()

macro(module_split_version input name compare version)
  set(rx "^([^>=<]+)([>=<]+)(.*)$")
  string(REGEX REPLACE "${rx}" "\\1" ${name} ${input})
  string(REGEX REPLACE "${rx}" "\\2" ${compare} ${input})
  string(REGEX REPLACE "${rx}" "\\3" ${version} ${input})
  if (${compare} STREQUAL ${name})
    set(${compare} "")
  endif()
  if (${version} STREQUAL ${name})
    set(${version} "")
  endif()
endmacro()

function(module_check_version module compareOperator checkVersion result)
  set(${result} TRUE PARENT_SCOPE)
  if(NOT checkVersion)
    return()
  endif()

  set(version ${MODULE_${module}_VERSION})
  if(NOT version)
    set(${result} FALSE PARENT_SCOPE)
    return()
  endif()

  if(compareOperator STREQUAL ">" AND NOT version VERSION_GREATER checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  elseif(compareOperator STREQUAL ">=" AND version VERSION_LESS checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  elseif(compareOperator STREQUAL "=" AND NOT version VERSION_EQUAL checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  elseif(compareOperator STREQUAL "<=" AND version VERSION_GREATER checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  endif()
endfunction()

# Define module (library or binary)
# Checks for dependencies and builds list of libraries it depends on
macro(define_module MODULE_TYPE MODULE_NAME_VERSION DEPENDS)
  if(NOT (${DEPENDS} STREQUAL "DEPENDS"))
    message(FATAL_ERROR "define_module: missing DEPENDS")
  endif()

  if(${MODULE_TYPE} STREQUAL "LIBRARY")
    set(TYPE_LIBRARY TRUE)
  elseif(${MODULE_TYPE} STREQUAL "BINARY")
    set(TYPE_BINARY TRUE)
  else()
    message(FATAL_ERROR "define_module: invalid argument MODULE_TYPE: ${MODULE_TYPE}")
  endif()

  module_split_version(${MODULE_NAME_VERSION} name compare module_version)
  if(compare AND NOT compare STREQUAL "=")
    message(FATAL_ERROR "${MODULE_NAME}: invalid module name ${MODULE_NAME_VERSION}.")
  endif()
  set(MODULE_NAME "${name}")

  unset(libs)
  unset(missing)
  unset(definitions)

  set(depends_mode TRUE)

  foreach(atom ${ARGN})
    if(${atom} STREQUAL "DEFINITIONS")
      # switch to depends definitions
      set(depends_mode FALSE)

    elseif(${atom} STREQUAL "DEPENDS")
      # switch to depends mode
      set(depends_mode TRUE)

    elseif(depends_mode)
      set(fullAtom "${atom}")
      module_split_version(${atom} atom compareOperator version)

      # dependency
      define_module_check_dependency(${atom} libs missing)
      if (NOT FOUND AND NOT ${atom}_FOUND)
        if(NOT MODULE_${atom}_FOUND)
          LIST(APPEND missing ${atom})
        else()
          module_check_version("${atom}" "${compareOperator}" "${version}"
            checkResult)

          if(NOT checkResult)
            LIST(APPEND missing ${fullAtom})
          else()
            # add dependency to our libraries
            list(APPEND libs ${atom})
            # add dependency's definitions to our definitions
            list(APPEND definitions ${MODULE_${atom}_DEFINITIONS})
          endif()
        endif()
      else()
        # add dependency's libraries to our libraries
        list(APPEND libs ${${atom}_LIBRARIES})
        # TODO: split -DX to _DEFINITIONS and other stuff to _FLAGS
        # do nothing now

        # add dependency's definitions to our definitions
        # list(APPEND definitions ${${atom}_DEFINITIONS})
      endif()

    else()
      # definition
      list(APPEND definitions ${atom})

    endif()
  endforeach()

  # anything missing -> fail
  if(missing)
    message(FATAL_ERROR "${MODULE_NAME}: missing dependencies: ${missing}")
  endif()


  # extra libraries that has to be linked to binaries (injected dependencies
  # from outside)
  if(TYPE_BINARY)
    list(APPEND libs ${BINARY_MODULES_LINK_LIBRARIES})
  endif()

  # remove duplicates from definitions
  if(definitions)
    list(REMOVE_DUPLICATES definitions)
  endif()

  # set LIBRARIES
  set(MODULE_LIBRARIES ${libs})
  set(MODULE_${MODULE_NAME}_LIBRARIES ${libs})
  set(MODULE_${MODULE_NAME}_LIBRARIES ${libs} PARENT_SCOPE)

  # set DEFINITIONS
  set(MODULE_DEFINITIONS ${definitions})
  set(MODULE_${MODULE_NAME}_DEFINITIONS ${definitions})
  set(MODULE_${MODULE_NAME}_DEFINITIONS ${definitions} PARENT_SCOPE)

  # set VERSION
  if(module_version)
    set(MODULE_${MODULE_NAME}_VERSION ${module_version})
    set(MODULE_${MODULE_NAME}_VERSION ${module_version} PARENT_SCOPE)
  endif()

  # mark as found
  set(MODULE_${MODULE_NAME}_FOUND TRUE)
  set(MODULE_${MODULE_NAME}_FOUND TRUE PARENT_SCOPE)

  # add current binary dir to includes (we can find generated files)
  include_directories(${CMAKE_CURRENT_BINARY_DIR})
endmacro()

# switch on building of target
macro(buildsys_build_target target)
  set(BUILDSYS_BUILD_TARGET_${target} TRUE)
  unset(BUILDSYS_NOBUILD_TARGET_${target})
endmacro()

# switch off building of target
macro(buildsys_nobuild_target target)
  set(BUILDSYS_NOBUILD_TARGET_${target} TRUE)
  unset(BUILDSYS_BUILD_TARGET_${target})
endmacro()

macro(buildsys_optional_target target)
  set(BUILDSYS_BUILD_TARGET_${target} FALSE
    CACHE BOOL "Enables/disables building of target ${target}.")
endmacro()
