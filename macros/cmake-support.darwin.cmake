# Darwin specific stuff goes here

message(STATUS "Configuring build system on Darwin (Mac OS X) machine")

macro(setup_build_system_os_specific)
  set(OpenCV_DIR "/opt/local/lib/cmake")
endmacro()
