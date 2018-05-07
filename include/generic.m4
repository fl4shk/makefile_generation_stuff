ifelse(ifdef(`ANTLR', 1, 0), 1, `define(`GENERIC')',ifdef(`JSONCPP', 1, 0), 1, `define(`GENERIC')')dnl
dnl
dnl
ifdef(`GENERIC',`define(`DO_CXX')'`define(`DO_C')'`define(`DO_S')'dnl
`define(`DO_NS')'`define(`HAVE_DISASSEMBLE')'`define(`HAVE_ONLY_PREPROCESS')'`define(`HAVE_DEBUG')')dnl
dnl
dnl
ifdef(`DO_GBA',`define(`DO_CXX')'`define(`DO_ARM')'`define(`DO_EMBEDDED')')dnl
dnl
dnl
ifdef(`DO_ARM', `define(`DO_NON_X86')')dnl
dnl
dnl
ifdef(`DO_EMBEDDED', `define(`INITIAL_EMBEDDED_DEFINES')')dnl
dnl
dnl
ifdef(`INITIAL_EMBEDDED_DEFINES',`define(`DO_S')'`define(`HAVE_DISASSEMBLE')'ifdef(`DO_CXX',`define(`HAVE_ONLY_PREPROCESS')'))dnl
