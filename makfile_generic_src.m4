include(include/misc_defines.m4)dnl
# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.
dnl 
define(`DO_CXX')dnl (temporary)
define(`DO_C')dnl (temporary)
define(`DO_S')dnl (temporary)
define(`DO_NASM')dnl (temporary)
dnl define(`ANTLR')dnl (temporary)
dnl define(`JSONCPP')dnl (temporary)
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
ifdef(`DO_NASM', `_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `nasm')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `NS_')'dnl
`_ARRSET(`ARR_ANY_BUILD_FILEEXTS', NUM_ANY_BUILD_TYPES(), `nasm')')dnl
dnl
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

dnl _FOR(`i', 0, NUM_ANY_BUILD_TYPES(), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', `i')) := $(SHARED_SRC_DIRS)')
_FOR(`i', 1, NUM_ANY_BUILD_TYPES(), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', i()),DIRS)' := $(SHARED_SRC_DIRS)
)dnl
