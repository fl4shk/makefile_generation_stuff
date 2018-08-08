# These directories specify where source code files are located.
# Edit these variables if more directories are needed.  
# Separate each entry by spaces.


SHARED_SRC_DIRS:=src

D_DIRS:=$(SHARED_SRC_DIRS)
S_DIRS:=$(SHARED_SRC_DIRS)
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


# Compilers and initial compiler flags
DC:=ldc2
