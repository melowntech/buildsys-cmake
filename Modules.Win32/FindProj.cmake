# - Try to find PROJ
# Once done, this will define
#
#  PROJ_FOUND - system has Proj library
#  PROJ_INCLUDE_DIR - the Proj include directories
#  PROJ_LIBRARIES - link these to use Proj library
#  PROJ_VERSION - Proj library version

# find PROJ4 installation
find_package(PROJ4 REQUIRED)

set(PROJ_INCLUDE_DIR "${PROJ4_INCLUDE_DIR}")
set(PROJ_LIBRARIES proj)
set(PROJ_FOUND TRUE)

# TODO: set PROJ_VERSION
