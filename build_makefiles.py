#! /usr/bin/env python3

import os, sys, enum

def printerr(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)

def err(msg):
	printerr("Error:  ", msg)
	exit(1)

def sconcat(*args):
	ret = ""
	for arg in args:
		ret += str(arg)
	return ret

class SrcType(enum.Enum):
	Generic = enum.auto()
	Cxx = enum.auto()
	C = enum.auto()
	S = enum.auto()
	Ns = enum.auto()
	Bin = enum.auto()

class Have(enum.Enum):
	Disassemble = enum.auto()
	OnlyPreprocess = enum.auto()

class StatusAntlrJsoncpp(enum.Enum):
	Antlr = enum.auto()
	Jsoncpp = enum.auto()

class Target(enum.Enum):
	Host = enum.auto()
	Embedded = enum.auto()

class EmbeddedType(enum.Enum):
	Any = enum.auto()
	Arm = enum.auto()
	Gba = enum.auto()


class MakefileBuilder:
	__src_type_properties \
		= {SrcType.Cxx: {"prefix": "CXX", "file_ext": ".cpp"},
		SrcType.C: {"prefix": "C", "file_ext": ".c"},
		SrcType.S: {"prefix": "S", "file_ext": ".s"},
		SrcType.Ns: {"prefix": "NS", "file_ext": ".nasm"},
		SrcType.Bin: {"prefix": "BIN", "file_ext": ".bin"}}

	def __init__(self, filename, src_types, haves=set(),
		target=Target.Host, embedded_type=EmbeddedType.Any,
		status_antlr_jsoncpp=set()):

		self.__filename = filename

		if (src_types[0] == SrcType.Generic):
			self.__src_types = [SrcType.Cxx, SrcType.C, SrcType.S,
				SrcType.Ns]
			#self.__src_types = [SrcType.Cxx, SrcType.C, SrcType.S,
			#	SrcType.Ns, SrcType.Bin]
			self.__haves = {Have.Disassemble, Have.OnlyPreprocess}
			self.__target = Target.Host
		else:
			self.__src_types = src_types
			self.__haves = haves
			self.__target = target

		self.__embedded_type = embedded_type
		self.__status_antlr_jsoncpp = status_antlr_jsoncpp




	def build(self):
		some_dirname = os.path.dirname(self.__filename)
		if (not os.path.exists(some_dirname)):
			os.makedirs(some_dirname)

		f = open(self.__filename, "w+")

		f.write(self.get_src_dirs())
		f.write(self.get_debug_stuff_part_0())
		f.write(self.get_proj())
		f.write(self.get_have_disassemble_stuff_part_0())
		f.write(self.get_compilers_and_initial_compiler_flags())
		f.write(self.get_debug_stuff_part_1())
		f.write(self.get_embedded_extras())
		f.write(self.get_final_flags())
		f.write(self.get_generated_dirs_and_lists())


		f.close()
		pass

	def get_src_dirs(self):
		ret = str()
		ret += "# These directories specify where source code files "
		ret += "are located.\n"
		ret += "# Edit these variables if more directories are needed.\n"
		ret += "# Separate each entry by spaces\n"
		ret += "\n\n"

		ret += "SHARED_SRC_DIRS:=src \\\n"

		if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += "\tsrc/gen_src \\\n"
		if (StatusAntlrJsoncpp.Jsoncpp in self.__status_antlr_jsoncpp):
			ret += "\tsrc/liborangepower_src \\\n"

		#if (len(self.__status_antlr_jsoncpp) == 0):
		#	ret += "\n"

		ret += "\n"

		for src_type in self.__src_types:
			ret += self.convert_src_type_to_prefix(src_type)
			ret += "_DIRS:=$(SHARED_SRC_DIRS)\n"

		ret += "# End of source directories\n\n\n"

		return ret

	def get_debug_stuff_part_0(self):
		ret = str()
		ret += "# Whether or not to do debugging stuff\n"
		ret += "#DEBUG:=yeah do debug\n"
		ret += "\n"
		ret += "DEBUG_OPTIMIZATION_LEVEL:=-O0\n"
		ret += "REGULAR_OPTIMIZATION_LEVEL:=-O2\n"
		ret += "\n"
		if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += "GRAMMAR_PREFIX:=Grammar\n"
		ret += "\n"
		ret += "ALWAYS_DEBUG_SUFFIX:=_debug\n"
		ret += "ifdef DEBUG\n"
		ret += "	DEBUG_SUFFIX:=$(ALWAYS_DEBUG_SUFFIX)\n"
		ret += "endif\n"
		ret += "\n"
		return ret

	def get_debug_stuff_part_1(self):
		ret = str()
		ret += "ifdef DEBUG\n"
		ret += "\tEXTRA_DEBUG_FLAGS:=-g\n"
		ret += "\tDEBUG_FLAGS:=-gdwarf-3 $(EXTRA_DEBUG_FLAGS)\n"
		ret += "\tEXTRA_LD_FLAGS:=$(DEBUG_FLAGS)\n"
		ret += "\tOPTIMIZATION_LEVEL:=$(DEBUG_OPTIMIZATION_LEVEL)\n"
		ret += "else\n"
		ret += "\tOPTIMIZATION_LEVEL:=$(REGULAR_OPTIMIZATION_LEVEL)\n"
		ret += "endif\n"
		ret += "\n"
		ret += "\n"
		return ret

	def get_embedded_extras(self):
		ret = str()

		if (self.__target == Target.Embedded):
			ret += "LD_SCRIPT:=linkscript.ld\n"
			ret += "COMMON_LD_FLAGS:=$(COMMON_LD_FLAGS) -T $(LD_SCRIPT)\n"

			if (self.__embedded_type_is_any_arm()):
				ret += "\n"
				ret += "\n"

				ret += "EXTRA_BASE_FLAGS:=-mcpu=arm7tdmi " \
					+ "-mtune=arm7tdmi -mthumb \\\n"
				ret += "\t-mthumb-interwork \\\n"
				ret += "\t-fno-threadsafe-statics -nostartfiles\n"

				ret += "\n"

				ret += "EXTRA_LD_FLAGS:=$(EXTRA_LD_FLAGS) -mthumb " \
					+ "--specs=nosys.specs \\\n"
				ret += "\t-lm -lgcc -lc -lstdc++\n"

				if (Have.Disassemble in self.__haves):
					ret += "DISASSEMBLE_BASE_FLAGS:=-marm7tdmi\n"

		ret += "\n"
		ret += "\n"


		return ret


	def get_proj(self):
		ret = str()

		ret += "# This is the name of the output file.  " \
			+ "Change this if needed!\n"
		ret += "PROJ:=$(shell basename $(CURDIR))$(DEBUG_SUFFIX)\n"
		ret += "\n"
		return ret

	def get_have_disassemble_stuff_part_0(self):
		ret = str()

		if (Have.Disassemble in self.__haves):
			ret += "# This is used for do_asmouts\n"
			ret += "#VERBOSE_ASM_FLAG:=-fverbose-asm\n"
		if (self.__target == Target.Embedded):
			if (self.__embedded_type == EmbeddedType.Arm):
				ret += "PREFIX:=arm-none-eabi-\n"
			elif (self.__embedded_type == EmbeddedType.Gba):
				ret += "PREFIX:=$(DEVKITARM)/bin/arm-none-eabi-\n"

		ret += "\n"

		return ret

	def get_compilers_and_initial_compiler_flags(self):
		ret = str()

		ret += "# Compilers and initial compiler flags\n"

		for src_type in self.__src_types:
			ret += self.__inner_get_initial_stuff(src_type)
		#ret += "\n"

		if ((SrcType.S in set(self.__src_types))
			or (SrcType.Ns in set(self.__src_types))):
			ret += "\n"

		if (Have.Disassemble in self.__haves):
			ret += "OBJDUMP:=$(PREFIX)objdump\n"

		if (self.__target == Target.Embedded):
			ret += "OBJCOPY:=$(PREFIX)objcopy\n"

		ret += "\n"

		#ret += "\n"


		# is $(LD) $(CXX) or $(CC)?
		if (SrcType.Cxx in set(self.__src_types)):
			ret += "LD:=$(CXX)\n"
		else:
			ret += "LD:=$(CC)\n"
		ret += "\n"

		ret += "# Initial linker flags\n"
		ret += "LD_FLAGS:=$(LD_FLAGS) -lm"

		if (len(self.__status_antlr_jsoncpp) != 0):
			ret += " \\"
		ret += "\n"

		if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += "\t-lantlr4-runtime \\\n"
		if (StatusAntlrJsoncpp.Jsoncpp in self.__status_antlr_jsoncpp):
			ret += "\t-ljsoncpp \\\n"

		ret += "\n"
		ret += "\n"
		ret += "\n"

		return ret

	def get_final_flags(self):
		ret = str()
		ret += "FINAL_BASE_FLAGS:=$(OPTIMIZATION_LEVEL) \\\n"
		ret += "\t$(EXTRA_BASE_FLAGS) $(EXTRA_DEBUG_FLAGS)\n"
		ret += "\n"

		ret += "# Final compiler and linker flags\n"

		for hll in self.get_supported_hlls():
			flags_var = self.__get_var(hll, "_FLAGS")
			flags_rhs_var = self.__get_rhs_var(flags_var)
			ret += flags_var + ":=" + flags_rhs_var \
				+ " $(FINAL_BASE_FLAGS)\n"

		ret += "LD_FLAGS:=$(LD_FLAGS) $(EXTRA_LD_FLAGS) " \
			+ "$(COMMON_LD_FLAGS)\n"
		ret += "\n"
		ret += "\n"
		ret += "\n"
		ret += "\n"
		return ret

	def get_generated_dirs_and_lists(self):
		
		ret = str()
		ret += "# Generated directories\n"
		ret += "OBJDIR:=objs$(DEBUG_SUFFIX)\n"

		if (Have.Disassemble in self.__haves):
			ret += "ASMOUTDIR:=asmouts$(DEBUG_SUFFIX)\n"

		ret += "DEPDIR:=deps$(DEBUG_SUFFIX)\n"

		if (Have.OnlyPreprocess in self.__haves):
			ret += "PREPROCDIR:=preprocs$(DEBUG_SUFFIX)\n"

		ret += "\n"
		ret += "\n"

		def get_filename_conversion_list(self, some_src_type,
			dst_var_suffix, dst_file_dir, dst_file_ext):
			ret = str()

			sources_var = self.__get_var(some_src_type, "_SOURCES")
			dst_var = self.__get_var(some_src_type, dst_var_suffix)

			ret += sconcat(dst_var, " := $(", sources_var, ":%",
				self.get_src_file_extension(some_src_type),
				"=$(", dst_file_dir, ")/%", dst_file_ext, ")\n")

			return ret

		def gen_regular_lists(self, some_src_type, supported_hlls_set):
			ret = str()

			sources_var = self.__get_var(some_src_type, "_SOURCES")
			ret += sconcat(sources_var, " := $(foreach DIR,$(",
				self.__get_var(some_src_type, "_DIRS"), "),$(wildcard ",
				"$(DIR)/*", self.get_src_file_extension(some_src_type),
				"))\n")

			ret += get_filename_conversion_list(self, some_src_type,
				"_OFILES", "OBJDIR", ".o")
			ret += get_filename_conversion_list(self, some_src_type,
				"_PFILES", "DEPDIR", ".P")

			if ((Have.Disassemble in self.__haves)
				and (some_src_type in supported_hlls_set)):
				ret += "\n"
				ret += "# Assembly source code generated by gcc/g++\n"
				ret += get_filename_conversion_list(self, some_src_type,
					"_ASMOUTS", "ASMOUTDIR", ".s")

			if (some_src_type in supported_hlls_set):
				ret += "\n"
				ret += "\n"


			return ret

		supported_hlls_set = set(self.get_supported_hlls())

		if (SrcType.Bin in set(self.__src_types)):
			ret += gen_regular_lists(self, SrcType.Bin, supported_hlls_set)
		else:
			ret += "\n"
		ret += "\n"

		for src_type in self.__src_types:
			if (src_type != SrcType.Bin):
				ret += gen_regular_lists(self, src_type,
					supported_hlls_set)

		#ret += "\n"

		return ret

	def convert_src_type_to_prefix(self, some_src_type):
		return self.__src_type_properties[some_src_type]["prefix"]
	def get_src_file_extension(self, some_src_type):
		return self.__src_type_properties[some_src_type]["file_ext"]

	def __inner_get_initial_stuff(self, some_src_type):
		ret = str()

		#flags_prefix = self.convert_src_type_to_prefix(some_src_type)
		flags_var = self.__get_var(some_src_type, "_FLAGS")
		flags_rhs_var = self.__get_rhs_var(flags_var)

		if (some_src_type == SrcType.Cxx):
			ret += "CXX:=$(PREFIX)g++\n"
			ret += flags_var + ":=" + flags_rhs_var \
				+ " -std=c++17 -Wall"
			if (StatusAntlrJsoncpp.Jsoncpp in self.__status_antlr_jsoncpp):
				ret += " \\\n"
				ret += "\t$(shell pkg-config --cflags jsoncpp)\n"
			else:
				ret += "\n"
				ret += "\n"

			#ret += "\n"
		elif (some_src_type == SrcType.C):
			ret += "CC:=$(PREFIX)gcc\n"
			ret += flags_var + ":=" + flags_rhs_var \
				+ " -std=c11 -Wall\n"
			ret += "\n"
		elif (some_src_type == SrcType.S):
			ret += "AS:=$(PREFIX)as\n"

			if (self.__target == Target.Host):
				ret += "S_FLAGS:=$(S_FLAGS) -mnaked-reg #-msyntax=intel\n"
		elif (some_src_type == SrcType.Ns):
			ret += "NS:=nasm\n"
			ret += "NS_FLAGS:=$(NS_FLAGS) -f elf64\n"

		return ret

	def get_supported_hlls(self):
		ret = []

		for hll in self.__src_types:
			if (hll == SrcType.Cxx):
				ret += [hll]
			elif (hll == SrcType.C):
				ret += [hll]

		return ret

	def get_supported_non_hlls(self):
		ret = []

		supported_hlls_set = set(self.get_supported_hlls())
		for non_hll in self.__src_types:
			if (non_hll not in supported_hlls_set):
				ret += [non_hll]

		return ret

	def have_cxx(self):
		return (SrcType.Cxx in set(self.__src_types))
	def __get_var(self, some_src_type, suffix):
		return sconcat(self.convert_src_type_to_prefix(some_src_type),
			suffix)
	def __get_rhs_var(self, some_var_name):
		return sconcat("$(", some_var_name, ")")



	def __embedded_type_is_any_arm(self):
		return ((self.__embedded_type == EmbeddedType.Arm)
			or (self.__embedded_type == EmbeddedType.Gba))




