#!/bin/bash
src=makefile_generic_src.gpp
gpp -DGENERIC ${src} > makefile_generic
mkdir -p C++
mkdir -p C
gpp -DDO_CXX -DHAVE_DEBUG ${src} > C++/makefile_cxx
gpp -DDO_CXX ${src} > C++/makefile_cxx_no_debug
gpp -DDO_C -DHAVE_DEBUG ${src} > C/makefile_c
gpp -DDO_C ${src} > C/makefile_c_no_debug
gpp -DDO_CXX -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${src} > C++/makefile_cxx_dis
gpp -DDO_C -DHAVE_DEBUG -DHAVE_DISASSEMBLE ${src} > C/makefile_c_dis
#gpp -DDO_CXX -DDO_ARM -DHAVE_DEBUG ${src} > C++/makefile_cxx_do_arm
#gpp -DDO_C -DDO_ARM -DHAVE_DEBUG ${src} > C/makefile_c_do_arm
gpp -DDO_CXX -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${src} > C++/makefile_cxx_do_arm_full
gpp -DDO_C -DDO_ARM -DHAVE_DEBUG -DDO_S -DHAVE_DISASSEMBLE ${src} > C/makefile_c_do_arm_full
gpp -DGBA ${src} > C++/makefile_gba
