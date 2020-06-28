#
# Main makefile for my Wolfenstein 3D clone
#

# This is the Main configuration file, it must be included first as it defines
# all needed targets, variables, macros, and make(1) settings.
include config.mk

# This is an optional file that defines some formatting eye candy to allow
# colouring the output of certain commands. At time of writing this is
# accomplished using 'tput' and is created to fail gracefully.
include colors.mk

# This file defines all compilation related targets, it depends internally on
# the config.mk file but doesn't included it so it may be used as part of a
# parallel build system in the feature, e.g. for unit testing.
include build.mk

# This file provides a method of asserting the existence of external tools and
# allowing useful and user friendly error messages, e.g. for git(1).
include dependencies.mk 

dist: clean ${DIST_FILES} depends_on_tar depends_on_gzip
	mkdir -p ${DIST_DIR}
	cp -R ${DIST_FILES} ${DIST_DIR}
	tar -cf ${DIST_DIR}.tar ${DIST_DIR}
	gzip ${DIST_DIR}.tar
	rm -rf ${DIST_DIR}

install_doc: ${BIN}.1 depends_on_sed
	mkdir -p ${MAN_DIR}
	${SUBSTITUTE} < $< > ${MAN_DIR}/$<
	chmod 644 ${MAN_DIR}/$<

install: all install_doc
	mkdir -p ${BIN_DIR}
	cp -f ${BIN} ${BIN_DIR}/.
	chmod 755 ${BIN_DIR}/${BIN}

uninstall: clean
	rm -f ${BIN_DIR}/${BIN} ${MAN_DIR}/${BIN}.1

.PHONY: dist install install_doc uninstall

