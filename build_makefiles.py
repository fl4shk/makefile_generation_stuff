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

		f.write(self.__get_src_dirs())


		f.close()
		pass

	def __get_src_dirs(self):
		ret = "# These directories specify where source code files "
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
			ret += self.__convert_src_type_to_prefix(src_type)
			ret += "_DIRS:=$(SHARED_SRC_DIRS)\n"

		ret += "# End of source directories\n\n\n"

		return ret

	def __convert_src_type_to_prefix(self, some_src_type):
		if (some_src_type == SrcType.Cxx):
			return "CXX"
		elif (some_src_type == SrcType.C):
			return "C"
		elif (some_src_type == SrcType.S):
			return "S"
		else:
			return "NS"


builders \
= [ \
	MakefileBuilder("generic/GNUmakefile_generic.mk", [SrcType.Generic]),
	MakefileBuilder("C++/GNUmakefile_antlr.mk", [SrcType.Cxx],
		{Have.Disassemble}, Target.Host,
		{StatusAntlrJsoncpp.Antlr}),
	MakefileBuilder("C++/GNUmakefile_jsoncpp.mk", [SrcType.Cxx],
		{Have.Disassemble}, Target.Host,
		{StatusAntlrJsoncpp.Jsoncpp}),
	MakefileBuilder("C++/GNUmakefile_antlr_jsoncpp.mk", [SrcType.Cxx],
		{Have.Disassemble}, Target.Host,
		{StatusAntlrJsoncpp.Antlr, StatusAntlrJsoncpp.Jsoncpp}),

	MakefileBuilder("C++/GNUmakefile_cxx.mk", [SrcType.Cxx]),
	MakefileBuilder("C++/GNUmakefile_cxx_dis.mk", [SrcType.Cxx],
		{Have.Disassemble}),
]

for builder in builders:
	builder.build()

