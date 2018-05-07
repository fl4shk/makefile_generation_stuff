include(include/misc_defines.m4)dnl
include(include/generic.m4)dnl
# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.
dnl
dnl
dnl Source code languages schtick
define(`NUM_ANY_BUILD_TYPES', 0)dnl
define(`NUM_HLL_BUILD_TYPES', 0)dnl
dnl
dnl
ifdef(`DO_CXX', `_INCR(`NUM_ANY_BUILD_TYPES')'dnl
`_INCR(`NUM_HLL_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_HLL_BUILD_TYPES', NUM_HLL_BUILD_TYPES(), `cxx')'dnl
`_ARRSET(`ARR_HLL_BUILD_PREFIXES', NUM_HLL_BUILD_TYPES(), `CXX_')'dnl
`_ARRSET(`ARR_HLL_BUILD_FILEEXTS', NUM_HLL_BUILD_TYPES(), `cpp')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `cxx')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `CXX_')'dnl
`_ARRSET(`ARR_ANY_BUILD_FILEEXTS', NUM_ANY_BUILD_TYPES(), `cpp')')dnl
dnl
dnl
ifdef(`DO_C', `_INCR(`NUM_ANY_BUILD_TYPES')'dnl
`_INCR(`NUM_HLL_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_HLL_BUILD_TYPES', NUM_HLL_BUILD_TYPES(), `c')'dnl
`_ARRSET(`ARR_HLL_BUILD_PREFIXES', NUM_HLL_BUILD_TYPES(), `C_')'dnl
`_ARRSET(`ARR_HLL_BUILD_FILEEXTS', NUM_HLL_BUILD_TYPES(), `c')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `c')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `C_')'dnl
`_ARRSET(`ARR_ANY_BUILD_FILEEXTS', NUM_ANY_BUILD_TYPES(), `c')')dnl
dnl
dnl
ifdef(`DO_S', `_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `as')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `S_')'dnl
`_ARRSET(`ARR_ANY_BUILD_FILEEXTS', NUM_ANY_BUILD_TYPES(), `s')')dnl
dnl
dnl
ifdef(`DO_NS', `_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `nasm')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `NS_')'dnl
`_ARRSET(`ARR_ANY_BUILD_FILEEXTS', NUM_ANY_BUILD_TYPES(), `nasm')')dnl
dnl
dnl
define(`STATUS_ANTLR_JSONCPP', ifdef(`ANTLR', ifdef(`JSONCPP', `both', `just_antlr'), ifdef(`JSONCPP', `just_jsoncpp', `neither')))dnl
dnl
ifelse(STATUS_ANTLR_JSONCPP(), `both', `SHARED_SRC_DIRS:=src \
	src/gen_src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `just_antlr', `SHARED_SRC_DIRS:=src \
	src/gen_src \', 
	STATUS_ANTLR_JSONCPP(), `just_jsoncpp', `SHARED_SRC_DIRS:=src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `neither', `SHARED_SRC_DIRS:=src \')

_FOR(`i', 1, NUM_ANY_BUILD_TYPES(), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', i()),DIRS)':=$(SHARED_SRC_DIRS)
)dnl
# End of source directories


# Whether or not to do debugging stuff
#DEBUG:=yeah do debug

DEBUG_OPTIMIZATION_LEVEL:=-O0
REGULAR_OPTIMIZATION_LEVEL:=-O2

ifdef(`ANTLR', `NUM_JOBS:=8
GRAMMAR_PREFIX:=Grammar', `')`'dnl

ALWAYS_DEBUG_SUFFIX:=_debug
ifdef DEBUG
	DEBUG_SUFFIX:=$(ALWAYS_DEBUG_SUFFIX)
endif

# This is the name of the output file.  Change this if needed!
PROJ:=$(shell basename $(CURDIR))$(DEBUG_SUFFIX)

define(`__INITIAL_BASE_FLAGS', `-Wall')dnl
ifdef(`HAVE_DISASSEMBLE', 
`undivert(include/this_is_used_for_do_asmouts.txt)',
`')`'dnl


dnl #if defined(GBA)
dnl PREFIX:=$(DEVKITARM)/bin/arm-none-eabi-
dnl #elif defined(DO_ARM)
dnl PREFIX:=arm-none-eabi-
dnl #elif defined(DO_MIPS)
dnl PREFIX:=mips-elf-
dnl #endif
dnl 
dnl # Compilers and initial compiler flags
dnl #ifdef DO_CXX
dnl CXX:=$(PREFIX)g++
dnl #ifndef DO_MIPS
dnl #ifndef JSONCPP
dnl CXX_FLAGS:=$(CXX_FLAGS) -std=c++17 __INITIAL_BASE_FLAGS
dnl #else
dnl CXX_FLAGS:=$(CXX_FLAGS) -std=c++17 __INITIAL_BASE_FLAGS \\
dnl 	$(shell pkg-config --cflags jsoncpp)
dnl #endif
dnl #else
dnl CXX_FLAGS:=$(CXX_FLAGS) -std=c++14 __INITIAL_BASE_FLAGS
dnl #endif
dnl 
dnl #endif
dnl #if (defined(DO_C) || !defined(DO_CXX))
dnl CC:=$(PREFIX)gcc
dnl #endif
dnl #ifdef DO_C
dnl C_FLAGS:=$(C_FLAGS) -std=c11 __INITIAL_BASE_FLAGS
dnl 
dnl #endif
dnl #ifdef DO_S
dnl AS:=$(PREFIX)as
dnl #ifndef DO_NON_X86
dnl S_FLAGS:=$(S_FLAGS) -mnaked-reg #-msyntax=intel
dnl #endif
dnl 
dnl #endif
dnl #ifdef DO_NS
dnl NS:=nasm
dnl NS_FLAGS:=$(NS_FLAGS) -f elf64