builders \
= [ \
	MakefileBuilder("generic/GNUmakefile_generic.mk", [SrcType.Generic]),
	MakefileBuilder("C++/GNUmakefile_antlr.mk", [SrcType.Cxx],
		set(), Target.Host, EmbeddedType.Any,
		{StatusAntlrJsoncpp.Antlr}),
	MakefileBuilder("C++/GNUmakefile_jsoncpp.mk", [SrcType.Cxx],
		set(), Target.Host, EmbeddedType.Any,
		{StatusAntlrJsoncpp.Jsoncpp}),
	MakefileBuilder("C++/GNUmakefile_antlr_jsoncpp.mk", [SrcType.Cxx],
		set(), Target.Host, EmbeddedType.Any,
		{StatusAntlrJsoncpp.Antlr, StatusAntlrJsoncpp.Jsoncpp}),

	MakefileBuilder("C++/GNUmakefile_cxx.mk", [SrcType.Cxx]),
	MakefileBuilder("C++/GNUmakefile_cxx_dis.mk", [SrcType.Cxx],
		{Have.Disassemble}),
	MakefileBuilder("C++/GNUmakefile_cxx_do_arm_full.mk", [SrcType.Cxx,
		SrcType.S, SrcType.Bin], {Have.Disassemble, Have.OnlyPreprocess},
		Target.Embedded, EmbeddedType.Arm),
]

for builder in builders:
	builder.build()

