#
# TinyTapeout Blackbox Macro Build Harness
# (mostly for art)
#
# Contributors:
#  - watbulb: Dayton Pidhirney
#
TT_PROJECT_NAME ?= tt_um_macro_testing

PDK_ROOT    := ${PDK_ROOT}
PDK_MAGICRC := $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc
ifeq ($(PDK_ROOT),)
$(error "PDK_ROOT not in environment")
endif

VSRC_PATH      ?= $(CURDIR)/src
MAG_MACRO_PATH ?= $(CURDIR)/mag
GDS_MACRO_PATH ?= $(CURDIR)/gds
LEF_MACRO_PATH ?= $(CURDIR)/lef

# The target macro 
TARGET_MACRO ?= $(lastword $(MAKECMDGOALS))

# Macro sources
MAG_SOURCES := $(wildcard $(MAG_MACRO_PATH)/*.mag) 
GDS_SOURCES := $(wildcard $(GDS_MACRO_PATH)/*.gds) 
LEF_SOURCES := $(wildcard $(GDS_MACRO_PATH)/*.lef) 

# Find the magic source for the target macro
MAG_MACROS_SRC := $(foreach macro,$(TARGET_MACRO),$(filter %$(macro).mag, $(MAG_SOURCES)))

ifeq ($(words $(MAKECMDGOALS)),2)
  ifeq ($(MAG_MACROS_SRC),)
    $(error "unable to locate a mag for selected macro $(TARGET_MACRO)")
  endif
  # Info
  ifneq ($(DEBUG),)
    $(info [DEBUG] Variables: )
    $(info PDK_ROOT:         $(PDK_ROOT))
    $(info TT_PROJECT_NAME:  $(TT_PROJECT_NAME))
    $(info TARGET_MACRO:     $(TARGET_MACRO))
    $(info MAG_SOURCES:      $(MAG_SOURCES))
    $(info GDS_SOURCES:      $(GDS_SOURCES))
    $(info LEF_SOURCES:      $(LEF_SOURCES))
    $(info MAG_MACROS_SRC:   $(MAG_MACROS_SRC))
  endif
endif

# Some helpers we will need
define macro_name
$(firstword $(subst ., ,$(basename $(notdir $(macro)))))
endef

$(TARGET_MACRO):

#
# Conversion targets
#
$(GDS_MACRO_PATH)/%.gds: $(MAG_MACRO_PATH)/%.mag
	$(info MAG -> GDS)
	echo "gds write \"$@\"" | magic -rcfile $(PDK_MAGICRC) -noconsole -dnull $<	

$(LEF_MACRO_PATH)/%.lef: $(MAG_MACRO_PATH)/%.mag
	$(info MAG -> LEF)
	echo "lef write \"$@\" -pinonly" | magic -rcfile $(PDK_MAGICRC) -noconsole -dnull $<

preproc: \
	$(patsubst $(MAG_MACRO_PATH)/%.mag,$(GDS_MACRO_PATH)/%.gds,$(MAG_MACROS_SRC)) \
	$(patsubst $(MAG_MACRO_PATH)/%.mag,$(LEF_MACRO_PATH)/%.lef,$(MAG_MACROS_SRC))

#
# Harden targets
#
tt_user_config:
	./tt/tt_tool.py --create-user-config --openlane2

tt_harden_top: preproc # tt_user_config
	mkdir -p runs/$(TAGET_MACRO)
	./tt/tt_tool.py --harden --openlane2

harden_top: preproc
	mkdir -p runs/$(TARGET_MACRO)
	openlane --run-tag $(TARGET_MACRO) --force-run-dir runs/$(TARGET_MACRO) src/config_marged.json

#
# Viewers targets
#
open_openroad:
	openlane \
		-f OpenInOpenROAD \
		--run-tag $(TARGET_MACRO) \
		--force-run-dir runs/$(TARGET_MACRO) \
		src/config_merged.json

open_klayout:
	openlane \
		-f OpenInKLayout \
		--run-tag $(TARGET_MACRO) \
		--force-run-dir runs/$(TARGET_MACRO) \
		src/config_merged.json

#
# Cleanup targets
#
clean_final:
	@rm -f  gds/*
	@rm -f  lef/*
	@rm -f  png/*

clean_build:
	@rm -rf runs/*
	@rm -f  src/config_merged.json
	@rm -rf slpp_all

dist_clean: clean_final clean_build

#
# META
#
.PHONY: \
	$(TARGET_MACRO) \
	preproc \
	tt_user_config \
	tt_harden_top harden_top harden_macros \
	open_openroad open_klayout \
	clean_final clean_build dist_clean
.NOTPARALLEL:

