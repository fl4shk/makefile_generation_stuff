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
		= {SrcType.Cxx: {"prefix": "CXX", "src_prefix": "CXX",
			"file_ext": ".cpp", "compiler_var": "CXX"},
		SrcType.C: {"prefix": "C", "src_prefix": "C", "file_ext": ".c",
			"compiler_var": "CC"},
		SrcType.S: {"prefix": "S", "src_prefix": "S", "file_ext": ".s",
			"compiler_var": "AS"},
		SrcType.Ns: {"prefix": "NS", "src_prefix": "S",
			"file_ext": ".nasm", "compiler_var": "NS"},
		SrcType.Bin: {"prefix": "BIN", "src_prefix": "BIN",
			"file_ext": ".bin", "compiler_var": "BINCOMP"}}

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
		f.write(self.get_phonies_part_0())
		f.write(self.get_compiles())
		f.write(self.get_phonies_part_1())
		f.write(self.get_stuff_for_make_disassemble())


		f.close()
		pass

	def get_src_dirs(self):
		ret = str()
		ret += "# These directories specify where source code files "
		ret += "are located.\n"
		ret += "# Edit these variables if more directories are needed.  \n"
		ret += "# Separate each entry by spaces.\n"
		ret += "\n\n"

		ret += "SHARED_SRC_DIRS:=src \\\n"

		if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += "\tsrc/gen_src \\\n"
		if (StatusAntlrJsoncpp.Jsoncpp in self.__status_antlr_jsoncpp):
			ret += "\tsrc/liborangepower_src/json_stuff \\\n"

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

		if ((Have.Disassemble in self.__haves)
			or (self.__target == Target.Embedded)):
			ret += "\n"

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
			ret += "\t$(shell pkg-config --libs jsoncpp) \\\n"

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
				self.convert_src_type_to_src_prefix(some_src_type),
				"_DIRS),$(wildcard $(DIR)/*",
				self.get_src_file_extension(some_src_type), "))\n")

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

		def gen_final_list(self, some_var_name, some_suffix,
			only_hlls=False):
			ret = str()

			supported_hlls_set = set(self.get_supported_hlls())

			ret += sconcat(some_var_name, ":=")
			j = 0
			for i in range(len(self.__src_types)):
				src_type = self.__src_types[i]

				if ((only_hlls == False)
					or ((only_hlls == True)
					and (src_type in supported_hlls_set))):

					ret += self.__get_rhs_var(self.__get_var(src_type,
						some_suffix))
					ret += " "

			#ret = ret[0 : len(ret) - 2]
			if (ret[len(ret) - 1] == " "):
				ret = ret[0 : len(ret) - 1]
			ret += "\n"
			return ret

		supported_hlls_set = set(self.get_supported_hlls())

		if (SrcType.Bin in set(self.__src_types)):
			ret += gen_regular_lists(self, SrcType.Bin, supported_hlls_set)
			#ret += "\n"
		else:
			ret += "\n\n"
		#ret += "\n"

		#for src_type in self.__src_types:
		non_bin_src_types = self.get_non_bin_src_types()

		for i in range(len(non_bin_src_types)):
			src_type = non_bin_src_types[i]

			ret += gen_regular_lists(self, src_type, supported_hlls_set)
			#ret += "\n"

			if (((i + 1) == len(non_bin_src_types))
				and ((src_type not in supported_hlls_set)
				or (Have.Disassemble in self.__haves))):
				ret += "\n"

		#ret += "\n"
		#ret += "\n"


		#ret += "\n"
		ret += "# Compiler-generated files\n"
		ret += "# OFILES are object code files (extension .o)\n"
		#ret += "OFILES:=$(CXX_OFILES) $(C_OFILES) $(S_OFILES) $(NS_OFILES)"
		ret += gen_final_list(self, "OFILES", "_OFILES")

		ret += "# PFILES are used for automatic dependency generation\n"
		#PFILES:=$(CXX_PFILES) $(C_PFILES) $(S_PFILES) $(NS_PFILES)
		ret += gen_final_list(self, "PFILES", "_PFILES")

		if (Have.Disassemble in self.__haves):
			ret += gen_final_list(self, "ASMOUTS", "_ASMOUTS", True)
			#ASMOUTS:=$(CXX_ASMOUTS) $(C_ASMOUTS)"

		ret += "\n"

		if (Have.OnlyPreprocess in self.__haves):
			ret += "# Preprocessed output of C++ and/or C files\n"
			#CXX_EFILES := $(CXX_SOURCES:%.cpp=$(PREPROCDIR)/%.E)
			#C_EFILES := $(C_SOURCES:%.c=$(PREPROCDIR)/%.E)

			for hll in self.get_supported_hlls():
				ret += get_filename_conversion_list(self, hll,
					"_EFILES", "PREPROCDIR", ".E")


			ret += gen_final_list(self, "EFILES", "_EFILES", True)
			#EFILES:=$(CXX_EFILES) $(C_EFILES)

			ret += "\n"



		if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += "MODIFED_GENERATED_SOURCES:=\n"
			ret += sconcat("FINAL_GENERATED_SOURCES:=src/gen_src/",
				"$(GRAMMAR_PREFIX)Parser.h\n")
			ret += sconcat("GENERATED_SOURCES:=",
				"$(MODIFED_GENERATED_SOURCES) \\\n")
			ret += "\t$(FINAL_GENERATED_SOURCES)\n"

			ret += "\n"

		return ret

	def get_phonies_part_0(self):
		ret = str()

		if (not StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += "\n"
			ret += ".PHONY : all\n"
			ret += "all : all_pre $(OFILES)\n"
			ret += "\t$(LD) $(OFILES) -o $(PROJ) $(LD_FLAGS)\n"
			ret += "\n"
			ret += "\n"
			ret += "# all_objs is ENTIRELY optional\n"
			ret += ".PHONY : all_objs\n"
			ret += "all_objs : all_pre $(OFILES)\n"
			ret += "\t@#\n"
			ret += "\n"
			ret += "\n"

			if (Have.Disassemble in self.__haves):
				ret += ".PHONY : do_asmouts\n"
				ret += "do_asmouts : all_pre all_pre_asmout $(ASMOUTS)\n"
				ret += "\t@#\n"
			ret += "\n"
			ret += "\n"

			ret += ".PHONY : all_pre\n"
			ret += "all_pre :\n"
			ret += "\tmkdir -p $(OBJDIR) $(DEPDIR)\n"
			ret += "\t@for ofile in $(OFILES); \\\n"
			ret += "\tdo \\\n"
			ret += "\t\tmkdir -p $$(dirname $$ofile); \\\n"
			ret += "\tdone\n"
			ret += "\t@for pfile in $(PFILES); \\\n"
			ret += "\tdo \\\n"
			ret += "\t\tmkdir -p $$(dirname $$pfile); \\\n"
			ret += "\tdone\n"
			ret += "\n"
			ret += "\n"
			ret += "\n"

			if (Have.Disassemble in self.__haves):
				ret += ".PHONY : all_pre_asmout\n"
				ret += "all_pre_asmout :\n"
				ret += "\tmkdir -p $(ASMOUTDIR)\n"
				ret += "\t@for asmout in $(ASMOUTS); \\\n"
				ret += "\tdo \\\n"
				ret += "\t\tmkdir -p $$(dirname $$asmout); \\\n"
				ret += "\tdone\n"
				ret += "\n"
			else:
				ret += "\n"
		else:
			ret += ".PHONY : all\n"
			ret += "all : all_pre $(MODIFED_GENERATED_SOURCES)\n"
			ret += "\t@$(MAKE) final_generated\n"
			ret += "\n"
			ret += ".PHONY : final_generated\n"
			ret += "final_generated : all_pre $(FINAL_GENERATED_SOURCES)\n"
			ret += "\t@$(MAKE) non_generated\n"
			ret += "\n"
			ret += ".PHONY : non_generated\n"
			ret += "non_generated : all_pre $(OFILES)\n"
			ret += "\t$(LD) $(OFILES) -o $(PROJ) $(LD_FLAGS)\n"
			ret += "\n"
			ret += "\n"

			ret += "# all_objs is ENTIRELY optional\n"
			ret += ".PHONY : all_objs\n"
			ret += "all_objs : all_pre $(OFILES)\n"
			ret += "\t@#\n"
			ret += "\n"
			ret += "\n"

			if (Have.Disassemble in self.__haves):
				ret += ".PHONY : do_asmouts\n"
				ret += "do_asmouts : all_pre all_pre_asmout $(ASMOUTS)\n"
				ret += "\t@#\n"
			ret += "\n"
			ret += "\n"


			ret += ".PHONY : all_pre\n"
			ret += "all_pre :\n"
			ret += "\tmkdir -p $(OBJDIR) $(DEPDIR) src/gen_src/\n"
			ret += "\t@for ofile in $(OFILES); \\\n"
			ret += "\tdo \\\n"
			ret += "\t\tmkdir -p $$(dirname $$ofile); \\\n"
			ret += "\tdone\n"
			ret += "\t@for pfile in $(PFILES); \\\n"
			ret += "\tdo \\\n"
			ret += "\t\tmkdir -p $$(dirname $$pfile); \\\n"
			ret += "\tdone\n"

			ret += "\n"
			ret += "\n"
			ret += "\n"

			if (Have.Disassemble in self.__haves):
				ret += ".PHONY : all_pre_asmout\n"
				ret += "all_pre_asmout :\n"
				ret += "\tmkdir -p $(ASMOUTDIR)\n"
				ret += "\t@for asmout in $(ASMOUTS); \\\n"
				ret += "\tdo \\\n"
				ret += "\t\tmkdir -p $$(dirname $$asmout); \\\n"
				ret += "\tdone\n"
				ret += "\n"
			ret += "\n"

			ret += ".PHONY : grammar_stuff\n"
			ret += sconcat("grammar_stuff : src/gen_src/$(GRAMMAR_PREFIX)",
				"Parser.h \\\n")
			ret += "\t@#\n"
			ret += "\n"

		return ret

	def get_compiles(self):
		ret = str()

		if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += sconcat("src/gen_src/$(GRAMMAR_PREFIX)Parser.h",
				" : src/$(GRAMMAR_PREFIX).g4\n")
			ret += "\tif [ ! -d src/gen_src ]; then make all_pre; fi; \\\n"
			ret += sconcat("\tcp src/$(GRAMMAR_PREFIX).g4 src/gen_src ",
				"&& cd src/gen_src \\\n")
			ret += sconcat("\t&& antlr4 -no-listener -visitor ",
				"-Dlanguage=Cpp $(GRAMMAR_PREFIX).g4 \\\n")
			ret += "\t&& rm $(GRAMMAR_PREFIX).g4 \\\n"
			ret += "\t&& find *.cpp -type f -print0 \\\n"
			ret += "\t\t| xargs -0 sed -i 's/\<u8\>\"/\"/g' \\\n"
			ret += "\t&& find *.cpp -type f -print0 \\\n"
			ret += "\t\t| xargs -0 sed -i 's/\[=\]/\[=, this\]/g'\n"
		ret += "\n"


		ret += "# Here's where things get really messy. \n"

		def __any_compile_header(self, some_src_type, dst_var_suffix,
			dst_file_dir, dst_file_ext):
			ret = str()
			# ret += "$(CXX_OFILES) : $(OBJDIR)/%.o : %.cpp\n"
			ofiles_rhs_var = self.__get_rhs_var(self.__get_var
				(some_src_type, dst_var_suffix))
			src_file_extension = self.get_src_file_extension(some_src_type)

			ret += sconcat(ofiles_rhs_var, " : $(", dst_file_dir, ")/%",
				dst_file_ext, " : %", src_file_extension, "\n")
			return ret

		def __hll_compile_middle(self, some_src_type):
			ret = str()
			compiler_rhs_var = self.__get_rhs_var(self
				.convert_src_type_to_compiler_var(some_src_type))
			flags_rhs_var = self.__get_rhs_var(self.__get_var
				(some_src_type, "_FLAGS"))

			ret += sconcat("\t@echo $@\" was updated or has no object ",
				"file.  (Re)Compiling....\"\n")
			# ret += "\t$(CXX) $(CXX_FLAGS) -MMD -c $< -o $@\n"
			ret += sconcat("\t", compiler_rhs_var, " ", flags_rhs_var, " ",
				"-MMD -c $< -o $@\n")
			return ret

		def __asm_compile_middle(self, some_src_type):
			ret = str()
			compiler_rhs_var = self.__get_rhs_var(self
				.convert_src_type_to_compiler_var(some_src_type))
			flags_rhs_var = self.__get_rhs_var(self.__get_var
				(some_src_type, "_FLAGS"))

			ret += sconcat("\t@echo $@\" was updated or has no object ",
				"file.  (Re)Assembling....\"\n")
			# ret += "\t$(AS) $(S_FLAGS) -MD $(OBJDIR)/$*.d -c $< -o $@\n"
			ret += sconcat("\t", compiler_rhs_var, " ", flags_rhs_var, " ",
				"-MD $(OBJDIR)/$*.d -c $< -o $@\n")
			return ret

		def __do_asmout_hll_compile_middle(self, some_src_type):
			ret = str()
			compiler_rhs_var = self.__get_rhs_var(self
				.convert_src_type_to_compiler_var(some_src_type))
			flags_rhs_var = self.__get_rhs_var(self.__get_var
				(some_src_type, "_FLAGS"))

			#ret += sconcat("\t@echo $@\" was updated or has no object ",
			#	"file.  (Re)Compiling....\"\n")
			#ret += "\t$(CXX) $(CXX_FLAGS) -MMD -S $(VERBOSE_ASM_FLAG) $< -o $@\n"
			ret += sconcat("\t", compiler_rhs_var, " ", flags_rhs_var, " ",
				"-MMD -S $(VERBOSE_ASM_FLAG) $< -o $@\n")
			return ret

			#	$(CC) $(C_FLAGS) -MMD -E $< -o $@
		def __only_preprocess_hll_compile_middle(self, some_src_type):
			ret = str()
			compiler_rhs_var = self.__get_rhs_var(self
				.convert_src_type_to_compiler_var(some_src_type))
			flags_rhs_var = self.__get_rhs_var(self.__get_var
				(some_src_type, "_FLAGS"))

			#ret += "\t$(CXX) $(CXX_FLAGS) -MMD -E $< -o $@\n"
			ret += sconcat("\t", compiler_rhs_var, " ", flags_rhs_var, " ",
				"-MMD -E $< -o $@\n")
			return ret

		def __any_compile_end(dst_file_dir):
			ret = str()
			ret += sconcat("\t@cp $(", dst_file_dir, ")/$*.d ",
				"$(DEPDIR)/$*.P\n")
			ret += sconcat("\t@rm -f $(", dst_file_dir, ")/$*.d\n")
			return ret

		def __gen_regular_hll_compile(self, some_src_type):
			ret = str()
			ret += __any_compile_header(self, some_src_type, "_OFILES",
				"OBJDIR", ".o")
			ret += __hll_compile_middle(self, some_src_type)
			ret += __any_compile_end("OBJDIR")
			return ret

		def __gen_regular_asm_compile(self, some_src_type):
			ret = str()
			ret += __any_compile_header(self, some_src_type, "_OFILES",
				"OBJDIR", ".o")
			ret += __asm_compile_middle(self, some_src_type)
			ret += __any_compile_end("OBJDIR")
			return ret

		def __gen_do_asmout_hll_compile(self, some_src_type):
			ret = str()
			ret += __any_compile_header(self, some_src_type, "_ASMOUTS",
				"ASMOUTDIR", ".s")
			ret += __do_asmout_hll_compile_middle(self, some_src_type)
			ret += __any_compile_end("ASMOUTDIR")
			return ret

		def __gen_only_preprocess_hll_compile(self, some_src_type):
			ret = str()

			ret += __any_compile_header(self, src_type, "_EFILES",
				"PREPROCDIR", ".E")
			ret += __only_preprocess_hll_compile_middle(self,
				some_src_type)
			ret += __any_compile_end("PREPROCDIR")
			return ret

		#non_bin_src_types = self.get_non_bin_src_types()
		supported_hlls_set = set(self.get_supported_hlls())
		#for src_type in non_bin_src_types:
		#	if (src_type in supported_hlls_set):
		#		ret += __gen_regular_hll_compile(self, src_type)
		#	else:
		#		if (src_type == SrcType.S):
		#			ret += __gen_regular_asm_compile(self, src_type)

		for src_type in self.__src_types:
			if (src_type in supported_hlls_set):
				ret += __gen_regular_hll_compile(self, src_type)
				ret += "\n"

		if (len(supported_hlls_set) != 0):
			ret += "\n"

		if (SrcType.S in set(self.__src_types)):
			ret += __gen_regular_asm_compile(self, SrcType.S)
			ret += "\n"
			ret += "\n"

		if (Have.Disassemble in self.__haves):
			if (SrcType.S not in set(self.__src_types)):
				ret += "\n"
			ret += sconcat("# Here we have stuff for outputting assembly",
				" source code instead of an object file.\n")
			for src_type in self.__src_types:
				if (src_type in supported_hlls_set):
					ret += __gen_do_asmout_hll_compile(self, src_type)
					ret += "\n"
		#else:
		#	ret += "\n"

		ret += "\n"
		ret += "\n"

		ret += "-include $(PFILES)\n"
		ret += "\n"
		ret += "#¯\(°_o)/¯\n"
		ret += "\n"

		if (Have.OnlyPreprocess in self.__haves):
			
			ret += ".PHONY : only_preprocess\n"
			ret += "only_preprocess : only_preprocess_pre $(EFILES)\n"
			ret += "\n"
			ret += ".PHONY : only_preprocess_pre\n"
			ret += "only_preprocess_pre :\n"
			ret += "\tmkdir -p $(DEPDIR) $(PREPROCDIR)\n"
			ret += "\t@for efile in $(EFILES); \\\n"
			ret += "\tdo \\\n"
			ret += "\t\tmkdir -p $$(dirname $$efile); \\\n"
			ret += "\tdone\n"
			ret += "\t@for pfile in $(PFILES); \\\n"
			ret += "\tdo \\\n"
			ret += "\t\tmkdir -p $$(dirname $$pfile); \\\n"
			ret += "\tdone\n"

			ret += "\n"
			ret += "\n"


			#$(CXX_EFILES) : $(PREPROCDIR)/%.E : %.cpp
			#	$(CXX) $(CXX_FLAGS) -MMD -E $< -o $@
			#	@cp $(PREPROCDIR)/$*.d $(DEPDIR)/$*.P
			#	@rm -f $(PREPROCDIR)/$*.d


			#$(C_EFILES) : $(PREPROCDIR)/%.E : %.c
			#	$(CC) $(C_FLAGS) -MMD -E $< -o $@
			#	@cp $(PREPROCDIR)/$*.d $(DEPDIR)/$*.P
			#	@rm -f $(PREPROCDIR)/$*.d

			for src_type in self.__src_types:
				if (src_type in supported_hlls_set):
					ret += __gen_only_preprocess_hll_compile(self,
						src_type)
					ret += "\n"


			ret += "\n"
		ret += "\n"


		return ret

	def get_phonies_part_1(self):
		ret = str()


		ret += ".PHONY : clean\n"
		ret += "clean :\n"
		ret += sconcat("\trm -rfv $(OBJDIR) $(DEPDIR) $(ASMOUTDIR) ",
			"$(PREPROCDIR) $(PROJ) tags *.taghl gmon.out")
		if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
			ret += " $(GENERATED_SOURCES) src/gen_src"
		ret += "\n"
		ret += "\n"
		ret += "\n"

		return ret

	def get_stuff_for_make_disassemble(self):
		ret = str()

		if (Have.Disassemble in self.__haves):
			ret += "# Flags for make disassemble*\n"
			ret += "DISASSEMBLE_FLAGS:=$(DISASSEMBLE_BASE_FLAGS) -C -d\n"
			ret += sconcat("DISASSEMBLE_ALL_FLAGS:=",
				"$(DISASSEMBLE_BASE_FLAGS) -C -D\n")
			ret += "\n"
			ret += sconcat("DISASSEMBLE_2_FLAGS:=",
				"$(DISASSEMBLE_BASE_FLAGS) -C -S -l -d\n")
			ret += sconcat("DISASSEMBLE_ALL_2_FLAGS:=",
				"$(DISASSEMBLE_BASE_FLAGS) -C -S -l -D\n")
			ret += "\n"
			ret += ".PHONY : disassemble\n"
			ret += "disassemble :\n"
			ret += "\t$(OBJDUMP) $(DISASSEMBLE_FLAGS) $(PROJ)\n"
			ret += "\n"
			ret += ".PHONY : disassemble_all\n"
			ret += "disassemble_all :\n"
			ret += "\t$(OBJDUMP) $(DISASSEMBLE_ALL_FLAGS) $(PROJ)\n"
			ret += "\n"
			ret += "\n"
			ret += ".PHONY : disassemble_2\n"
			ret += "disassemble_2 :\n"
			ret += "\t$(OBJDUMP) $(DISASSEMBLE_2_FLAGS) $(PROJ)\n"
			ret += "\n"
			ret += ".PHONY : disassemble_all_2\n"
			ret += "disassemble_all_2 :\n"
			ret += "\t$(OBJDUMP) $(DISASSEMBLE_ALL_2_FLAGS) $(PROJ)\n"

		return ret

	def convert_src_type_to_prefix(self, some_src_type):
		return self.__src_type_properties[some_src_type]["prefix"]
	def convert_src_type_to_src_prefix(self, some_src_type):
		return self.__src_type_properties[some_src_type]["src_prefix"]
	def get_src_file_extension(self, some_src_type):
		return self.__src_type_properties[some_src_type]["file_ext"]
	def convert_src_type_to_compiler_var(self, some_src_type):
		return self.__src_type_properties[some_src_type]["compiler_var"]

	def __inner_get_initial_stuff(self, some_src_type):
		ret = str()

		#flags_prefix = self.convert_src_type_to_prefix(some_src_type)
		flags_var = self.__get_var(some_src_type, "_FLAGS")
		flags_rhs_var = self.__get_rhs_var(flags_var)
		compiler_var = self.convert_src_type_to_compiler_var(some_src_type)

		if (some_src_type == SrcType.Cxx):
			ret += sconcat(compiler_var, ":=$(PREFIX)g++\n")
			ret += flags_var + ":=" + flags_rhs_var \
				+ " -std=c++20 -fmodules-ts -Wall"
			if (StatusAntlrJsoncpp.Antlr in self.__status_antlr_jsoncpp):
				ret += " -I/usr/include/antlr4-runtime/"
			if (StatusAntlrJsoncpp.Jsoncpp in self.__status_antlr_jsoncpp):
				ret += " \\\n"
				ret += "\t$(shell pkg-config --cflags jsoncpp)\n"
			else:
				ret += "\n"
				ret += "\n"

			#ret += "\n"
		elif (some_src_type == SrcType.C):
			ret += sconcat(compiler_var, ":=$(PREFIX)gcc\n")
			ret += flags_var + ":=" + flags_rhs_var \
				+ " -std=c11 -Wall\n"
			ret += "\n"
		elif (some_src_type == SrcType.S):
			ret += sconcat(compiler_var, ":=$(PREFIX)as\n")

			if (self.__target == Target.Host):
				ret += "S_FLAGS:=$(S_FLAGS) -mnaked-reg #-msyntax=intel\n"
		elif (some_src_type == SrcType.Ns):
			ret += sconcat(compiler_var, ":=nasm\n")
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

	def get_non_bin_src_types(self):
		non_bin_src_types = []
		for src_type in self.__src_types:
			if (src_type != SrcType.Bin):
				non_bin_src_types += [src_type]
		return non_bin_src_types

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
		{Have.Disassemble, Have.OnlyPreprocess}, Target.Host,
		EmbeddedType.Any, {StatusAntlrJsoncpp.Antlr}),

	MakefileBuilder("C++/GNUmakefile_jsoncpp.mk", [SrcType.Cxx],
		{Have.Disassemble, Have.OnlyPreprocess}, Target.Host,
		EmbeddedType.Any, {StatusAntlrJsoncpp.Jsoncpp}),

	MakefileBuilder("C++/GNUmakefile_antlr_jsoncpp.mk", [SrcType.Cxx],
		{Have.Disassemble, Have.OnlyPreprocess}, Target.Host,
		EmbeddedType.Any, {StatusAntlrJsoncpp.Antlr,
		StatusAntlrJsoncpp.Jsoncpp}),

	MakefileBuilder("C++/GNUmakefile_cxx.mk", [SrcType.Cxx]),

	MakefileBuilder("C++/GNUmakefile_cxx_dis.mk", [SrcType.Cxx],
		{Have.Disassemble}),

	MakefileBuilder("C++/GNUmakefile_cxx_do_arm_full.mk", [SrcType.Cxx,
		SrcType.S, SrcType.Bin], {Have.Disassemble, Have.OnlyPreprocess},
		Target.Embedded, EmbeddedType.Arm),
]

for builder in builders:
	builder.build()

