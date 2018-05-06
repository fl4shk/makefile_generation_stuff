include(include/misc_defines.m4)dnl
# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.
dnl 
define(`DO_CXX')dnl
define(`DO_C')dnl
define(`DO_AS')dnl
define(`DO_NASM')dnl
_SET(`BUILD_TYPES_ARR', `num_any_build_types', 0)dnl
dnl ifdef(`DO_CXX', _SET(`BUILD_TYPES_ARR', `num_any_build_types'
dnl 	eval(_GET(`BUILD_TYPES_ARR', `num_any_build_types') + 1)))dnl
dnl ifdef(`DO_CXX', _ARRINCR(`BUILD_TYPES_ARR', `num_any_build_types'))
dnl _ARRINCR(`BUILD_TYPES_ARR', `num_any_build_types')
dnl _ARRINCR(`BUILD_TYPES_ARR', `num_any_build_types')
dnl _ARRINCR(`BUILD_TYPES_ARR', `num_any_build_types')
dnl _ARRINCR(`BUILD_TYPES_ARR', `num_any_build_types')
dnl
dnl define(`ANTLR')dnl
dnl define(`JSONCPP')dnl
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

_GET(`BUILD_TYPES_ARR', `num_any_build_types')
