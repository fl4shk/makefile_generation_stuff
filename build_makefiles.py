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

class Have(enum.Enum):
	Disassemble = enum.auto()
	OnlyPreprocess = enum.auto()

class StatusAntlrJsoncpp(enum.Enum):
	Antlr = enum.auto()
	Jsoncpp = enum.auto()

class Target(enum.Enum):
	Host = enum.auto()
	Arm = enum.auto()
	Gba = enum.auto()


class MakefileBuilder:
	def __init__(self, filename, src_types, haves=set(),
		target=Target.Host, status_antlr_jsoncpp=set()):

		self.__filename = filename

		if (src_types[0] == SrcType.Generic):
			self.__src_types = [SrcType.Cxx, SrcType.C, SrcType.S,
				SrcType.Ns]
			self.__haves = {Have.Disassemble, Have.OnlyPreprocess}
			self.__target = Target.Host
		else:
			self.__src_types = src_types
			self.__haves = haves
			self.__target = target

		self.__status_antlr_jsoncpp = status_antlr_jsoncpp

		#for st in self.__src_types:
		#	if ((st != "CXX") and (st != "C") and (st != "S")
		#		and (st != "NS")):
		#		err(sconcat("source type \"", st, "\" not supported."))

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
			ret += "OBJDUMP:=$(PREFIX)objdump\n\n"


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

	def convert_src_type_to_prefix(self, some_src_type):
		if (some_src_type == SrcType.Cxx):
			return "CXX"
		elif (some_src_type == SrcType.C):
			return "C"
		elif (some_src_type == SrcType.S):
			return "S"
		else:
			return "NS"
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
		elif (some_src_type == SrcType.C):
			ret += "CC:=$(PREFIX)gcc\n"
			ret += flags_var + ":=" + flags_rhs_var \
				+ " -std=c11 -Wall\n"
			ret += "\n"
		elif (some_src_type == SrcType.S):
			ret += "AS:=$(PREFIX)as\n"
			ret += "S_FLAGS:=$(S_FLAGS) -mnaked-reg #-msyntax=intel\n"
		else:
			ret += "NS:=nasm\n"
			ret += "NS_FLAGS:=$(NS_FLAGS) -f elf64\n"

		return ret

	def have_cxx(self):
		return (SrcType.Cxx in set(self.__src_types))
	def __get_var(self, some_src_type, suffix):
		return sconcat(self.convert_src_type_to_prefix(some_src_type),
			suffix)
	def __get_rhs_var(self, some_var_name):
		return sconcat("$(", some_var_name, ")")


builders \
= [ \
	MakefileBuilder("generic/GNUmakefile_generic.mk", [SrcType.Generic]),
	MakefileBuilder("C++/GNUmakefile_antlr.mk", [SrcType.Cxx],
		set(), Target.Host,
		{StatusAntlrJsoncpp.Antlr}),
	MakefileBuilder("C++/GNUmakefile_jsoncpp.mk", [SrcType.Cxx],
		set(), Target.Host,
		{StatusAntlrJsoncpp.Jsoncpp}),
	MakefileBuilder("C++/GNUmakefile_antlr_jsoncpp.mk", [SrcType.Cxx],
		set(), Target.Host,
		{StatusAntlrJsoncpp.Antlr, StatusAntlrJsoncpp.Jsoncpp}),

	MakefileBuilder("C++/GNUmakefile_cxx.mk", [SrcType.Cxx]),
	MakefileBuilder("C++/GNUmakefile_cxx_dis.mk", [SrcType.Cxx],
		{Have.Disassemble}),
]

for builder in builders:
	builder.build()

