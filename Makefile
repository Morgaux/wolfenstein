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

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk ${LIB}

config.h: depends_on_sed
	${SUBSTITUTE} < config.def.h > $@

${BIN}: ${OBJ}
	${CC} -o $@ $^ ${LDFLAGS}

clean:
	rm -rf ${BIN}              \
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

install_doc: depends_on_sed
	mkdir -p ${MAN_DIR}
	${SUBSTITUTE} < ${BIN}.1 > ${MAN_DIR}/${BIN}.1
	chmod 644 ${MAN_DIR}/${BIN}.1

install: all install_doc
	mkdir -p ${BIN_DIR}
	cp -f ${BIN} ${BIN_DIR}/.
	chmod 755 ${BIN_DIR}/${BIN}

uninstall: clean
	rm -f ${BIN_DIR}/${BIN} ${MAN_DIR}/${BIN}.1

${DRUMMY_FISH_LIBS}: depends_on_git
	git clone https://gitlab.com/drummyfish/$@ || { cd $@ && git pull ; }

.PHONY: clean install install_doc uninstall

