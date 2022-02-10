# last letter is set to upper case to avoid variable name 
# collision of old cmake approach without using targets
find_package(boosT REQUIRED CONFIG)

if (TARGET Boost::boost)
  set(Boost_FOUND TRUE)
  set(Boost_VERSION ${boosT_VERSION})
  list(APPEND Boost_LIBRARIES Boost::boost)
endif()

if (TARGET Boost::thread)
  set(Boost_THREAD_FOUND TRUE)
  set(Boost_THREAD_LIBRARIES Boost::thread)
  list(APPEND Boost_LIBRARIES Boost::thread)
endif()

if (TARGET Boost::program_options)
  set(Boost_PROGRAM_OPTIONS_FOUND TRUE)
  set(Boost_PROGRAM_OPTIONS_LIBRARIES Boost::program_options)
  list(APPEND Boost_LIBRARIES Boost::program_options)
endif()

if (TARGET Boost::filesystem)
  set(Boost_FILESYSTEM_FOUND TRUE)
  set(Boost_FILESYSTEM_LIBRARIES Boost::filesystem)
  list(APPEND Boost_LIBRARIES Boost::filesystem)
endif()

if (TARGET Boost::system)
  set(Boost_SYSTEM_FOUND TRUE)
  set(Boost_SYSTEM_LIBRARIES Boost::system)
  list(APPEND Boost_LIBRARIES Boost::system)
endif()

if (TARGET Boost::date_time)
  set(Boost_DATE_TIME_FOUND TRUE)
  set(Boost_DATE_TIME_LIBRARIES Boost::date_time)
  list(APPEND Boost_LIBRARIES Boost::date_time)
endif()

if (TARGET Boost::serialization)
  set(Boost_SERIALIZATION_FOUND TRUE)
  set(Boost_SERIALIZATION_LIBRARIES Boost::serialization)
  list(APPEND Boost_LIBRARIES Boost::serialization)
endif()

if (TARGET Boost::regex)
  set(Boost_REGEX_FOUND TRUE)
  set(Boost_REGEX_LIBRARIES Boost::regex)
  list(APPEND Boost_LIBRARIES Boost::regex)
endif()

if (TARGET Boost::chrono)
  set(Boost_CHRONO_FOUND TRUE)
  set(Boost_CHRONO_LIBRARIES Boost::chrono)
  list(APPEND Boost_LIBRARIES Boost::chrono)
endif()

if (TARGET Boost::iostreams)
  set(Boost_IOSTREAMS_FOUND TRUE)
  set(Boost_IOSTREAMS_LIBRARIES Boost::iostreams)
  list(APPEND Boost_LIBRARIES Boost::iostreams)
endif()

if (TARGET Boost::unit_test_framework)
  set(Boost_UNIT_TEST_FRAMEWORK_FOUND TRUE)
  set(Boost_UNIT_TEST_FRAMEWORK_LIBRARIES Boost::unit_test_framework)
  list(APPEND Boost_LIBRARIES Boost::unit_test_framework)
endif()