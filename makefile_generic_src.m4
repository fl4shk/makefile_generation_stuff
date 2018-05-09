define(`STATUS_ANTLR_JSONCPP', ifdef(`ANTLR', ifdef(`JSONCPP', `both', `just_antlr'), ifdef(`JSONCPP', `just_jsoncpp', `neither')))dnl
dnl
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
dnl define(`MAKE_LIST_OF_ANY_GENERATED_FILES',`_FOR(`i', 1, eval(NUM_ANY_BUILD_TYPES() - 1), $(`_CONCAT(GET_ANY_BUILD_PREFIX(i()), `$1')')` ')'`ifelse(NUM_ANY_BUILD_TYPES(), 0, `', $(`_CONCAT(GET_ANY_BUILD_PREFIX(NUM_ANY_BUILD_TYPES()), `$1')'))')
dnl define(`MAKE_LIST_OF_HLL_GENERATED_FILES',`_FOR(`i', 1, eval(NUM_HLL_BUILD_TYPES() - 1), $(`_CONCAT(GET_HLL_BUILD_PREFIX(i()), `$1')')` ')'`ifelse(NUM_HLL_BUILD_TYPES(), 0, `', $(`_CONCAT(GET_HLL_BUILD_PREFIX(NUM_HLL_BUILD_TYPES()), `$1')'))')
dnl
define(`MAKE_LIST_OF_ANY_GENERATED_FILES',`_FOR(`i', 1, eval(NUM_ANY_BUILD_TYPES() - 1), 
$(`_CONCAT(GET_ANY_BUILD_PREFIX(i()), $1)')` ')'`ifelse(NUM_ANY_BUILD_TYPES(), 0, `', $(`_CONCAT(GET_ANY_BUILD_PREFIX(NUM_ANY_BUILD_TYPES()), `$1')'))')
define(`MAKE_LIST_OF_HLL_GENERATED_FILES',`_FOR(`i', 1, eval(NUM_HLL_BUILD_TYPES() - 1), 
$(`_CONCAT(GET_HLL_BUILD_PREFIX(i()), $1)')` ')'`ifelse(NUM_HLL_BUILD_TYPES(), 0, `', $(`_CONCAT(GET_HLL_BUILD_PREFIX(NUM_HLL_BUILD_TYPES()), `$1')'))')
dnl
ifdef(`DO_CXX', `_INCR(`NUM_HLL_BUILD_TYPES')'dnl
`_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_HLL_BUILD_TYPES', NUM_HLL_BUILD_TYPES(), `cxx')'dnl
`_ARRSET(`ARR_HLL_BUILD_PREFIXES', NUM_HLL_BUILD_TYPES(), `CXX_')'dnl
`_ARRSET(`ARR_HLL_BUILD_EXTRA_PREFIXES', NUM_HLL_BUILD_TYPES(), `CXX_')'dnl
`_ARRSET(`ARR_HLL_BUILD_FILEEXTS', NUM_HLL_BUILD_TYPES(), `cpp')'dnl
`_ARRSET(`ARR_HLL_BUILD_COMPILERS', NUM_HLL_BUILD_TYPES(), `CXX')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `cxx')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `CXX_')')dnl
dnl
dnl
ifdef(`DO_C', `_INCR(`NUM_HLL_BUILD_TYPES')'dnl
`_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_HLL_BUILD_TYPES', NUM_HLL_BUILD_TYPES(), `c')'dnl
`_ARRSET(`ARR_HLL_BUILD_PREFIXES', NUM_HLL_BUILD_TYPES(), `C_')'dnl
`_ARRSET(`ARR_HLL_BUILD_EXTRA_PREFIXES', NUM_HLL_BUILD_TYPES(), `C_')'dnl
`_ARRSET(`ARR_HLL_BUILD_FILEEXTS', NUM_HLL_BUILD_TYPES(), `c')'dnl
`_ARRSET(`ARR_HLL_BUILD_COMPILERS', NUM_HLL_BUILD_TYPES(), `CC')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `c')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `C_')')dnl
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
ifdef(`DO_NS', `_INCR(`NUM_NON_HLL_BUILD_TYPES')'dnl
`_INCR(`NUM_ANY_BUILD_TYPES')'dnl
dnl
`_ARRSET(`ARR_NON_HLL_BUILD_TYPES', NUM_NON_HLL_BUILD_TYPES(), `nasm')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_PREFIXES', NUM_NON_HLL_BUILD_TYPES(), `NS_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_EXTRA_PREFIXES', NUM_NON_HLL_BUILD_TYPES(), `S_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_FILEEXTS', NUM_NON_HLL_BUILD_TYPES(), `nasm')'dnl
dnl hash table type stuff
`_ARRSET(`ARR_NON_HLL_BUILD_TYPES', `nasm', `nasm')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_PREFIXES', `nasm', `NS_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_EXTRA_PREFIXES', `nasm', `S_')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_FILEEXTS', `nasm', `nasm')'dnl
`_ARRSET(`ARR_NON_HLL_BUILD_ASSEMBLERS', `nasm', `nasm')'dnl
dnl
`_ARRSET(`ARR_ANY_BUILD_TYPES', NUM_ANY_BUILD_TYPES(), `nasm')'dnl
`_ARRSET(`ARR_ANY_BUILD_PREFIXES', NUM_ANY_BUILD_TYPES(), `NS_')')dnl
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
ifelse(STATUS_ANTLR_JSONCPP(), `both', `SHARED_SRC_DIRS:=src \
	src/gen_src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `just_antlr', `SHARED_SRC_DIRS:=src \
	src/gen_src \', 
	STATUS_ANTLR_JSONCPP(), `just_jsoncpp', `SHARED_SRC_DIRS:=src \
	src/liborangepower_src \', 
	STATUS_ANTLR_JSONCPP(), `neither', `SHARED_SRC_DIRS:=src \')

_FOR(`i', 1, NUM_ANY_BUILD_TYPES(), `_CONCAT(`GET_ANY_BUILD_PREFIX(i())',`DIRS')':=$(SHARED_SRC_DIRS)
)dnl
# End of source directories


# Whether or not to do debugging stuff
#DEBUG:=yeah do debug

DEBUG_OPTIMIZATION_LEVEL:=-O0
REGULAR_OPTIMIZATION_LEVEL:=-O2

ifdef(`ANTLR', `GRAMMAR_PREFIX:=Grammar'
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
`'
`EXTRA_LD_FLAGS:=$(EXTRA_LD_FLAGS) -mthumb --specs=nosys.specs \'
`	'__EXTRA_LD_FLAGS()
`ifdef(`DO_GBA',
`COMMON_LD_FLAGS:=$(COMMON_LD_FLAGS) -L$(DEVKITPRO)/libgba/lib \'
`	-Wl,--entry=_start2 -lmm'
,
`')'dnl
`ifdef(`HAVE_DISASSEMBLE', `DISASSEMBLE_BASE_FLAGS:=-marm7tdmi'
,
`')'dnl
,
`')dnl


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


_FOR(`i', 1, NUM_MISC_BUILD_TYPES(), 
`_GEN_SOURCES(GET_MISC_BUILD_PREFIX(i()), GET_MISC_BUILD_EXTRA_PREFIX(i()),
GET_MISC_BUILD_FILEEXT(i()))'
`_GEN_OTHER_FILES(GET_MISC_BUILD_PREFIX(i()), `OFILES',
GET_MISC_BUILD_FILEEXT(i()), `OBJDIR', `o')'
`_GEN_OTHER_FILES(GET_MISC_BUILD_PREFIX(i()), `PFILES',
GET_MISC_BUILD_FILEEXT(i()), `DEPDIR', `P')')

_FOR(`i', 1, NUM_HLL_BUILD_TYPES(), 
`_GEN_SOURCES(GET_HLL_BUILD_PREFIX(i()), GET_HLL_BUILD_EXTRA_PREFIX(i()),
GET_HLL_BUILD_FILEEXT(i()))'
`_GEN_OTHER_FILES(GET_HLL_BUILD_PREFIX(i()), `OFILES',
GET_HLL_BUILD_FILEEXT(i()), `OBJDIR', `o')'
`_GEN_OTHER_FILES(GET_HLL_BUILD_PREFIX(i()), `PFILES',
GET_HLL_BUILD_FILEEXT(i()), `DEPDIR', `P')'
`ifdef(`HAVE_DISASSEMBLE', 
`'
`undivert(include/assembly_source_code_generated_by_gcc_gplusplus.txt)'`_GEN_OTHER_FILES(GET_HLL_BUILD_PREFIX(i()), `ASMOUTS',
GET_HLL_BUILD_FILEEXT(i()), `ASMOUTDIR', `s')'

,
`')'dnl

)ifelse(NUM_NON_HLL_BUILD_TYPES(), 0, 
`', _FOR(`i', 1, NUM_NON_HLL_BUILD_TYPES(), 
`_GEN_SOURCES(GET_NON_HLL_BUILD_PREFIX(i()), GET_NON_HLL_BUILD_EXTRA_PREFIX(i()),
GET_NON_HLL_BUILD_FILEEXT(i()))'
`_GEN_OTHER_FILES(GET_NON_HLL_BUILD_PREFIX(i()), `OFILES',
GET_NON_HLL_BUILD_FILEEXT(i()), `OBJDIR', `o')'
`_GEN_OTHER_FILES(GET_NON_HLL_BUILD_PREFIX(i()), `PFILES',
GET_NON_HLL_BUILD_FILEEXT(i()), `DEPDIR', `P')'

))
dnl
dnl
# Compiler-generated files
# OFILES are object code files (extension .o)
OFILES:=MAKE_LIST_OF_ANY_GENERATED_FILES(`OFILES')
# PFILES are used for automatic dependency generation
PFILES:=MAKE_LIST_OF_ANY_GENERATED_FILES(`PFILES')
dnl
dnl
ifdef(`HAVE_DISASSEMBLE', ASMOUTS:=MAKE_LIST_OF_HLL_GENERATED_FILES(`ASMOUTS')
,
`')dnl

ifdef(`HAVE_ONLY_PREPROCESS', `undivert(include/preprocessed_output_of_source_files.txt)',
`')dnl
ifdef(`HAVE_ONLY_PREPROCESS', _FOR(`i', 1, NUM_HLL_BUILD_TYPES(), 
`_GEN_OTHER_FILES(GET_HLL_BUILD_PREFIX(i()), `EFILES',
GET_HLL_BUILD_FILEEXT(i()), `PREPROCDIR', `E')'
),
`')dnl
ifdef(`HAVE_ONLY_PREPROCESS', EFILES:=MAKE_LIST_OF_HLL_GENERATED_FILES(`EFILES')
,
`')dnl

ifelse(_IFNDEF(`ANTLR'), `.PHONY : all'
`all : all_pre $(OFILES)'
ifdef(`DO_GBA', `$(LD) $(OBJDIR)/*.o -o $(PROJ).elf $(LD_FLAGS) -Wl,-M > linker_map.txt'
	`$(OBJCOPY) -O binary -S -g -R .iwram -R .bss -R .ewram -R .sram \'
	`-R .bss0 -R .bss1 -R .bss2 -R .bss3 -R .bss4 -R .bss5 -R .bss6 -R .bss7 \'
	`-R .bss8 -R .bss9 -R .bss10 -R .bss11 -R .bss12 -R .bss13 -R .bss14 -R .bss15 \'
	`-R .iwram_bss0 -R .iwram_bss1 -R .iwram_bss2 -R .iwram_bss3 \'
	`-R .iwram_bss4 -R .iwram_bss5 -R .iwram_bss6 -R .iwram_bss7 \'
	`-R .iwram_bss8 -R .iwram_bss9 -R .iwram_bss10 -R .iwram_bss11 \'
	`-R .iwram_bss12 -R .iwram_bss13 -R .iwram_bss14 -R .iwram_bss15 \'
	`-R .sram0 -R .sram1 -R .sram2 -R .sram3 -R .sram4 -R .sram5 -R .sram6 -R .sram7 \'
	`-R .sram8 -R .sram9 -R .sram10 -R .sram11 -R .sram12 -R .sram13 -R .sram14 -R .sram15 \'
	`$(PROJ).elf $(PROJ).gba'
	`./do_gbafix.sh',
	`$(LD) $(OFILES) -o $(PROJ) $(LD_FLAGS)'
), _IFDEF(`ANTLR'), 
`MODIFED_GENERATED_SOURCES:='
`FINAL_GENERATED_SOURCES:=src/gen_src/$(GRAMMAR_PREFIX)Parser.h'
`GENERATED_SOURCES:=$(MODIFED_GENERATED_SOURCES) \'
`	$(FINAL_GENERATED_SOURCES)'
`'
`.PHONY : all'
`all : all_pre $(MODIFED_GENERATED_SOURCES)'
`	@$(MAKE) final_generated'
`'
`.PHONY : final_generated'
`final_generated : all_pre $(FINAL_GENERATED_SOURCES)'
`	@$(MAKE) non_generated'
`'
`.PHONY : non_generated'
`non_generated : all_pre $(OFILES)'
`	$(LD) $(OFILES) -o $(PROJ) $(LD_FLAGS)'
)


# all_objs is ENTIRELY optional
.PHONY : all_objs
all_objs : all_pre $(OFILES)
	@#


ifdef(`HAVE_DISASSEMBLE', `.PHONY : do_asmouts'
`do_asmouts : all_pre all_pre_asmout $(ASMOUTS)'
`	@#'
,
`')

.PHONY : all_pre
ifelse(_IFNDEF(`ANTLR'), `all_pre :'
`	mkdir -p $(OBJDIR) $(DEPDIR)', _IFDEF(`ANTLR'), `all_pre :'
`	mkdir -p $(OBJDIR) $(DEPDIR) src/gen_src/')
	@for ofile in $(OFILES); \
	do \
		mkdir -p $$(dirname $$ofile); \
	done
	@for pfile in $(PFILES); \
	do \
		mkdir -p $$(dirname $$pfile); \
	done



ifdef(`HAVE_DISASSEMBLE', `.PHONY : all_pre_asmout'
`all_pre_asmout :'
`	mkdir -p $(ASMOUTDIR)'
`	@for asmout in $(ASMOUTS); \'
`	do \'
`		mkdir -p $$(dirname $$asmout); \'
`	done'
,
`')dnl

ifdef(`ANTLR', `src/gen_src/$(GRAMMAR_PREFIX)Parser.h : src/$(GRAMMAR_PREFIX).g4'
`	if [ ! -d src/gen_src ]; then make all_pre; fi; \'
`	cp src/$(GRAMMAR_PREFIX).g4 src/gen_src && cd src/gen_src \'
`	&& antlr4 -no-listener -visitor -Dlanguage=Cpp $(GRAMMAR_PREFIX).g4 \'
`	&& rm $(GRAMMAR_PREFIX).g4'
,
`')dnl
ifdef(`DO_GBA', `$(BIN_OFILES) : $(OBJDIR)/%.o : %.bin'
`	util/bin2o_gba.sh $< $@'
,
`')dnl

# Here's where things get really messy. 
dnl (especially in the .m4 source file!)
_FOR(`i', 1, NUM_HLL_BUILD_TYPES(), `$(_CONCAT(GET_HLL_BUILD_PREFIX(i()),OFILES)) : $(OBJDIR)/%.o : %.GET_HLL_BUILD_FILEEXT(i())'
`	@echo $@" was updated or has no object file.  (Re)Compiling...."'
`	'`$(GET_HLL_BUILD_COMPILER(i()))' $(`_CONCAT(GET_HLL_BUILD_PREFIX(i()),FLAGS)')` -MMD -c $< -o $@'
`	undivert(include/compile_last_part.txt)'
)
ifdef(`DO_S', `$(_CONCAT(GET_NON_HLL_BUILD_PREFIX(`asm'),OFILES)) : $(OBJDIR)/%.o : %.GET_NON_HLL_BUILD_FILEEXT(`asm')'
`	@echo $@" was updated or has no object file.  (Re)Assembling...."'
`	'`$(GET_NON_HLL_BUILD_ASSEMBLER(`asm'))' $(`_CONCAT(GET_NON_HLL_BUILD_PREFIX(`asm'),FLAGS)')` -MD $(OBJDIR)/$*.d -c $< -o $@'
`	undivert(include/compile_last_part.txt)'
,
`')dnl

ifdef(`HAVE_DISASSEMBLE', `undivert(include/here_we_have_stuff_for_outputting_assembly_source_code.txt)',
`')dnl
dnl
ifdef(`HAVE_DISASSEMBLE', `_FOR(`i', 1, NUM_HLL_BUILD_TYPES(), `$(_CONCAT(GET_HLL_BUILD_PREFIX(i()),ASMOUTS)) : $(ASMOUTDIR)/%.s : %.GET_HLL_BUILD_FILEEXT(i())'
`	'`$(GET_HLL_BUILD_COMPILER(i()))' $(`_CONCAT(GET_HLL_BUILD_PREFIX(i()),FLAGS)')` -MMD -S $(VERBOSE_ASM_FLAG) $< -o $@'
`	undivert(include/do_asmouts_last_part.txt)'
)'
,
`')dnl

-include $(PFILES)

#¯\(°_o)/¯

ifdef(`HAVE_ONLY_PREPROCESS', `.PHONY : only_preprocess'
`only_preprocess : only_preprocess_pre $(EFILES)'
`'
`.PHONY : only_preprocess_pre'
`only_preprocess_pre :'
`	mkdir -p $(DEPDIR) $(PREPROCDIR)'
`	@for efile in $(EFILES); \'
`	do \'
`		mkdir -p $$(dirname $$efile); \'
`	done'
`'
`'
`_FOR(`i', 1, NUM_HLL_BUILD_TYPES(), `$(_CONCAT(GET_HLL_BUILD_PREFIX(i()),EFILES)) : $(PREPROCDIR)/%.E : %.GET_HLL_BUILD_FILEEXT(i())'
`	'`$(GET_HLL_BUILD_COMPILER(i()))' $(`_CONCAT(GET_HLL_BUILD_PREFIX(i()),FLAGS)')` -MMD -E $< -o $@'
`	undivert(include/only_preprocess_last_part.txt)'
)'
,
`')dnl

.PHONY : clean
clean :
ifelse(_IFNDEF(`ANTLR'), 
`	rm -rfv $(OBJDIR) $(DEPDIR) $(ASMOUTDIR) $(PREPROCDIR) $(PROJ) tags *.taghl gmon.out',
_IFDEF(`ANTLR'), 
`	rm -rfv $(OBJDIR) $(DEPDIR) $(ASMOUTDIR) $(PREPROCDIR) $(PROJ) tags *.taghl gmon.out $(GENERATED_SOURCES) src/gen_src')


ifdef(`HAVE_DISASSEMBLE',
`# Flags for make disassemble*'
`DISASSEMBLE_FLAGS:=$(DISASSEMBLE_BASE_FLAGS) -C -d'
`DISASSEMBLE_ALL_FLAGS:=$(DISASSEMBLE_BASE_FLAGS) -C -D'
`'
`DISASSEMBLE_2_FLAGS:=$(DISASSEMBLE_BASE_FLAGS) -C -S -l -d'
`DISASSEMBLE_ALL_2_FLAGS:=$(DISASSEMBLE_BASE_FLAGS) -C -S -l -D'
`'
`.PHONY : disassemble'
`disassemble :'
`	$(OBJDUMP) $(DISASSEMBLE_FLAGS) $(PROJ)'
`'
`.PHONY : disassemble_all'
`disassemble_all :'
`	$(OBJDUMP) $(DISASSEMBLE_ALL_FLAGS) $(PROJ)'
`'
`'
`.PHONY : disassemble_2'
`disassemble_2 :'
`	$(OBJDUMP) $(DISASSEMBLE_2_FLAGS) $(PROJ)'
`'
`.PHONY : disassemble_all_2'
`disassemble_all_2 :'
`	$(OBJDUMP) $(DISASSEMBLE_ALL_2_FLAGS) $(PROJ)'
,
`')dnl
