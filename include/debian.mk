# This file can be included into debian/rules to add default package handling
# for buildsys-cmake based projects

# sanity check
ifndef PACKAGES
$(error Missing PACKAGES variable)
endif

# automatically add PREFIX as CMAKE_INSTALL_PREFIX
ifdef PREFIX
CMAKE_FLAGS += -DCMAKE_INSTALL_PREFIX:PATH=$(PREFIX)
endif

# add version
CMAKE_FLAGS += -DBUILDSYS_PACKAGE_VERSION=$(DEB_VERSION)

ifndef CMAKE_BUILD_TYPE
CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Release
endif

# place debug info to debug package
# set to NO to disable or to different package name if needed
DEB_PACKAGE_DEBUG ?= $(DEB_SOURCE)-dbg

# use this build directory
DEB_BUILDDIR=obj-$(DEB_BUILD_GNU_TYPE)

# default rule; tell debhelper we use CMake
%:
	dh -Scmake -B$(DEB_BUILDDIR) --parallel -O--version-info $@

# custom installation
override_dh_auto_install:
	$(foreach package, $(PACKAGES) \
	  , $(foreach component, $(INSTALL_COMPONENTS_$(package)) \
		  , DESTDIR=debian/$(DEB_PACKAGE_$(package)) \
			cmake -DCOMPONENT=$(component) \
			    -P $(DEB_BUILDDIR)/cmake_install.cmake;))

# override configuration
override_dh_auto_configure:
	dh_auto_configure -- $(CMAKE_FLAGS)

ifneq ($(DEB_PACKAGE_DEBUG),NO)
override_dh_strip:
	dh_strip --dbg-package=$(DEB_PACKAGE_DEBUG)
endif
