# Link this file to projects root as Makefile:
#     ln -s buildsys/cmake/cmake.mk Makefile

.DEFAULT_GOAL := all

# find out path to buildsys directory etc.
BUILDSYS := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
BUILDSYS_COMMON := $(BUILDSYS)../common/common.mk

ifneq ($(BUILDSYS_FLAVOR),)
	BUILDDIR=build.$(BUILDSYS_FLAVOR)
else
	BUILDDIR=build
endif

include $(BUILDSYS_COMMON)

# include configuration
include $(BUILDSYS)config.mk

all .DEFAULT: FORCE
    # bootstrap if needed
	$(call bootstrap)
    # forward to build directory
	@(unset MAKELEVEL; cd $(BUILDDIR) && $(MAKE) $@)

purge:
	rm -rf bin lib $(BUILDDIR)

default debug release relwithdebinfo customerdebug customerrelease:
	$(call bootstrap_dirs)
	@echo "* Switching to ${BUILD_TYPE_$@} build type"
	@(cd $(BUILDDIR) && cmake .. -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE_$@})

native:
	$(call bootstrap_dirs)
	@echo "* Code will be compiled for current machine"
	@(cd $(BUILDDIR) && cmake .. -DBUILDSYS_ARCHITECTURE:STRING=$@)

generic:
	$(call bootstrap_dirs)
	@echo "* Code will be compiled for generic machine"
	@(cd $(BUILDDIR) && cmake .. -UBUILDSYS_ARCHITECTURE)

setarch:
	$(call bootstrap_dirs)
	@echo "* Switching architecture to $(ARCH)"
	@(cd $(BUILDDIR) && cmake .. -DBUILDSYS_ARCHITECTURE:STRING=$(ARCH))

buildtype:
	$(call bootstrap)
	@echo "$(call get_cmake_variable,CMAKE_BUILD_TYPE)"

arch:
	$(call bootstrap)
	@echo "$(call get_cmake_variable,BUILDSYS_ARCHITECTURE)"

set-variable:
	$(call bootstrap_dirs)
	@(cd $(BUILDDIR) && cmake .. -D$(VARIABLE))

unset-variable:
	$(call bootstrap_dirs)
	@(cd $(BUILDDIR) && cmake .. -U$(VARIABLE))

enable:
	$(call bootstrap_dirs)
	@(cd $(BUILDDIR) && cmake .. -DBUILDSYS_BUILD_TARGET_$(TARGET)=TRUE)

disable:
	$(call bootstrap_dirs)
	@(cd $(BUILDDIR) && cmake .. -DBUILDSYS_BUILD_TARGET_$(TARGET)=FALSE)

configure:
	cmake-gui $(BUILDDIR)

list-modules:
	@(sort $(BUILDDIR)/module.list)

FORCE:

.PHONY: FORCE purge
.PHONY: buildtype default debug release relwithdebinfo
.PHONY: customerdebug customerrelease
.PHONY: arch native generic setarch
.PHONY: set-variable unset-variable enable disable
.PHONY: configure
.PHONY: list-modules

define bootstrap_dirs
	@echo "* Building in $(BUILDDIR)"
	@(mkdir -p $(BUILDDIR)/bin $(BUILDDIR)/lib && ln -sf $(BUILDDIR)/bin && ln -sf $(BUILDDIR)/lib)
    @((test -f .module && mkdir -p $(BUILDDIR)/module && ln -sf $(BUILDDIR)/module) || exit 0)
endef

define bootstrap
	$(call bootstrap_dirs)
	@test -f $(BUILDDIR)/Makefile || (cd $(BUILDDIR) && cmake ..)
endef

define get_cmake_variable
$(shell cmake -L $(BUILDDIR) | sed '/$(1)/ {s/.*=\(.*\)/\1/p; D; q}; D' \
	 | sed 's/^$$/<DEFAULT>/')
endef

# Missing include stuff handler
define BUILDSYS_COMMON_ERROR
missing include file

    $(BUILDSYS_COMMON)

Please add buildsys-common project into your submodules under externals/buildsys/common

endef

$(BUILDSYS_COMMON):
	$(error $(BUILDSYS_COMMON_ERROR))

local.mk:
-include local.mk
