# Makefile for OldSindhi font

FONTS=OldSindhi.ttf
DOCUMENTS=license.txt README
PKGS=MarathiCursive.7z
7ZOPT=-mx9

# Path to Graphite compiler
GRCOMPILER=/cygdrive/c/Apps/graphite/Graphite\ Compiler/GrCompiler

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

.SUFFIXES: .7z
.PHONY: dist
dist: ${PKGS}

MarathiCursive.7z: ${FONTS} ${DOCUMENTS}
	-rm -rf $*
	mkdir $*
	cp ${FONTS} ${DOCUMENTS} $*
	7z a ${7ZOPT} $@ $*

.PHONY: clean
clean:
	-rm Outlines.sfd OutlinesTT.sfd gdlerr.txt '$$_temp.gdl' raw.ttf ${FONTS}
	-rm -rf ${PKGS} ${PKGS:.7z=}
