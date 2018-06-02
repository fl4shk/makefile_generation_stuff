include(include/misc_defines.m4)dnl
dnl
ifelse(_IFELSEDEF(`DO_VERILOG'), 1, `define(`WHICH_HDL', `verilog')', 
_IFELSEDEF(`DO_SYSTEMVERILOG'), 1, `define(`WHICH_HDL', `systemverilog')',
`define(`WHICH_HDL', `UNKNOWN')')dnl
dnl "WHICH_MAKEFILE()":  .m4 input debugging thing
dnl ifelse(_IFELSEDEF(`HAVE_M4'), 1, 
dnl 	`ifelse(WHICH_HDL(), `verilog', `define(`WHICH_MAKEFILE', `m4_verilog')',
dnl 	`define(`WHICH_MAKEFILE', `m4_systemverilog')')',
dnl 	_IFELSEDEF(`HAVE_M4'), 0, 
dnl 	`ifelse(WHICH_HDL(), `verilog', `define(`WHICH_MAKEFILE', `just_verilog')',
dnl 	`define(`WHICH_MAKEFILE', `just_systemverilog')')')dnl
# WHICH_HDL()
dnl # WHICH_MAKEFILE()
dnl 
# start stuff

# Edit these variables if more directories are needed.
SRC_DIRS := src

#end stuff

# Prefix for output file name (change this if needed!)
PROJ := $(shell basename $(CURDIR))

# (System)Verilog Compiler
VC := iverilog

ifelse(WHICH_HDL(), `verilog', `EXTRA_IVERILOG_OPTIONS:=-DICARUS',
WHICH_HDL(), `systemverilog', `EXTRA_IVERILOG_OPTIONS:=-g2009 -DICARUS')
dnl
ifelse(WHICH_HDL(), `verilog', `BUILD_VVP:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -o $(PROJ).vvp
BUILD_VHDL:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -tvhdl -o $(PROJ).vhd
PREPROCESS:=$(VC) $(EXTRA_IVERILOG_OPTIONS)  -E -o $(PROJ).E'
,
WHICH_HDL(), `systemverilog', `BUILD_VVP:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -o $(PROJ).vvp
BUILD_VHDL:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -tvhdl -o $(PROJ).vhd
BUILD_VERILOG:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -tverilog -o $(PROJ).v
PREPROCESS:=$(VC) $(EXTRA_IVERILOG_OPTIONS) -E -o $(PROJ).E'
,
`')dnl

ifelse(_IFELSEDEF(`HAVE_M4'), 1,
ifelse(WHICH_HDL(), `verilog',
`# Generated directories
V_OUT_DIR := v_outputs'
,
WHICH_HDL(), `systemverilog',
`# Generated directories
SV_OUT_DIR := sv_outputs')
,
`')dnl

ifelse(_IFELSEDEF(`HAVE_M4'), 0,
ifelse(WHICH_HDL(), `verilog', `SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.v')'
,
WHICH_HDL(), `systemverilog', `PKG_FILES := '`_GEN_RHS_SOURCES(`SRC_',`pkg.sv')'
`SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.sv')'
,
`'),dnl
_IFELSEDEF(`HAVE_M4'), 1,
ifelse(WHICH_HDL(), `verilog', `M4_SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.m4.v')'
`SRC_FILES := '`_GEN_RHS_OTHER_FILES(`M4_SRC_',`FILES',`src.m4.v',`V_OUT_DIR',`src.v')'
,
WHICH_HDL(), `systemverilog', `M4_SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.sv.m4')'
`M4_PKG_FILES := '`_GEN_RHS_SOURCES(`PKG_',`pkg.sv.m4')'
`SRC_FILES := '`_GEN_RHS_OTHER_FILES(`M4_SRC_',`FILES',`src.sv.m4',`SV_OUT_DIR',`src.sv')'
`PKG_FILES := '`_GEN_RHS_OTHER_FILES(`M4_PKG_',`FILES',`pkg.sv.m4',`SV_OUT_DIR',`pkg.sv')'
,
`')dnl
,
`')dnl

.PHONY : all
ifelse(_IFELSEDEF(`HAVE_M4'), 0, `all: clean reminder',
`all: clean reminder all_pre $(PKG_FILES) $(SRC_FILES)')
	$(BUILD_VVP) $(PKG_FILES) $(SRC_FILES)

.PHONY : vhdl
vhdl: clean reminder
	$(BUILD_VHDL) $(PKG_FILES) $(SRC_FILES)

ifelse(WHICH_HDL(), `systemverilog', `.PHONY : verilog
verilog: clean reminder
	$(BUILD_VERILOG) $(PKG_FILES) $(SRC_FILES)'
,
`')dnl

.PHONY : only_preprocess
ifelse(_IFELSEDEF(`HAVE_M4'), 0, `only_preprocess: clean reminder',
`only_preprocess: clean reminder all_pre $(PKG_FILES) $(SRC_FILES)')
	$(PREPROCESS) $(PKG_FILES) $(SRC_FILES)

ifelse(_IFELSEDEF(`HAVE_M4'), 1, `.PHONY : all_pre
all_pre :'
ifelse(WHICH_HDL(), `verilog', `	mkdir -p $(V_OUT_DIR)
	_GEN_OUTPUT_DIRECTORIES(`src_file',`SRC_FILES')

$(SRC_FILES) : $(V_OUT_DIR)/%.src.v : %.src.m4.v
	m4 $< > $@'
,
WHICH_HDL(), `systemverilog', `	mkdir -p $(SV_OUT_DIR)
	_GEN_OUTPUT_DIRECTORIES(`src_file',`SRC_FILES')
	_GEN_OUTPUT_DIRECTORIES(`pkg_file',`PKG_FILES')
	
$(SRC_FILES) : $(SV_OUT_DIR)/%.src.sv : $.src.m4.sv
	m4 $< > $@

$(PKG_FILES) : $(SV_OUT_DIR)/%.pkg.sv : $.pkg.m4.sv
	m4 $< > $@'
,
`')dnl
,
`')dnl

.PHONY : reminder
reminder:
ifelse(WHICH_HDL(), `verilog', `	@#'
,
WHICH_HDL(), `systemverilog', `	@echo undivert(include_hdl/reminder_systemverilog.txt)',
`')dnl

define(`BASIC_CLEAN', `rm -rf $(PROJ).vvp $(PROJ).vhd $(PROJ).v $(PROJ).E')dnl
.PHONY : clean
clean:  
ifelse(_IFELSEDEF(`HAVE_M4'), 0,
`	'BASIC_CLEAN(),
ifelse(WHICH_HDL(), `verilog',
`	'BASIC_CLEAN()` $(V_OUT_DIR)',
WHICH_HDL(), `systemverilog',
`	'BASIC_CLEAN()` $(SV_OUT_DIR)',
`'))
