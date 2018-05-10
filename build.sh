#!/bin/bash

# Regular (software) makefiles
regular_src=GNUmakefile_generic_src.m4
mkdir -p generic
mkdir -p C++
mkdir -p C
m4 -DGENERIC ${regular_src} > generic/GNUmakefile_generic.mk
m4 -DANTLR ${regular_src} > generic/GNUmakefile_antlr.mk
m4 -DJSONCPP ${regular_src} > generic/GNUmakefile_jsoncpp.mk
m4 -DANTLR -DJSONCPP ${regular_src} > generic/GNUmakefile_antlr_jsoncpp.mk

m4 -DDO_CXX -DHAVE_DEBUG ${regular_src} > C++/GNUmakefile_cxx.mk
m4 -DDO_C -DHAVE_DEBUG ${regular_src} > C/GNUmakefile_c.mk

m4 -DDO_CXX -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${regular_src} > C++/GNUmakefile_cxx_dis.mk
m4 -DDO_C -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${regular_src} > C/GNUmakefile_c_dis.mk

m4 -DDO_CXX ${regular_src} > C++/GNUmakefile_cxx_no_debug.mk
m4 -DDO_C ${regular_src} > C/GNUmakefile_c_no_debug.mk


#m4 -DDO_CXX -DDO_ARM -DHAVE_DEBUG ${regular_src} > C++/GNUmakefile_cxx_do_arm.mk
#m4 -DDO_C -DDO_ARM -DHAVE_DEBUG ${regular_src} > C/GNUmakefile_c_do_arm.mk
m4 -DDO_CXX -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${regular_src} > C++/GNUmakefile_cxx_do_arm_full.mk
m4 -DDO_C -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${regular_src} > C/GNUmakefile_c_do_arm_full.mk

#m4 -DDO_CXX -DDO_MIPS -DINITIAL_EMBEDDED_DEFINES ${regular_src} > C++/GNUmakefile_cxx_do_mips_full.mk
#m4 -DDO_C -DDO_MIPS -DINITIAL_EMBEDDED_DEFINES ${regular_src} > C/GNUmakefile_c_do_mips_full.mk

m4 -DDO_GBA ${regular_src} > C++/GNUmakefile_gba.mk

# HDL (Icarus Verilog) makefiles
hdl_src=GNUmakefile_icarus_verilog_generic_src.m4
mkdir -p HDL

m4 -DDO_VERILOG ${hdl_src} > HDL/GNUmakefile_v_icarus_verilog.mk
m4 -DDO_SYSTEMVERILOG ${hdl_src} > HDL/GNUmakefile_sv_icarus_verilog.mk
m4 -DDO_VERILOG -DHAVE_M4 ${hdl_src} > HDL/GNUmakefile_v_icarus_verilog_with_m4.mk
m4 -DDO_SYSTEMVERILOG -DHAVE_M4 ${hdl_src} > HDL/GNUmakefile_sv_icarus_verilog_with_m4.mk
