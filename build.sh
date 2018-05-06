#!/bin/bash
src=makefile_generic_src.m4
mkdir -p generic
mkdir -p C++
mkdir -p C
m4 -DGENERIC ${src} > generic/makefile_generic
m4 -DANTLR ${src} > generic/makefile_antlr
m4 -DJSONCPP ${src} > generic/makefile_jsoncpp
m4 -DANTLR -DJSONCPP ${src} > generic/makefile_antlr_jsoncpp

m4 -DDO_CXX -DHAVE_DEBUG ${src} > C++/makefile_cxx
m4 -DDO_C -DHAVE_DEBUG ${src} > C/makefile_c

m4 -DDO_CXX -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${src} > C++/makefile_cxx_dis
m4 -DDO_C -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${src} > C/makefile_c_dis

m4 -DDO_CXX ${src} > C++/makefile_cxx_no_debug
m4 -DDO_C ${src} > C/makefile_c_no_debug


#m4 -DDO_CXX -DDO_ARM -DHAVE_DEBUG ${src} > C++/makefile_cxx_do_arm
#m4 -DDO_C -DDO_ARM -DHAVE_DEBUG ${src} > C/makefile_c_do_arm
m4 -DDO_CXX -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${src} > C++/makefile_cxx_do_arm_full
m4 -DDO_C -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${src} > C/makefile_c_do_arm_full

m4 -DDO_CXX -DDO_MIPS -DINITIAL_EMBEDDED_DEFINES ${src} > C++/makefile_cxx_do_mips_full
m4 -DDO_C -DDO_MIPS -DINITIAL_EMBEDDED_DEFINES ${src} > C/makefile_c_do_mips_full

m4 -DGBA ${src} > C++/makefile_gba

