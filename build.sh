#!/bin/bash

# Regular (software) makefiles
regular_src=makefile_generic_src.m4
mkdir -p generic
mkdir -p C++
mkdir -p C
m4 -DGENERIC ${regular_src} > generic/GNUmakefile_generic
m4 -DANTLR ${regular_src} > generic/GNUmakefile_antlr
m4 -DJSONCPP ${regular_src} > generic/GNUmakefile_jsoncpp
m4 -DANTLR -DJSONCPP ${regular_src} > generic/GNUmakefile_antlr_jsoncpp

m4 -DDO_CXX -DHAVE_DEBUG ${regular_src} > C++/GNUmakefile_cxx
m4 -DDO_C -DHAVE_DEBUG ${regular_src} > C/GNUmakefile_c

m4 -DDO_CXX -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${regular_src} > C++/GNUmakefile_cxx_dis
m4 -DDO_C -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${regular_src} > C/GNUmakefile_c_dis

m4 -DDO_CXX ${regular_src} > C++/GNUmakefile_cxx_no_debug
m4 -DDO_C ${regular_src} > C/GNUmakefile_c_no_debug


#m4 -DDO_CXX -DDO_ARM -DHAVE_DEBUG ${regular_src} > C++/GNUmakefile_cxx_do_arm
#m4 -DDO_C -DDO_ARM -DHAVE_DEBUG ${regular_src} > C/GNUmakefile_c_do_arm
m4 -DDO_CXX -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${regular_src} > C++/GNUmakefile_cxx_do_arm_full
m4 -DDO_C -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${regular_src} > C/GNUmakefile_c_do_arm_full

#m4 -DDO_CXX -DDO_MIPS -DINITIAL_EMBEDDED_DEFINES ${regular_src} > C++/GNUmakefile_cxx_do_mips_full
#m4 -DDO_C -DDO_MIPS -DINITIAL_EMBEDDED_DEFINES ${regular_src} > C/GNUmakefile_c_do_mips_full

m4 -DDO_GBA ${regular_src} > C++/GNUmakefile_gba

## HDL (Icarus Verilog) makefiles
#hdl_src=makefile_icarus_verilog_generic_src.m4
#mkdir -p HDL
#
#m4 -DDO_VERILOG ${hdl_src} > HDL/
