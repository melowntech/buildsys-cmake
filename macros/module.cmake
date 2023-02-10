macro(module_split_version input name compare version)
  set(rx "^([^>=<~]+)([>=<~]+)(.*)$")
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

function(module_check_version moduleVersion compareOperator checkVersion result)
  set(${result} TRUE PARENT_SCOPE)
  if(NOT checkVersion)
    return()
  endif()

  if(NOT moduleVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  endif()

  if(compareOperator STREQUAL ">" AND NOT moduleVersion VERSION_GREATER checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  elseif(compareOperator STREQUAL ">=" AND moduleVersion VERSION_LESS checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  elseif(compareOperator STREQUAL "=" AND NOT moduleVersion VERSION_EQUAL checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  elseif(compareOperator STREQUAL "<=" AND moduleVersion VERSION_GREATER checkVersion)
    set(${result} FALSE PARENT_SCOPE)
    return()
  endif()
endfunction()

macro(_module_split_compatibility input name version)
  set(rx "^([^~]+)~(.*)$")
  string(REGEX REPLACE "${rx}" "\\1" ${name} "${input}")
  string(REGEX REPLACE "${rx}" "\\2" ${version} "${input}")
  if (${version} STREQUAL ${name})
    set(${version} "")
  endif()
endmacro()

file(WRITE ${CMAKE_BINARY_DIR}/module.list)

macro(_update_module_list TYPE MODULE)
  file(APPEND ${CMAKE_BINARY_DIR}/module.list "${TYPE}: ${MODULE}\n")
endmacro()

macro(_module_split_breaks input version what)
  set(rx "^([^:]+)(:)\"?([^\"]*)\"?$")
  string(REGEX REPLACE "${rx}" "\\1" ${version} ${input})
  string(REGEX REPLACE "${rx}" "\\2" colon ${input})
  string(REGEX REPLACE "${rx}" "\\3" ${what} ${input})
endmacro()

macro(_collect_broken broken atom version cversion)
  set(BREAKS "${MODULE_${atom}_BREAKS}")

  list(LENGTH BREAKS clen)
  if ("${version}" AND clen GREATER 1)
    math(EXPR clen "${clen} - 1")
    foreach(ci RANGE 0 ${clen} 2)
      list(GET BREAKS ${ci} bversion)
      if ("${cversion}" VERSION_GREATER_EQUAL bversion)
        # ignore
      elseif (${version} VERSION_LESS bversion)
        math(EXPR ci "${ci} + 1")
        list(GET BREAKS ${ci} bwhat)
        list(APPEND ${broken} "${atom}" "${bversion}" "${bwhat}")
      endif()
    endforeach()
  endif()
endmacro()

macro(_resolve_broken msg broken)
  list(LENGTH broken blen)
  if(blen GREATER 2)
    math(EXPR blen "${blen} - 1")
    foreach(bi RANGE 0 ${blen} 3)
      list(GET broken ${bi} bname)
      math(EXPR bi "${bi} + 1")
      list(GET broken ${bi} bversion)
      math(EXPR bi "${bi} + 1")
      list(GET broken ${bi} bwhat)

      set(${msg} "${${msg}}\n  ${bname}=${MODULE_${bname}_VERSION} deviates from \
\"${bwhat}\" in versions before ${bversion}.\n  Either mark ${bname} dependency \
as compatible by appending ~${bversion}\n  or update your code and ONLY then \
update dependency to ${bname}>=${bversion}.")
    endforeach()
  endif()
endmacro()

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
  unset(module_breaks)
  unset(broken)
  unset(provided_targets)
  set(has_provided_targets FALSE)

  set(supported_modes "DEPENDS;DEFINITIONS;BREAKS;PROVIDES")
  set(mode "DEPENDS")

  foreach(atom ${ARGN})
    if(atom IN_LIST supported_modes)
      # switch to new mode
      set(mode "${atom}")

    elseif(mode STREQUAL "DEPENDS")
      set(fullAtom "${atom}")
      module_split_version(${atom} atom compareOperator version)

      # dependency
      if (MODULE_${atom}_FOUND # module "atom"
          OR (TARGET ${atom}  # target "atom" without "atom"_FOUND
            AND NOT ${atom}_FOUND)
          )
        if(NOT MODULE_${atom}_FOUND)
          if(TARGET ${atom})
            list(APPEND libs ${atom})
          else()
            LIST(APPEND missing ${atom})
          endif()
        else()
          _module_split_compatibility("${version}" version cversion)
          module_check_version("${MODULE_${atom}_VERSION}" "${compareOperator}"
            "${version}" checkResult)

          _collect_broken(broken "${atom}" "${version}" "${cversion}")

          if(NOT checkResult)
            LIST(APPEND missing ${fullAtom})
          else()
            # add dependency to our libraries
            list(APPEND libs ${MODULE_${atom}_TARGETS})
            # add dependency's definitions to our definitions
            list(APPEND definitions ${MODULE_${atom}_DEFINITIONS})
          endif()
        endif()
      else()
        # old "atom"_FOUND
        module_check_version("${${atom}_VERSION}" "${compareOperator}" "${version}"
          checkResult)

        if(NOT checkResult)
          LIST(APPEND missing ${fullAtom})
        else()
          # add dependency's libraries to our libraries
          list(APPEND libs ${${atom}_LIBRARIES})
          # TODO: split -DX to _DEFINITIONS and other stuff to _FLAGS
          # do nothing now

          # add dependency's definitions to our definitions
          # list(APPEND definitions ${${atom}_DEFINITIONS})
        endif()
      endif()

    elseif(mode STREQUAL "DEFINITIONS")
      # definition
      list(APPEND definitions ${atom})

    elseif(mode STREQUAL "BREAKS")
      # breaks version
      _module_split_breaks("${atom}" breaks_version breaks_what)
      list(APPEND module_breaks "${breaks_version}")
      list(APPEND module_breaks "${breaks_what}")
      
    elseif(mode STREQUAL "PROVIDES")
      # add given name to to provided targets
      list(APPEND provided_targets ${atom})
      set(has_provided_targets TRUE)
    else()
      message(FATAL_ERROR "${MODULE_NAME}: INTERNAL ERROR unsupported mode ${mode}")
    endif()
  endforeach()

  # anything missing -> fail
  if(missing)
    message(FATAL_ERROR "${MODULE_NAME}: missing dependencies: ${missing}")
  endif()

  _resolve_broken(msg "${broken}")

  if(msg)
    message(FATAL_ERROR "${MODULE_NAME}: broken functionality:${msg}")
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

  if(NOT has_provided_targets)
    list(APPEND provided_targets ${MODULE_NAME})
  endif()

  # set TARGETS
  set(MODULE_TARGETS ${libs})
  set(MODULE_${MODULE_NAME}_TARGETS ${provided_targets})
  set(MODULE_${MODULE_NAME}_TARGETS ${provided_targets} PARENT_SCOPE)

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

  # set BREAKS
  if(module_breaks)
    set(MODULE_${MODULE_NAME}_BREAKS ${module_breaks})
    set(MODULE_${MODULE_NAME}_BREAKS ${module_breaks} PARENT_SCOPE)
  endif()

  # mark as found
  set(MODULE_${MODULE_NAME}_FOUND TRUE)
  set(MODULE_${MODULE_NAME}_FOUND TRUE PARENT_SCOPE)

  # add current binary dir to includes (we can find generated files)
  include_directories(${CMAKE_CURRENT_BINARY_DIR})

  _update_module_list(${MODULE_TYPE} ${MODULE_NAME_VERSION})
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
