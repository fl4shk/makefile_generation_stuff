include(include/misc_defines.m4)dnl
ifdef(`GENERIC',`define(`DO_S')'`define(`HAVE_DISASSEMBLE')')dnl
ifdef(`DO_ARM',`define(`DO_EMBEDDED')')dnl
ifdef(`DO_EMBEDDED',`define(`DO_S')'`define(`HAVE_DISASSEMBLE')')dnl
# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.
dnl
dnl
dnl Source code languages schtick
define(`NUM_ANY_BUILD_TYPES', 0)dnl
define(`NUM_NON_HLL_BUILD_TYPES', 0)dnl
define(`NUM_MISC_BUILD_TYPES', 0)dnl
define(`NUM_HLL_BUILD_TYPES', 0)dnl
dnl
dnl Getters for shorter m4 source lines
define(`GET_HLL_BUILD_TYPE', `_ARRGET(`ARR_HLL_BUILD_TYPES', $1)')dnl
define(`GET_HLL_BUILD_PREFIX', `_ARRGET(`ARR_HLL_BUILD_PREFIXES', $1)')dnl
define(`GET_HLL_BUILD_EXTRA_PREFIX', `_ARRGET(`ARR_HLL_BUILD_EXTRA_PREFIXES', $1)')dnl
define(`GET_HLL_BUILD_FILEEXT', `_ARRGET(`ARR_HLL_BUILD_FILEEXTS', $1)')dnl
define(`GET_HLL_BUILD_COMPILER', `_ARRGET(`ARR_HLL_BUILD_COMPILERS', $1)')dnl
dnl
define(`GET_NON_HLL_BUILD_TYPE', `_ARRGET(`ARR_NON_HLL_BUILD_TYPES', $1)')dnl
define(`GET_NON_HLL_BUILD_PREFIX', `_ARRGET(`ARR_NON_HLL_BUILD_PREFIXES', $1)')dnl
define(`GET_NON_HLL_BUILD_EXTRA_PREFIX', `_ARRGET(`ARR_NON_HLL_BUILD_EXTRA_PREFIXES', $1)')dnl
define(`GET_NON_HLL_BUILD_FILEEXT', `_ARRGET(`ARR_NON_HLL_BUILD_FILEEXTS', $1)')dnl
define(`GET_NON_HLL_BUILD_ASSEMBLER', `_ARRGET(`ARR_NON_HLL_BUILD_ASSEMBLERS', $1)')dnl
dnl
define(`GET_MISC_BUILD_TYPE', `_ARRGET(`ARR_MISC_BUILD_TYPES', $1)')dnl
define(`GET_MISC_BUILD_PREFIX', `_ARRGET(`ARR_MISC_BUILD_PREFIXES', $1)')dnl
define(`GET_MISC_BUILD_EXTRA_PREFIX', `_ARRGET(`ARR_MISC_BUILD_EXTRA_PREFIXES', $1)')dnl
define(`GET_MISC_BUILD_FILEEXT', `_ARRGET(`ARR_MISC_BUILD_FILEEXTS', $1)')dnl
dnl
define(`GET_ANY_BUILD_TYPE', `_ARRGET(`ARR_ANY_BUILD_TYPES', $1)')dnl
define(`GET_ANY_BUILD_PREFIX', `_ARRGET(`ARR_ANY_BUILD_PREFIXES', $1)')dnl
define(`GET_ANY_BUILD_EXTRA_PREFIX', `_ARRGET(`ARR_ANY_BUILD_EXTRA_PREFIXES', $1)')dnl
define(`GET_ANY_BUILD_FILEEXT', `_ARRGET(`ARR_ANY_BUILD_FILEEXTS', $1)')dnl
dnl
define(`MAKE_LIST_OF_ANY_GENERATED_FILES',`_FOR(`i', 1, eval(NUM_ANY_BUILD_TYPES() - 1), 
$(`_CONCAT(GET_ANY_BUILD_PREFIX(i()), $1)')` ')'`ifelse(NUM_ANY_BUILD_TYPES(), 0, `', $(`_CONCAT(GET_ANY_BUILD_PREFIX(NUM_ANY_BUILD_TYPES()), `$1')'))')
define(`MAKE_LIST_OF_HLL_GENERATED_FILES',`_FOR(`i', 1, eval(NUM_HLL_BUILD_TYPES() - 1), 
$(`_CONCAT(GET_HLL_BUILD_PREFIX(i()), $1)')` ')'`ifelse(NUM_HLL_BUILD_TYPES(), 0, `', $(`_CONCAT(GET_HLL_BUILD_PREFIX(NUM_HLL_BUILD_TYPES()), `$1')'))')
dnl
_INCR(`NUM_HLL_BUILD_TYPES')dnl
_INCR(`NUM_ANY_BUILD_TYPES')dnl
dnl
_ARRSET(`ARR_HLL_BUILD_TYPES', NUM_HLL_BUILD_TYPES(), `d')dnl
_ARRSET(`ARR_HLL_BUILD_PREFIXES', NUM_HLL_BUILD_TYPES(), `D_')dnl
_ARRSET(`ARR_HLL_BUILD_EXTRA_PREFIXES', NUM_HLL_BUILD_TYPES(), `D_')dnl
_ARRSET(`ARR_HLL_BUILD_FILEEXTS', NUM_HLL_BUILD_TYPES(), `d')dnl
_ARRSET(`ARR_HLL_BUILD_COMPILERS', NUM_HLL_BUILD_TYPES(), `DC')dnl
dnl
_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `d')dnl
_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `D_')dnl
dnl
dnl
ifdef(`DO_S', `_INCR(`NUM_NON_HLL_BUILD_TYPES')'dnl
`_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_NON_HLL_BUILD_TYPES', NUM_NON_HLL_BUILD_TYPES(), `as')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_PREFIXES', NUM_NON_HLL_BUILD_TYPES(), `S_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_EXTRA_PREFIXES', NUM_NON_HLL_BUILD_TYPES(), `S_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_FILEEXTS', NUM_NON_HLL_BUILD_TYPES(), `s')'dnl
dnl hash table type stuff
`_ARRSET(`ARR_NON_HLL_BUILD_TYPES', `asm', `as')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_PREFIXES', `asm', `S_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_EXTRA_PREFIXES', `asm', `S_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_FILEEXTS', `asm', `s')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_ASSEMBLERS', `asm', `AS')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `as')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `S_')')dnl
dnl
dnl
ifdef(`DO_EMBEDDED', `_INCR(`NUM_MISC_BUILD_TYPES')'dnl
`_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_MISC_BUILD_TYPES', NUM_MISC_BUILD_TYPES(), `bin')'dnl
`_ARRSET(`ARR_MISC_BUILD_PREFIXES', NUM_MISC_BUILD_TYPES(), `BIN_')'dnl
`_ARRSET(`ARR_MISC_BUILD_EXTRA_PREFIXES', NUM_MISC_BUILD_TYPES(), `BIN_')'dnl
`_ARRSET(`ARR_MISC_BUILD_FILEEXTS', NUM_MISC_BUILD_TYPES(), `bin')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `bin')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `BIN_')')dnl
dnl
dnl
SHARED_SRC_DIRS:=src

_FOR(`i', 1, NUM_ANY_BUILD_TYPES(), `_CONCAT(`GET_ANY_BUILD_PREFIX(i())',`DIRS')':=$(SHARED_SRC_DIRS)
)dnl
# End of source directories


# Whether or not to do debugging stuff
#DEBUG:=yeah do debug

DEBUG_OPTIMIZATION_LEVEL:=-O0
REGULAR_OPTIMIZATION_LEVEL:=-O2


ALWAYS_DEBUG_SUFFIX:=_debug
ifdef DEBUG
	DEBUG_SUFFIX:=$(ALWAYS_DEBUG_SUFFIX)
endif

# This is the name of the output file.  Change this if needed!
PROJ:=$(shell basename $(CURDIR))$(DEBUG_SUFFIX)

ifelse(_IFELSEDEF(`DO_ARM'), 1, `NON_D_PREFIX:=arm-none-eabi-'
,
`'dnl
)dnl

# Compilers and initial compiler flags
DC:=ldc2
