# set(BUILDSYS_CONAN TRUE)
# setup_conan_build_dependencies(
#   "mlwn" "https://gitlab.mlwn.se/api/v4/projects/447/packages/conan"
#   "${CMAKE_CURRENT_LIST_DIR}/conanfile.txt"
#   "${CMAKE_CURRENT_LIST_DIR}/requirements.txt"
#)

macro(setup_conan_build_dependencies 
  CONAN_REMOTE_NAME
  CONAN_PACKAGES_REMOTE
  CONAN_FILE
  PIP_REQUIREMENTS
)
  if(BUILDSYS_CONAN)

    message(STATUS "")
    message(STATUS "****************************")
    message(STATUS "* Preparing Conan build ... ")
    message(STATUS "* BUILDSYS_CONAN = TRUE     ")
    message(STATUS "")

    # backup PATH environment variable
    set(ENV_BACKUP "$ENV{PATH}")

    # get tools (python, pip, conan)
    find_package(Python3 COMPONENTS Interpreter REQUIRED QUIET)
    set(CONAN_BINARY ${Python3_EXECUTABLE} -m conans.conan)
    set(PIP_BINARY ${Python3_EXECUTABLE} -m pip)
    
    # (enable use of conda without activation) add Library/bin to PATH
    get_filename_component(_conda_env ${Python3_EXECUTABLE} DIRECTORY)
    if (EXISTS ${_conda_env}/Library/bin)
      set(ENV{PATH} "${_conda_env}/Library/bin;$ENV{PATH}")
    endif()

    # check if conan exists
    execute_process(COMMAND ${CONAN_BINARY} 
      RESULT_VARIABLE _conan_ret
      OUTPUT_QUIET ERROR_QUIET)
    if(_conan_ret EQUAL "1")
      message(FATAL_ERROR "Conan package manager not found! (install using: 'pip install conan')")
    endif()

    execute_process(COMMAND ${CONAN_BINARY} remote list
      OUTPUT_VARIABLE _conan_remotes)
    
    # check for conan remote
    string(FIND "${_conan_remotes}" "${CONAN_REMOTE_NAME}: ${CONAN_PACKAGES_REMOTE}" _conan_remote_found)
    if(_conan_remote_found EQUAL -1)
      message(FATAL_ERROR "Conan remote '${CONAN_REMOTE_NAME}' ${CONAN_PACKAGES_REMOTE} is missing ...\n"
        "Add remote using:\n"
        "- conan remote clean\n"
        "- conan remote add ${CONAN_REMOTE_NAME} ${CONAN_PACKAGES_REMOTE}\n"
        "- conan user \${USER} -p -r ${CONAN_REMOTE_NAME}\n")
    endif()

    # create conan profile
    set(CONAN_PROFILE_NAME ${CONAN_REMOTE_NAME})
    execute_process(COMMAND ${CONAN_BINARY} profile new ${CONAN_PROFILE_NAME} --detect
        OUTPUT_QUIET ERROR_QUIET)
      
    # update conan profile for windows
    IF(WIN32)
      execute_process(COMMAND ${CONAN_BINARY} profile update settings.compiler="Visual Studio" ${CONAN_PROFILE_NAME}
        OUTPUT_QUIET ERROR_QUIET)
      execute_process(COMMAND ${CONAN_BINARY} profile update settings.compiler.version=16 ${CONAN_PROFILE_NAME}
        OUTPUT_QUIET ERROR_QUIET)
    endif()

    if (NOT PIP_REQUIREMENTS STREQUAL "")
      # install python deps
      message(STATUS "* Installing python dependencies from '${PIP_REQUIREMENTS}' ...")
      execute_process(COMMAND ${PIP_BINARY} install -r ${PIP_REQUIREMENTS}
        RESULT_VARIABLE _pip_install_ret)
      if(NOT _pip_install_ret EQUAL "0")
        message(FATAL_ERROR "Installing python dependencies failed!")
      endif()
      message(STATUS "")
    endif()

    # install conan deps
    if(CMAKE_BUILD_TYPE)
      set(CONAN_BUILD_TYPES ${CMAKE_BUILD_TYPE})
    else()
      set(CONAN_BUILD_TYPES Debug Release)
    endif()
    foreach(CONAN_BUILD_TYPE ${CONAN_BUILD_TYPES})
      message(STATUS "* Installing conan dependencies (${CONAN_BUILD_TYPE}) from '${CONAN_FILE}' ...")
      # install from conan remote
      execute_process(COMMAND ${CONAN_BINARY} install -s build_type=${CONAN_BUILD_TYPE}
        ${CONAN_FILE} -g cmake_find_package_multi -if "${CMAKE_BINARY_DIR}/.conan/cmake" -r ${CONAN_REMOTE_NAME} 
        --build missing --profile ${CONAN_PROFILE_NAME}
        RESULT_VARIABLE _conan_install_ret)
      if(NOT _conan_install_ret EQUAL "0")
        message(WARNING "Install from remote '${CONAN_REMOTE_NAME}' failed, installing without custom remote ...")
        execute_process(COMMAND ${CONAN_BINARY} install -s build_type=${CONAN_BUILD_TYPE}
          ${CONAN_FILE} -g cmake_find_package_multi -if "${CMAKE_BINARY_DIR}/.conan/cmake"
          --build missing --profile ${CONAN_PROFILE_NAME}
          RESULT_VARIABLE _conan_install_ret)
      endif()
      if(NOT _conan_install_ret EQUAL "0")
        message(FATAL_ERROR "Installing conan dependencies failed!")
      endif()
      message(STATUS "")
    endforeach()

    list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_BINARY_DIR}/.conan/cmake")
    list(INSERT CMAKE_PREFIX_PATH 0 "${CMAKE_BINARY_DIR}/.conan/cmake")

    message(STATUS "* Conan build initialized.  ")
    message(STATUS "****************************")
    message(STATUS "")

    # restore PATH environment variable
    set(ENV{PATH} "${ENV_BACKUP}")

  endif()
endmacro()