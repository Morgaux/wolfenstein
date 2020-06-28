#
# Main build rules and targets for my Wolfenstein 3D clone
#

# LIBRARY BUILD TARGETS {{{
# These targets allow for the creation or fetching of any library dependencies
# given in the ${LIB} variable, as well as any custom defined headerfiles.

${DRUMMY_FISH_LIBS}: depends_on_git
	cd $@ && git pull || git clone https://gitlab.com/drummyfish/$@

config.h: depends_on_sed
	${SUBSTITUTE} < config.def.h > $@

# }}}

# OBJECT COMPILATION TARGETS {{{
# These targets define the compilation and interrelated dependencies of the
# object files defined in ${OBJ} that are used to build the final executable.

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk ${LIB}

# }}}

# BINARY COMPILATION TARGETS {{{
# These targets define the related ${OBJ} targets needed to build ${BIN} and
# provides the implementation to do so.

${BIN}: ${OBJ}
	${CC} -o $@ $^ ${LDFLAGS}

# }}}

# DOCUMENTATION CREATION TARGETS {{{
# These targets define the creation of the related ${MAN} page of the ${BIN}
# target.

${MAN}:
	@{                                                                     \
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

# }}}

