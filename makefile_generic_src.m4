include(include/misc_defines.m4)dnl
include(include/generic.m4)dnl
# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.
dnl
dnl
dnl Source code languages schtick
define(`NUM_ANY_BUILD_TYPES', 0)dnl
define(`NUM_NON_HLL_BUILD_TYPES', 0)dnl
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
`_INCR(`NUM_NON_HLL_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_NON_HLL_BUILD_TYPES', NUM_NON_HLL_BUILD_TYPES(), `as')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_PREFIXES', NUM_NON_HLL_BUILD_TYPES(), `S_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_FILEEXTS', NUM_NON_HLL_BUILD_TYPES(), `s')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `as')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `S_')'dnl
`_ARRSET(`ARR_ANY_BUILD_FILEEXTS', NUM_ANY_BUILD_TYPES(), `s')')dnl
dnl
dnl
ifdef(`DO_NS', `_INCR(`NUM_ANY_BUILD_TYPES')'dnl
`_INCR(`NUM_NON_HLL_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_NON_HLL_BUILD_TYPES', NUM_NON_HLL_BUILD_TYPES(), `nasm')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_PREFIXES', NUM_NON_HLL_BUILD_TYPES(), `NS_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_FILEEXTS', NUM_NON_HLL_BUILD_TYPES(), `nasm')'dnl
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
GRAMMAR_PREFIX:=Grammar'
, `')dnl

ALWAYS_DEBUG_SUFFIX:=_debug
ifdef DEBUG
	DEBUG_SUFFIX:=$(ALWAYS_DEBUG_SUFFIX)
endif

# This is the name of the output file.  Change this if needed!
PROJ:=$(shell basename $(CURDIR))$(DEBUG_SUFFIX)

define(`__INITIAL_BASE_FLAGS', `-Wall')dnl
ifdef(`HAVE_DISASSEMBLE', 
`undivert(include/this_is_used_for_do_asmouts.txt)',
`')dnl
dnl
dnl
ifelse(_IFDEF(`DO_GBA'), `PREFIX:=$(DEVKITARM)/bin/arm-none-eabi-'
,
_IFDEF(`DO_ARM'), `PREFIX:=arm-none-eabi-'
,
`')dnl

# Compilers and initial compiler flags
ifdef(`DO_CXX', `CXX:=$(PREFIX)g++'
ifelse(_IFNDEF(`JSONCPP'),
`CXX_FLAGS:=$(CXX_FLAGS) -std=c++17 '__INITIAL_BASE_FLAGS()

,
_IFDEF(`JSONCPP'), 
`CXX_FLAGS:=$(CXX_FLAGS) -std=c++17 '__INITIAL_BASE_FLAGS()` \'
	`$(shell pkg-config --cflags jsoncpp)'

))dnl
dnl
dnl
ifelse(_IFDEF(`DO_C'), `CC:=$(PREFIX)gcc'
,
_IFNDEF(`DO_CXX'), `CC:=$(PREFIX)gcc'
)dnl
ifdef(`DO_C', `C_FLAGS:=$(C_FLAGS) -std=c11 '__INITIAL_BASE_FLAGS()

)dnl
dnl
dnl
ifdef(`DO_S', `AS:=$(PREFIX)as'
`ifelse(_IFNDEF(`DO_NON_X86'), `undivert(include/s_flags.txt)')'
,
`')dnl
dnl
dnl
ifdef(`DO_NS', `NS:=nasm'
`NS_FLAGS:=$(NS_FLAGS) -f elf64'

,
`')dnl
dnl
dnl
ifdef(`HAVE_DISASSEMBLE', `OBJDUMP:=$(PREFIX)objdump'
,
`')dnl
ifdef(`DO_EMBEDDED', `OBJCOPY:=$(PREFIX)objcopy'
,
`')dnl
ifelse(_IFDEF(`HAVE_DISASSEMBLE'), `'
,
_IFDEF(`DO_EMBEDDED'), `'
,
`')dnl
dnl
dnl
ifdef(`DO_CXX', `LD:=$(CXX)', `LD:=$(CC)')

# Initial linker flags
ifelse(STATUS_ANTLR_JSONCPP(), `neither', `LD_FLAGS:=$(LD_FLAGS) -lm'
,
`LD_FLAGS:=$(LD_FLAGS) -lm \'
ifdef(`ANTLR',
`	-lantlr4-runtime \')
ifdef(`JSONCPP',
`	-ljsoncpp \')
)


ifdef DEBUG
	EXTRA_DEBUG_FLAGS:=-g
	DEBUG_FLAGS:=-gdwarf-3 $(EXTRA_DEBUG_FLAGS)
	EXTRA_LD_FLAGS:=$(DEBUG_FLAGS)
	OPTIMIZATION_LEVEL:=$(DEBUG_OPTIMIZATION_LEVEL)
else
	OPTIMIZATION_LEVEL:=$(REGULAR_OPTIMIZATION_LEVEL)
endif


ifdef(`DO_EMBEDDED', `LD_SCRIPT:=linkscript.ld'
`COMMON_LD_FLAGS:=$(COMMON_LD_FLAGS) -T $(LD_SCRIPT)'
,
`')dnl
dnl
ifdef(`DO_NON_X86', `define(`__EXTRA_BASE_FLAGS', `-fno-threadsafe-statics -nostartfiles')'`define(`__EXTRA_LD_FLAGS', `-lm -lgcc -lc -lstdc++')'

,
`')dnl
dnl
ifdef(`DO_ARM', `EXTRA_BASE_FLAGS:=-mcpu=arm7tdmi -mtune=arm7tdmi -mthumb \'
`	-mthumb-interwork \'
`	'__EXTRA_BASE_FLAGS()

`EXTRA_LD_FLAGS:=$(EXTRA_LD_FLAGS) -mthumb --specs=nosys.specs \'
`	'__EXTRA_LD_FLAGS()
ifdef(`DO_GBA', `COMMON_LD_FLAGS:=$(COMMON_LD_FLAGS) -L$(DEVKITPRO)/libgba/lib \'
`	-Wl,--entry=_start2 -lmm'
,

`')dnl
ifdef(`HAVE_DISASSEMBLE', `DISASSEMBLE_BASE_FLAGS:=-marm7tdmi'

,
`'))dnl

FINAL_BASE_FLAGS:=$(OPTIMIZATION_LEVEL) \
	$(EXTRA_BASE_FLAGS) $(EXTRA_DEBUG_FLAGS)
ifdef(`DO_GBA', `FINAL_BASE_FLAGS:=-I$(DEVKITPRO)/libgba/include $(FINAL_BASE_FLAGS)'
,
`')dnl

# Final compiler and linker flags
ifdef(`DO_CXX', `CXX_FLAGS:=$(CXX_FLAGS) $(FINAL_BASE_FLAGS)'
,
`')dnl
ifdef(`DO_C', `C_FLAGS:=$(C_FLAGS) $(FINAL_BASE_FLAGS)'
,
`')dnl
LD_FLAGS:=$(LD_FLAGS) $(EXTRA_LD_FLAGS) $(COMMON_LD_FLAGS)




# Generated directories
OBJDIR:=objs$(DEBUG_SUFFIX)
ifdef(`HAVE_DISASSEMBLE', `ASMOUTDIR:=asmouts$(DEBUG_SUFFIX)'
,
`')dnl
DEPDIR:=deps$(DEBUG_SUFFIX)
ifdef(`HAVE_ONLY_PREPROCESS', `PREPROCDIR:=preprocs$(DEBUG_SUFFIX)'
,
`')dnl

_FOR(`i', 1, NUM_HLL_BUILD_TYPES(), 
`_GEN_SOURCES(_ARRGET(`ARR_HLL_BUILD_PREFIXES', i()), _ARRGET(`ARR_HLL_BUILD_PREFIXES', i()),
_ARRGET(`ARR_HLL_BUILD_FILEEXTS', i()))'
`_GEN_OTHER_FILES(_ARRGET(`ARR_HLL_BUILD_PREFIXES', i()), `OFILES',
_ARRGET(`ARR_HLL_BUILD_FILEEXTS', i()), `OBJDIR', `o')'
`_GEN_OTHER_FILES(_ARRGET(`ARR_HLL_BUILD_PREFIXES', i()), `PFILES',
_ARRGET(`ARR_HLL_BUILD_FILEEXTS', i()), `DEPDIR', `P')'
`ifdef(`HAVE_DISASSEMBLE', 
`'
`undivert(include/assembly_source_code_generated_by_gcc_gplusplus.txt)'`_GEN_OTHER_FILES(_ARRGET(`ARR_HLL_BUILD_PREFIXES', i()), `ASMOUTS',
_ARRGET(`ARR_HLL_BUILD_FILEEXTS', i()), `ASMOUTDIR', `s')'

,
`')'dnl

)ifelse(NUM_NON_HLL_BUILD_TYPES(), 0, 
`', _FOR(`i', 1, NUM_NON_HLL_BUILD_TYPES(), 
`_GEN_SOURCES(_ARRGET(`ARR_NON_HLL_BUILD_PREFIXES', i()), _ARRGET(`ARR_NON_HLL_BUILD_PREFIXES', i()),
_ARRGET(`ARR_NON_HLL_BUILD_FILEEXTS', i()))'
`_GEN_OTHER_FILES(_ARRGET(`ARR_NON_HLL_BUILD_PREFIXES', i()), `OFILES',
_ARRGET(`ARR_NON_HLL_BUILD_FILEEXTS', i()), `OBJDIR', `o')'
`_GEN_OTHER_FILES(_ARRGET(`ARR_NON_HLL_BUILD_PREFIXES', i()), `PFILES',
_ARRGET(`ARR_NON_HLL_BUILD_FILEEXTS', i()), `DEPDIR', `P')'

))
dnl
dnl
# Compiler-generated files
# OFILES are object code files (extension .o)
OFILES:=_FOR(`i', 1, eval(NUM_ANY_BUILD_TYPES() - 1), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', i()), `OFILES')'` ')ifelse(NUM_ANY_BUILD_TYPES(), 0, `', `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES()), `OFILES')')
# PFILES are used for automatic dependency generation
PFILES:=_FOR(`i', 1, eval(NUM_ANY_BUILD_TYPES() - 1), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', i()), `PFILES')'` ')ifelse(NUM_ANY_BUILD_TYPES(), 0, `', `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES()), `PFILES')')
dnl
dnl
ifdef(`HAVE_DISASSEMBLE', ASMOUTS:=_FOR(`i', 1, eval(NUM_HLL_BUILD_TYPES() - 1), `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', i()), `ASMOUTS')'` ')ifelse(NUM_HLL_BUILD_TYPES(), 0, `', `_CONCAT(_ARRGET(`ARR_ANY_BUILD_PREFIXES', NUM_HLL_BUILD_TYPES()), `ASMOUTS')')
,
`')dnl

