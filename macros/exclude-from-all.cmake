OPTION(BUILDSYS_EXCLUDE_FROM_ALL "Whether to exclude targets marked by exclude_from_all(TARGET) from target 'all'." ON)

if (BUILDSYS_EXCLUDE_FROM_ALL)
  set(EXCLUDE_STRING "EXCLUDED from")
else()
  set(EXCLUDE_STRING "INCLUDED in")
endif()

message(STATUS "Targets marked by exclude_from_all(TARGET) will be ${EXCLUDE_STRING} target 'all'")

macro(exclude_from_all TARGET)
  message(STATUS "${TARGET} ${EXCLUDE_STRING} target 'all'.")
  set_target_properties(${TARGET} PROPERTIES EXCLUDE_FROM_ALL ${BUILDSYS_EXCLUDE_FROM_ALL})
endmacro()
