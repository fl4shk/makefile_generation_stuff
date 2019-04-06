# Edit this variables if more directories are needed.
SRC_DIRS:=src

# Prefix for output file name (change this if needed!)
PROJ:=$(shell basename $(CURDIR))

# (System)Verilog Compiler
VC:=iverilog

EXTRA_IVERLOG_OPTIONS:=-g2009 -DICARUS

OPTIONS_FOR_BUILD_VVP:=$(EXTRA_IVERLOG_OPTIONS)
OPTIONS_FOR_PREPROCESS:=$(EXTRA_IVERLOG_OPTIONS) -E
OPTIONS_FOR_BUILD_VHDL:=$(EXTRA_IVERLOG_OPTIONS) -tvhdl
OPTIONS_FOR_BUILD_VERILOG:=$(EXTRA_IVERLOG_OPTIONS) -tvlog95

BUILD_VVP:=$(VC) $(OPTIONS_FOR_BUILD_VVP) -o $(PROJ).vvp
PREPROCESS:=$(VC) $(OPTIONS_FOR_PREPROCESS) -o $(PROJ).E
BUILD_VHDL:=$(VC) $(OPTIONS_FOR_BUILD_VHDL) -o $(PROJ).vhd
BUILD_VERILOG:=$(VC) $(OPTIONS_FOR_BUILD_VERILOG) -o $(PROJ).v


PKG_FILES := $(foreach DIR,$(SRC_DIRS),$(wildcard $(DIR)/*.pkg.sv))
SRC_FILES := $(foreach DIR,$(SRC_DIRS),$(wildcard $(DIR)/*.src.sv))


.PHONY : all
all: clean reminder
	$(BUILD_VVP) $(PKG_FILES) $(SRC_FILES)

.PHONY : only_preprocess
only_preprocess: clean reminder
	$(PREPROCESS) $(PKG_FILES) $(SRC_FILES)

.PHONY : vhdl
vhdl: clean reminder
	$(BUILD_VHDL) $(PKG_FILES) $(SRC_FILES)

.PHONY : verilog
verilog: clean reminder
	$(BUILD_VERILOG) $(PKG_FILES) $(SRC_FILES)


.PHONY : reminder
reminder:
	@echo "Reminder:  With Icarus Verilog, DON'T CAST BITS TO ENUMS!"

.PHONY : clean
clean:  
	rm -rf $(PROJ).vvp $(PROJ).vhd $(PROJ).v $(PROJ).E
