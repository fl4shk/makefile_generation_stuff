include(include/misc_defines.m4)dnl
# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.
dnl 
define(`DO_CXX')dnl (temporary)
define(`DO_C')dnl (temporary)
define(`DO_AS')dnl (temporary)
define(`DO_NASM')dnl (temporary)
dnl
dnl
define(`NUM_ANY_BUILD_TYPES', 0)dnl
define(`NUM_HLL_BUILD_TYPES', 0)dnl
ifdef(`DO_CXX', `_ARRSET(`ARR_HLL_BUILD_TYPES', NUM_HLL_BUILD_TYPES(), `cxx')'dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `cxx')'dnl
`_INCR(`NUM_ANY_BUILD_TYPES')'dnl
`_INCR(`NUM_HLL_BUILD_TYPES')')dnl
ifdef(`DO_C', `_ARRSET(`ARR_HLL_BUILD_TYPES', NUM_HLL_BUILD_TYPES(), `c')'dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `c')'dnl
`_INCR(`NUM_ANY_BUILD_TYPES')'dnl
`_INCR(`NUM_HLL_BUILD_TYPES')')dnl
ifdef(`DO_AS', `_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `as')'dnl
`_INCR(`NUM_HLL_BUILD_TYPES')')dnl
ifdef(`DO_NASM', `_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `nasm')'dnl
`_INCR(`NUM_HLL_BUILD_TYPES')')dnl
dnl
dnl define(`ANTLR')dnl (temporary)
dnl define(`JSONCPP')dnl (temporary)
dnl
define(`STATUS_ANTLR_JSONCPP', ifdef(`ANTLR', ifdef(`JSONCPP', `both', `just_antlr'), dnl
ifdef(`JSONCPP', `just_jsoncpp', `neither')))dnl
dnl
ifelse(STATUS_ANTLR_JSONCPP(), `both', `SHARED_SRC_DIRS := src \
	src/gen_src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `just_antlr', `SHARED_SRC_DIRS := src \
	src/gen_src \', 
	STATUS_ANTLR_JSONCPP(), `just_jsoncpp', `SHARED_SRC_DIRS := src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `neither', `SHARED_SRC_DIRS := src \')

dnl ifdef(`DO_CXX', `CXX_DIRS := $(SHARED_SRC_DIRS)')
dnl ifdef(`DO_C', `C_DIRS := $(SHARED_SRC_DIRS)')

NUM_ANY_BUILD_TYPES()
NUM_HLL_BUILD_TYPES()
STATUS_ANTLR_JSONCPP()
