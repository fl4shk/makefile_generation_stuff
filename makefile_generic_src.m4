include(include/misc_defines.m4)dnl
# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.
dnl 
define(`DO_CXX')dnl (temporary)
define(`DO_C')dnl (temporary)
define(`DO_S')dnl (temporary)
define(`DO_NS')dnl (temporary)
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
ifdef(`DO_NS', `_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `nasm')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `NS_')'dnl
`_ARRSET(`ARR_ANY_BUILD_FILEEXTS', NUM_ANY_BUILD_TYPES(), `nasm')')dnl
dnl
dnl
define(`STATUS_ANTLR_JSONCPP', ifdef(`ANTLR', ifdef(`JSONCPP', `both', `just_antlr'), dnl
ifdef(`JSONCPP', `just_jsoncpp', `neither')))dnl
dnl
ifelse(STATUS_ANTLR_JSONCPP(), `both', `SHARED_SRC_DIRS:=src \
	src/gen_src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `just_antlr', `SHARED_SRC_DIRS:=src \
	src/gen_src \', 
	STATUS_ANTLR_JSONCPP(), `just_jsoncpp', `SHARED_SRC_DIRS:=src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `neither', `SHARED_SRC_DIRS:=src \')

dnl _FOR(`i', 0, NUM_ANY_BUILD_TYPES(), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', `i')):=$(SHARED_SRC_DIRS)')
_FOR(`i', 1, NUM_ANY_BUILD_TYPES(), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', i()),DIRS)':=$(SHARED_SRC_DIRS)
)dnl

# End of source directories


# Whether or not to do debugging stuff
#DEBUG:=yeah do debug

DEBUG_OPTIMIZATION_LEVEL:=-O0
REGULAR_OPTIMIZATION_LEVEL:=-O2

ifdef(`ANTLR', `NUM_JOBS:=8')

ALWAYS_DEBUG_SUFFIX:=_debug
ifdef DEBUG
	DEBUG_SUFFIX:=$(ALWAYS_DEBUG_SUFFIX)
endif

# This is the name of the output file.  Change this if needed!
PROJ:=$(shell basename $(CURDIR))$(DEBUG_SUFFIX)

ifdef(`ANTLR', `GRAMMAR_PREFIX:=Grammar')dnl

define(`INITIAL_BASE_FLAGS', `-Wall')dnl

ifdef(`HAVE_DISASSEMBLE', `# This is used for do_asmouts'
`#VERBOSE_ASM_FLAG:=-fverbose-asm')dnl

ifelse(ifdef(`DO_GBA', 1, 0), 1, `PREFIX:=$(DEVKITARM)/bin/arm-none-eabi-',
	ifdef(`DO_ARM', 1, 0), 1, `PREFIX:=arm-none-eabi',dnl
	ifdef(`DO_MIPS', 1, 0), 1, `PREFIX:=mips-elf-')dnl

# Compilers and initial compiler flags
ifdef(`DO_CXX', `CXX:=$(PREFIX)g++'
ifelse(ifdef(`JSONCPP', 1, 0), 0, dnl
`CXX_FLAGS:=$(CXX_FLAGS) -std=c++17 'INITIAL_BASE_FLAGS(),dnl
ifdef(`JSONCPP', 1, 0), 1, dnl
`CXX_FLAGS:=$(CXX_FLAGS) -std=c++17 'INITIAL_BASE_FLAGS()` \'dnl
`$(shell pkg-config --cflags jsoncpp)'))dnl

ifdef(`DO_C', `CC:=$(PREFIX)gcc'
`C_FLAGS:=$(C_FLAGS) -std=11 'INITIAL_BASE_FLAGS())dnl

ifdef(`DO_S', `AS:=$(PREFIX)as' 
ifelse(ifdef(`DO_NON_X86', 1, 0), 0, 
`S_FLAGS:=$(S_FLAGS) -mnaked-reg #-msyntax-intel'
))
ifdef(`DO_NS', `NS:=nasm'
`NS_FLAGS:=$(NS_FLAGS) -f elf64')

ifdef(`HAVE_DISASSEMBLE', `OBJDUMP:=$(PREFIX)objdump')

ifdef(`DO_EMBEDDED', `OBJCOPY:=$(PREFIX)objcopy')

ifdef(`DO_CXX', `LD:=$(CXX)', `LD:=$(CC)')

# Initial linker flags
ifelse(STATUS_ANTLR_JSONCPP(), `neither', `LD_FLAGS:=$(LD_FLAGS) -lm',
STATUS_ANTLR_JSONCPP(), `just_antlr', `LD_FLAGS:=$(LD_FLAGS) -lm \'
	`-lantlr4-runtime \',
STATUS_ANTLR_JSONCPP(), `just_jsoncpp', `LD_FLAGS:=$(LD_FLAGS) -lm \'
	`-ljsoncpp \',
STATUS_ANTLR_JSONCPP(), `both', `LD_FLAGS:=$(LD_FLAGS) -lm \'
	`-lantlr4-runtime \'
	`-ljsoncpp \')


