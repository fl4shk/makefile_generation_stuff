include(include/misc_defines.m4)dnl
# start stuff

# Edit these variables if more directories are needed.
SRCDIRS := src

#end stuff

# Prefix for output file name (change this if needed!)
PROJ := $(shell basename$(CURDIR))

# (System)Verilog Compiler
VC=iverilog


ifdef(`DO_VERILOG', `BUILD_VVP=$(VC) -o $(PROJ).vvp
#BUILD_VHDL=$(VC) -tvhdl -o $(PROJ).vhd
PREPROCESS=$(VC) -E -o $(PROJ).E'
,
`')dnl
ifdef(`DO_SYSTEMVERILOG', `BUILD_VVP=$(VC) -g2009 -o $(PROJ).vvp
#BUILD_VHDL=$(VC) -g2009 -tvhdl -o $(PROJ).vhd
PREPROCESS=$(VC) -g2009 -E -o $(PROJ).E'
,
`')dnl

ifdef(`DO_VERILOG', `SRCFILES:=$(foreach DIR,$(SRCDIRS),$(wildcard $(DIR)/*.src.v))'
,
`')dnl
ifdef(`DO_SYSTEMVERILOG', `PKGFILES:=$(foreach DIR,$(SRCDIRS),$(wildcard $(DIR)/*.pkg.sv))
SRCFILES:=$(foreach DIR,$(SRCDIRS),$(wildcard $(DIR)/*.src.sv))'
,
`')dnl

.PHONY : all
all: reminder clean
	$(BUILD_VVP) $(PKGFILES) $(SRCFILES)
	@#$(BUILD_VHDL) $(PKGFILES) $(SRCFILES)

.PHONY : only_preprocess
only_preprocess: reminder clean
	$(PREPROCESS) $(PKGFILES) $(SRCFILES)

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
