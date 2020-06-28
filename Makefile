#
# Main makefile for my Wolfenstein 3D clone
#

include colors.mk
include config.mk
include dependencies.mk 

config:
	@echo "${YELLOW}${BIN} build configuration:${RESET}"
	@echo "\t${MAGENTA}VERSION${RESET} = ${BOLD}${VERSION}-${RELEASE}${RESET}"
	@echo "\t${MAGENTA}BIN${RESET}     = ${BOLD}${BIN}${RESET}"
	@echo "\t${MAGENTA}LIB${RESET}     = ${BOLD}${LIB}${RESET}"
	@echo "\t${MAGENTA}SRC${RESET}     = ${BOLD}${SRC}${RESET}"
	@echo "\t${MAGENTA}OBJ${RESET}     = ${BOLD}${OBJ}${RESET}"
	@echo "\t${MAGENTA}BIN_DIR${RESET} = ${BOLD}${BIN_DIR}${RESET}"
	@echo "\t${MAGENTA}MAN_DIR${RESET} = ${BOLD}${MAN_DIR}${RESET}"

${OBJ}: config.h config.mk ${LIB}

config.h: depends_on_sed
	${SUBSTITUTE} < config.def.h > $@

.c.o:
	${CC} -c ${CFLAGS} $<

${BIN}: ${OBJ}
	${CC} -o $@ $^ ${LDFLAGS}

${BIN}.1:
	@{ \
		echo "${MAN_COMMENT} Manpage for ${BIN}"                     ; \
		echo "${MAN_COMMENT} Contact ${CONTACT}"                       \
		     "to correct any errors or typos."                       ; \
		echo "${MAN_TITLE} man 1"                                      \
		     "\"${DATE}\""                                             \
		     "\"${VERSION}\""                                          \
		     "\"${BIN} man page\""                                   ; \
		echo "${MAN_SECTION} NAME"                                   ; \
		echo "${BIN} \- ${SHORT_DESCRIPTION}"                        ; \
		echo "${MAN_SECTION} SYNOPSIS"                               ; \
		echo "${SYNOPSIS}"                                           ; \
		echo "${MAN_SECTION} DESCRIPTION"                            ; \
		echo "${DESCRIPTION}"                                        ; \
		echo "${MAN_SECTION} OPTIONS"                                ; \
		echo "${OPTIONS}"                                            ; \
		echo "${OPT_DESCRIPTION}"                                    ; \
		echo "${MAN_SECTION} SEE ALSO"                               ; \
		echo "${SEE_ALSO}"                                           ; \
		echo "${MAN_SECTION} BUGS"                                   ; \
		echo "${BUGS}"                                               ; \
		echo "${MAN_SECTION} AUTHOR"                                 ; \
		echo "${AUTHOR}"                                             ; \
	} | ${CREATE} $@

clean:
	rm -rf ${BIN}              \
	       ${BIN}.1            \
	       ${OBJ}              \
	       ${DRUMMY_FISH_LIBS} \
	       ${DIST_DIR}         \
	       ${DIST_DIR}.tar.gz

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

${DRUMMY_FISH_LIBS}: depends_on_git
	cd $@ && git pull || git clone https://gitlab.com/drummyfish/$@

.PHONY: clean dist install install_doc uninstall

