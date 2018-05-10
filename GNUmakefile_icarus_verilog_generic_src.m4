include(include/misc_defines.m4)dnl
dnl
ifelse(_IFELSEDEF(`DO_VERILOG'), 1, `define(`WHICH_HDL', `verilog')', 
_IFELSEDEF(`DO_SYSTEMVERILOG'), 1, `define(`WHICH_HDL', `systemverilog')',
`define(`WHICH_HDL', `UNKNOWN')')dnl
ifelse(_IFELSEDEF(`HAVE_M4'), 1, 
	`ifelse(WHICH_HDL(), `verilog', `define(`WHICH_MAKEFILE', `m4_verilog')',
	`define(`WHICH_MAKEFILE', `m4_systemverilog')')',
	_IFELSEDEF(`HAVE_M4'), 0, 
	`ifelse(WHICH_HDL(), `verilog', `define(`WHICH_MAKEFILE', `just_verilog')',
	`define(`WHICH_MAKEFILE', `just_systemverilog')')')dnl
dnl # WHICH_HDL()
dnl # WHICH_MAKEFILE()
dnl 
# start stuff

# Edit these variables if more directories are needed.
SRC_DIRS := src

#end stuff

# Prefix for output file name (change this if needed!)
PROJ := $(shell basename$(CURDIR))

# (System)Verilog Compiler
VC=iverilog


ifelse(WHICH_HDL(), `verilog', `BUILD_VVP=$(VC) -o $(PROJ).vvp
#BUILD_VHDL=$(VC) -tvhdl -o $(PROJ).vhd
PREPROCESS=$(VC) -E -o $(PROJ).E'
,
WHICH_HDL(), `systemverilog', `BUILD_VVP=$(VC) -g2009 -o $(PROJ).vvp
#BUILD_VHDL=$(VC) -g2009 -tvhdl -o $(PROJ).vhd
PREPROCESS=$(VC) -g2009 -E -o $(PROJ).E'
,
`')dnl

ifelse(WHICH_HDL(), `verilog', `SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.v')'
,
WHICH_HDL(), `systemverilog', `PKG_FILES := '`_GEN_RHS_SOURCES(`PKG_',`pkg.sv')'
`SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.sv')'
,
`')dnl

.PHONY : all
all: reminder clean
	$(BUILD_VVP) $(PKG_FILES) $(SRC_FILES)
	@#$(BUILD_VHDL) $(PKG_FILES) $(SRC_FILES)


.PHONY : only_preprocess
only_preprocess: reminder clean
	$(PREPROCESS) $(PKG_FILES) $(SRC_FILES)

.PHONY : reminder
reminder:
ifdef(`DO_VERILOG', `	@#'
,
`')dnl
ifdef(`DO_SYSTEMVERILOG', `	@echo undivert(include_hdl/reminder_systemverilog.txt)',
`')dnl

.PHONY : clean
clean:  
	rm -fv $(PROJ).vvp $(PROJ).vhd $(PROJ).E
