# Makefile for OldSindhi font

FONTS=OldSindhi.ttf
DOCUMENTS=License.txt License-MIT.txt License-OFL.txt README
PKGS=OldSindhi.tar.xz

# Path to Graphite compiler

# On Windows (Cygwin) uncomment:
#GRCOMPILER=/cygdrive/c/Program\ Files/Graphite\ Compiler/GrCompiler
# For systems other than Windows:
GRCOMPILER=wine ~/.wine/drive_c/Program\ Files/Graphite\ Compiler/GrCompiler.exe


.PHONY: all
all: ${FONTS}

Outlines.sfd: OldSindhi.sfd
	fontforge -script ./outlines.py
OutlinesTT.sfd: Outlines.sfd
	fontforge -script ./truetype.py

raw.ttf: OutlinesTT.sfd
	for i in $?;do fontforge -lang=ff -c "Open(\"$$i\");Generate(\"$@\");Close()";done

OldSindhi.ttf: raw.ttf OldSindhi.gdl
	$(GRCOMPILER) $^ $@

.SUFFIXES: .tar.xz
.PHONY: dist
dist: ${PKGS}

OldSindhi.tar.xz: ${FONTS} ${DOCUMENTS}
	-rm -rf $*
	mkdir $*
	cp ${FONTS} ${DOCUMENTS} $*
	tar -cJf $@ $*

.PHONY: clean
clean:
	-rm Outlines.sfd OutlinesTT.sfd gdlerr.txt '$$_temp.gdl' raw.ttf ${FONTS}
	-rm -rf ${PKGS} ${PKGS:.tar.xz=}
