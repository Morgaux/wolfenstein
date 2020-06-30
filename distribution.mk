#
# This is the distribution makefile for my Wolfenstein 3D clone
#

# SOURCE TAR BALL DISTRIBUTION {{{

# The 'dist' phony target triggers the creation of a distributable tar ball of
# all source files. This allows for a release to be created as a single stage
# and within a single action.
dist: clean ${DIST_FILES} depends_on_tar depends_on_gzip
	@${PRINTF} "${YELLOW}Creating ditribution tarball...${RESET}"
	${CLEAN}
	mkdir -p ${DIST_DIR}
	cp -R ${DIST_FILES} ${DIST_DIR}
	tar ${TAR_FLAGS} -cf - ${DIST_DIR} | gzip ${GZIP_FLAGS} > ${DIST_TGZ}
	rm -rf ${DIST_DIR} ${DIST_TAR}

# }}}

.PHONY: dist

