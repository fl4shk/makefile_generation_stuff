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
	GENERIC = enum.auto()
	CXX = enum.auto()
	C = enum.auto()
	S = enum.auto()
	NS = enum.auto()

class Have(enum.Enum):
	DEBUG = enum.auto()
	DISASSEMBLE = enum.auto()



class MakefileBuilder:
	def __init__(self, filename, src_types, haves, antlr_jsoncpp_status,
		target):

		self.__filename = filename
		self.__src_types = src_types
		self.__haves = haves
		self.__antlr_jsoncpp_status = antlr_jsoncpp_status
		self.__target = target

		#for st in self.__src_types:
		#	if ((st != "CXX") and (st != "C") and (st != "S")
		#		and (st != "NS")):
		#		err(sconcat("source type \"", st, "\" not supported."))

	def build(self):
		pass


#MakefileBuilder("C++/GNUmakefile_cxx.mk", ["CXX"], []).build()
#MakefileBuilder("C++/GNUmakefile_cxx_dis.mk", ["CXX"], ["DIS"]).build()

