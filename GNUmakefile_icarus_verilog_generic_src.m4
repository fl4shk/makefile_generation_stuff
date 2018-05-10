include(include/misc_defines.m4)dnl
dnl
ifelse(_IFELSEDEF(`DO_VERILOG'), 1, `define(`WHICH_HDL', `verilog')', 
_IFELSEDEF(`DO_SYSTEMVERILOG'), 1, `define(`WHICH_HDL', `systemverilog')',
`define(`WHICH_HDL', `UNKNOWN')')dnl
dnl "WHICH_MAKEFILE()":  .m4 input debugging thing
ifelse(_IFELSEDEF(`HAVE_M4'), 1, 
	`ifelse(WHICH_HDL(), `verilog', `define(`WHICH_MAKEFILE', `m4_verilog')',
	`define(`WHICH_MAKEFILE', `m4_systemverilog')')',
	_IFELSEDEF(`HAVE_M4'), 0, 
	`ifelse(WHICH_HDL(), `verilog', `define(`WHICH_MAKEFILE', `just_verilog')',
	`define(`WHICH_MAKEFILE', `just_systemverilog')')')dnl
# WHICH_HDL()
# WHICH_MAKEFILE()
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
WHICH_HDL(), `systemverilog', `PKG_FILES := '`_GEN_RHS_SOURCES(`PKG_',`pkg.sv')'
`SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.sv')'
,
`'),dnl
_IFELSEDEF(`HAVE_M4'), 1,
ifelse(WHICH_HDL(), `verilog', `M4_SRC_FILES := '`_GEN_RHS_SOURCES(`SRC_',`src.v.m4')'
`SRC_FILES := '`_GEN_RHS_OTHER_FILES(`M4_SRC_',`FILES',`src.v.m4',`V_OUT_DIR',`src.v')'
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
ifelse(_IFELSEDEF(`HAVE_M4'), 0, `all: reminder clean',
`all: all_pre reminder clean')
	$(BUILD_VVP) $(PKG_FILES) $(SRC_FILES)
	@#$(BUILD_VHDL) $(PKG_FILES) $(SRC_FILES)

.PHONY : only_preprocess
ifelse(_IFELSEDEF(`HAVE_M4'), 0, `only_preprocess: reminder clean',
`only_preprocess: all_pre reminder clean')
	$(PREPROCESS) $(PKG_FILES) $(SRC_FILES)

ifelse(_IFELSEDEF(`HAVE_M4'), 1, `.PHONY : all_pre
all_pre : $(PKG_FILES) $(SRC_FILES)'
ifelse(WHICH_HDL(), `verilog', `	mkdir -p $(V_OUT_DIR)
	_GEN_OUTPUT_DIRECTORIES(`src_file',`SRC_FILES')

$(SRC_FILES) : $(V_OUT_DIR)/%.src.v : $.src.v.m4
	m4 $< > $@'
,
WHICH_HDL(), `systemverilog', `	mkdir -p $(SV_OUT_DIR)
	_GEN_OUTPUT_DIRECTORIES(`src_file',`SRC_FILES')
	_GEN_OUTPUT_DIRECTORIES(`pkg_file',`PKG_FILES')
	
$(SRC_FILES) : $(SV_OUT_DIR)/%.src.sv : $.src.sv.m4
	m4 $< > $@

$(PKG_FILES) : $(SV_OUT_DIR)/%.pkg.sv : $.pkg.sv.m4
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

define(`BASIC_CLEAN', `rm -fv $(PROJ).vvp $(PROJ).vhd $(PROJ).E')dnl
.PHONY : clean
clean:  
ifelse(_IFELSEDEF(`HAVE_M4'), 0,
`	'BASIC_CLEAN(),
ifelse(WHICH_HDL(), `verilog',
`	'BASIC_CLEAN()` $(V_OUT_DIR)',
WHICH_HDL(), `systemverilog',
`	'BASIC_CLEAN()` $(SV_OUT_DIR)',
`'))
