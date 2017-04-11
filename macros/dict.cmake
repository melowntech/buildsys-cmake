macro(dict command dict)
  if(${command} STREQUAL SET)
    set(key ${ARGV2})
    set(value ${ARGV3})

    # find key
    list(FIND ${dict} ${key} idx)
    if(${idx} EQUAL -1)
      # not found
      list(APPEND ${dict} ${key} ${value})
    else()
      math(EXPR idx ${idx} + 1)
      list(REMOVE_AT ${dict} ${idx})
      list(INSERT ${dict} ${idx} ${value})
    endif()
  elseif(${command} STREQUAL GET)
    set(key ${ARGV2})
    set(out ${ARGV3})

    # find key
    list(FIND ${dict} ${key} idx)
    if(${idx} EQUAL -1)
      # not found
      set(${out} "${key}-NOTFOUND")
    else()
      math(EXPR idx "${idx} + 1")
      list(GET ${dict} ${idx} ${out})
    endif()
  else()
    message(FATAL_ERROR "dict does not recognize sub-command ${command}")
  endif()
endmacro()
