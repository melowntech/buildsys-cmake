# CMake-based build system plugin

## About

This project holds CMake-based plugin for building C++ (or C) based projects.

## Usage

### Basic repository layout

See basic layout in [buildsys-common](https://github.com/Melown/buildsys-common/blob/master/README.md#basic-layout-of-project-that-uses-buildsys--machinery) documentation.

### Setup submodule(s)

Inside your project root add `buildsys-cmake` repository (this) as a submodule into `externals/buildsystem/cmake`.

```
git submodule add ../buildsys-cmake externals/buildsys/cmake
```

This plugin depends on core build system functionality. If you have not added `buildsys-common` to your project yet you have to do it now.

```
git submodule add ../buildsys-common externals/buildsys/common
```

Link buildsys to your project component

Move to your component root under the project root and create a `buildsys` symlink:

```
cd component
ln -s ../externals/buildsys
```

### Use `buildsys-cmake` as a main build system

If your component uses `buildsys-cmake` as a desired build system symlink provided `cmake.mk` file into component and produce a `CMakeLists.txt` for it.

```
cd component
ln -s buildsys/cmake/cmake.mk Makefile
```

### Components's `CMakeLists.txt`

To be able to use CMake build system you need to produce top-level `CMakeLists.txt` in component's root. This file must start with:

```
# bootstrap build system
cmake_minimum_required(VERSION 2.8.11)
project(component-name)
include(buildsys/cmake/buildsys.cmake)
```

where `component-name` is the name of your component, e.g. `vts-tools`.

NB: If you do not call `project` macro directly CMake will do it for you but this `buildsys-common` will reject your setup in this case.

## Source files layout

Source files are expected to reside under component's `src/` directory (this directory is automatically added to include path). Sources should be placed to subdirectories under `src/`. Each subdirectory represents a module, e.g. a library or a binary.

Example:

```
component/src/component-helper    # sources for helper library
component/src/component           # component's sources
```

## Modules's `CMakeLists.txt`

A module (`src/` subdirectory) should produce its own `CMakeLists.txt` snippet that is plugged into component's `CMakeLists.txt` using `add_subdirectory` macro:

```
add_subdirectory(src/component-helper)
add_subdirectory(src/component)
```

## External `buildsys-cmake`-based libraries

All `buildsys-cmake`-based external libraries are externally provided modules and thus they should be checked out as a submodule to top-level `externals` directory alongside the build system and its source directory should be linked under `src/` and plugged in via `add_subdierectory` macro (see above).

For example, to include `libdbglog` library into your project use this layout:

```
externals/libdbglog                                       # libdbglog as a submodule
component/src/dbglog -> ../../externals/libdbglog/dbglog  # symlink to dbglog library sources
```

## Module's CMakeLists.txt

TBD
