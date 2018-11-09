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
	Debug = enum.auto()
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
	def __init__(self, filename, src_types, haves={Have.Debug},
		target=Target.Host,
		status_antlr_jsoncpp={}):

		self.__filename = filename

		if (src_types == {SrcType.Generic}):
			self.__src_types = {SrcType.Cxx, SrcType.C, SrcType.S,
				SrcType.Ns}
			self.__haves = {Have.Debug, Have.Disassemble,
				Have.OnlyPreprocess}
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
		pass

builders \
= [ \
	MakefileBuilder("generic/GNUmakefile_generic.mk", {SrcType.Generic}),
	MakefileBuilder("generic/GNUmakefile_antlr.mk", {SrcType.Cxx},
		{Have.Debug, Have.Disassemble}, Target.Host,
		{StatusAntlrJsoncpp.Antlr}),
	MakefileBuilder("generic/GNUmakefile_jsoncpp.mk", {SrcType.Cxx},
		{Have.Debug, Have.Disassemble}, Target.Host,
		StatusAntlrJsoncpp.Jsoncpp),
	MakefileBuilder("generic/GNUmakefile_antlr_jsoncpp.mk", {SrcType.Cxx},
		{Have.Debug, Have.Disassemble}, Target.Host,
		{StatusAntlrJsoncpp.Antlr, StatusAntlrJsoncpp.Jsoncpp}),

	MakefileBuilder("C++/GNUmakefile_cxx.mk", {SrcType.Cxx}, {Have.Debug}),
	MakefileBuilder("C++/GNUmakefile_cxx_dis.mk", {SrcType.Cxx},
		{Have.Debug, Have.Disassemble}),
]

for builder in builders:
	builder.build()

