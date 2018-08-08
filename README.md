# Makefile Generation Stuff

<!--
I've been using this in a bunch of places, so I thought I might as well
make it public.


It requires GPP, the Generic PreProcessor:  https://logological.org/gpp


The generated C and C++ makefiles with "do\_arm" in their filenames are
tuned for producing .elf files for the ARM7TDMI CPU specifically.


You **could** just manually convert the makefiles, but that's annoying.  It
would defeat the purpose of makefile\_generic\_src.gpp to do that.
-->

Generation of GNUmakefiles using GNU m4.

These are indeed specific to the GNU version of Make.

These are mostly intended for my own personal use, but feel free to pick
them up if that's of interest to you.

Admittedly, I don't actually use all the makefiles that can be generated
with this setup, but some of them only exist for consistency anyway.

As I'm considering migrating to use of Dlang over C++, GNUmakefiles for use
with Dlang are being worked on as well now.

<!--
There are some other ones as well that are not generated, such as the
Icarus Verilog ones, but those are the exception rather than the rule.
-->

## History
Originally the generation of makefiles was done with
[GPP](https://logological.org/gpp), the Generic PreProcessor.

After a while (over a year), it was deemed to be unmaintainable, and it was
decided to switch to GNU m4 for this mini project.

