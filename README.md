# Makefile Generation Stuff

I've been using this in a bunch of places, so I thought I might as well
make it public.


It requires GPP, the Generic PreProcessor:  https://logological.org/gpp


The generated C and C++ makefiles with "do\_arm" in their filenames are
tuned for producing .elf files for the ARM7TDMI CPU specifically.


You **could** just manually convert the makefiles, but that's annoying.  It
would defeat the purpose of makefile\_generic\_src.gpp to do that.
