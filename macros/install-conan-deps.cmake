# set(BUILDSYS_CONAN TRUE)
# install_conan_deps(
#   "mlwn" "https://gitlab.mlwn.se/api/v4/projects/541/packages/conan"
#   "${CMAKE_CURRENT_LIST_DIR}/conanfile.py"
#   "${CMAKE_CURRENT_LIST_DIR}/requirements.txt"
#)

macro(install_conan_deps
  CONAN_REMOTE_NAME
  CONAN_PACKAGES_REMOTE
  CONAN_FILE
  PIP_REQUIREMENTS
)
  if(NOT BUILDSYS_CONAN)
    message(WARNING "Set BUILDSYS_CONAN=TRUE if you want use install_conan_deps macro.")
  else()

    set(CONAN_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

    # Update RPATH behavior, to search relatively to bin folder (default for Windows DLLs)
    if (APPLE)
      set(CMAKE_INSTALL_RPATH "@executable_path/../lib")
    else()
      set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
    endif()
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)

    if(NOT DEFINED BUILDSYS_CONAN_UPLOAD_PACKAGES)
      set(BUILDSYS_CONAN_UPLOAD_PACKAGES OFF)
    endif()

    message(STATUS "")
    message(STATUS "****************************")
    message(STATUS "* Preparing Conan build ... ")
    message(STATUS "* BUILDSYS_CONAN = ${BUILDSYS_CONAN}")
    message(STATUS "* BUILDSYS_CONAN_UPLOAD_PACKAGES = ${BUILDSYS_CONAN_UPLOAD_PACKAGES}")
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
      if (WIN32)
        set(ENV{PATH} "${_conda_env}/Library/bin;${_conda_env}/Scripts;$ENV{PATH}")
      endif()
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
        "- conan remote add conancenter https://center.conan.io\n"
        "- conan remote add ${CONAN_REMOTE_NAME} ${CONAN_PACKAGES_REMOTE}\n"
        "- conan user \${USER} -p -r ${CONAN_REMOTE_NAME}\n")
    endif()

    # enable revisions for conan 1.X
    execute_process(COMMAND ${CONAN_BINARY} config set general.revisions_enabled=True
        OUTPUT_QUIET ERROR_QUIET)

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
    else()
      # Use C++ 11 ABI (https://docs.conan.io/1/howtos/manage_gcc_abi.html)
      execute_process(COMMAND ${CONAN_BINARY} profile update settings.compiler.libcxx=libstdc++11 ${CONAN_PROFILE_NAME}
        OUTPUT_QUIET ERROR_QUIET)
    endif()

    # update conan profile for apple
    IF(APPLE)
      execute_process(COMMAND ${CONAN_BINARY} profile update settings.compiler="apple-clang" ${CONAN_PROFILE_NAME}
        OUTPUT_QUIET ERROR_QUIET)
      execute_process(COMMAND ${CONAN_BINARY} profile update settings.compiler.libcxx=libc++ ${CONAN_PROFILE_NAME}
        OUTPUT_QUIET ERROR_QUIET)
      execute_process(COMMAND ${CONAN_BINARY} profile update settings.compiler.version=14 ${CONAN_PROFILE_NAME}
        OUTPUT_QUIET ERROR_QUIET)
    endif()

    if (NOT "${PIP_REQUIREMENTS}" STREQUAL "")
      # install python deps
      message(STATUS "* Installing python dependencies from '${PIP_REQUIREMENTS}' ...")
      execute_process(COMMAND ${PIP_BINARY} install -r ${PIP_REQUIREMENTS}
        RESULT_VARIABLE _pip_install_ret)
      if(NOT _pip_install_ret EQUAL "0")
        message(FATAL_ERROR "Installing python dependencies failed!")
      endif()
      execute_process(COMMAND ${PIP_BINARY} install pip-licenses
        RESULT_VARIABLE _pip_install_ret)
      if(NOT _pip_install_ret EQUAL "0")
        message(WARNING "Unable to extract python licenses!")
      else()
        file(MAKE_DIRECTORY ${CONAN_OUTPUT_DIRECTORY}/licenses)
        execute_process(COMMAND pip-licenses --from=mixed --with-authors
          --with-urls --with-description --format=json
          --output-file=${CONAN_OUTPUT_DIRECTORY}/python_deps.json)
        execute_process(COMMAND pip-licenses --from=mixed --with-authors
          --with-urls --with-description --format=plain-vertical
          --with-license-file --no-license-path
          --output-file=${CONAN_OUTPUT_DIRECTORY}/licenses/python_thirdparty_licenses.txt)
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
      execute_process(COMMAND ${CONAN_BINARY} install -s build_type=${CONAN_BUILD_TYPE}
        ${CONAN_FILE} -if "${CONAN_OUTPUT_DIRECTORY}/cmake" -r ${CONAN_REMOTE_NAME}
        --build missing --profile ${CONAN_PROFILE_NAME}
        RESULT_VARIABLE _conan_install_ret)
      if(_conan_install_ret EQUAL "0")
        execute_process(COMMAND ${CONAN_BINARY} info
          ${CONAN_FILE} -if "${CONAN_OUTPUT_DIRECTORY}/cmake" -r ${CONAN_REMOTE_NAME}
          --json=${CONAN_OUTPUT_DIRECTORY}/conan_deps.json
          --graph=${CONAN_OUTPUT_DIRECTORY}/conan_deps.html)
        message(STATUS "")
        break()
      endif()

      message(WARNING "Install from remote '${CONAN_REMOTE_NAME}' failed, trying conan-center ...")
      execute_process(COMMAND ${CONAN_BINARY} install -s build_type=${CONAN_BUILD_TYPE}
        ${CONAN_FILE} -if "${CONAN_OUTPUT_DIRECTORY}/cmake"
        --build missing --profile ${CONAN_PROFILE_NAME}
        RESULT_VARIABLE _conan_install_ret)
      if(_conan_install_ret EQUAL "0")
        execute_process(COMMAND ${CONAN_BINARY} info
          ${CONAN_FILE} -if "${CONAN_OUTPUT_DIRECTORY}/cmake" -r ${CONAN_REMOTE_NAME}
          --json=${CONAN_OUTPUT_DIRECTORY}/conan_deps.json
          --graph=${CONAN_OUTPUT_DIRECTORY}/conan_deps.html)
        message(STATUS "")
        break()
      endif()

      message(FATAL_ERROR "Installing conan dependencies failed!")
      message(STATUS "")

    endforeach()

    # remove conan build files
    message(STATUS "* Cleaning conan build files ...")
    execute_process(COMMAND ${CONAN_BINARY} remove "*" --src --builds --force
        RESULT_VARIABLE _conan_remove_builds_ret)
    if(NOT _conan_remove_builds_ret EQUAL "0")
      message(WARNING "Removing conan build files failed!")
    endif()

    if(BUILDSYS_CONAN_UPLOAD_PACKAGES)
      execute_process(COMMAND ${CONAN_BINARY} upload "*" --all -c -r ${CONAN_REMOTE_NAME}
        RESULT_VARIABLE _conan_upload_ret)
      if(_conan_upload_ret EQUAL "0")
        message(WARNING "Uploading built Conan packages to remote '${CONAN_REMOTE_NAME}' failed!")
        message(STATUS "")
      endif()
    endif()

    list(INSERT CMAKE_MODULE_PATH 0 "${CONAN_OUTPUT_DIRECTORY}/cmake")
    list(INSERT CMAKE_PREFIX_PATH 0 "${CONAN_OUTPUT_DIRECTORY}/cmake")

    message(STATUS "* Conan build initialized.  ")
    message(STATUS "****************************")
    message(STATUS "")

    # restore PATH environment variable
    set(ENV{PATH} "${ENV_BACKUP}")

    # create cmake install component (see conanfile / imports)
    if (WIN32)
      file(GLOB CONAN_LIBS "${CMAKE_BINARY_DIR}/bin/*.dll")
      install(FILES ${CONAN_LIBS} DESTINATION bin COMPONENT conandeps)
    elseif(UNIX)
      file(GLOB CONAN_LIBS "${CMAKE_BINARY_DIR}/lib/*.so*")
      foreach(lib_ ${CONAN_LIBS})
        find_program(PATCHELF patchelf REQUIRED)
        execute_process(COMMAND ${PATCHELF} ${lib_} --set-rpath $ORIGIN
          OUTPUT_QUIET ERROR_QUIET)
      endforeach()
      install(FILES ${CONAN_LIBS} DESTINATION lib COMPONENT conandeps)
    elseif(APPLE)
      file(GLOB CONAN_LIBS "${CMAKE_BINARY_DIR}/lib/*.dylib*")
      message(WARNING "RPATH of prebuilt dynamic libraries may not be set correctly. CPack may fail.")
    endif()
    install(DIRECTORY "${CMAKE_BINARY_DIR}/share/" DESTINATION share COMPONENT conandeps)

  endif()
endmacro()
