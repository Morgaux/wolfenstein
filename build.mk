#
# Main build rules and targets for my Wolfenstein 3D clone
#

# LIBRARY BUILD TARGETS {{{
# These targets allow for the creation or fetching of any library dependencies
# given in the ${LIB} variable.

# The ${DRUMMY_FISH_LIBS} libraries are used for the rendering backend and are
# frequently updated. To keep the sources for these upto date, these are pulled
# from their git repositories rather than being included as part of this repo.
# To ensure that the latest version is used, the repo subdirs are removed in the
# 'clean' target and if the subdir exists, it is entered and a git pull is run
# instead of the clone.
${DRUMMY_FISH_LIBS}:
	@if ! test -d $@ >/dev/null 2>&1                                     ; \
	then                                                                   \
		echo "${YELLOW}Fetching $@...${RESET}"                       ; \
		git clone https://gitlab.com/drummyfish/$@.git/              ; \
	fi

# The config.h file is used to define user level configuration that isn't
# available at run time. The default values are provided in config.def.h,
# however, to avoid overwriting the defaults, an untracked copy is used.
config.h: config.def.h
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || cp $< $@

# }}}

# OBJECT COMPILATION TARGETS {{{
# These targets define the compilation and interrelated dependencies of the
# object files defined in ${OBJ} that are used to build the final executable.

# This rule defines the compilation of the individual C modules to object files,
# these are later linked together to for the final ${BIN} target, or may be
# combined individually with test object files to create unit tests.

${OBJ}: ${LIB}

.c.o:
	@echo "${YELLOW}Building $@...${RESET}"
	${CC} -o $@ -c ${CFLAGS} $<

# }}}

# BINARY COMPILATION TARGETS {{{
# These targets define the related ${OBJ} targets needed to build ${BIN} and
# provides the implementation to do so.

# This rule defines the compilation of a ${MAINS} executable, this is generally
# used to compile ${BIN} (which must be defined in ${MAINS} for this reason),
# however, this target is also used for the compilation of other ${MAINS}
# targets, for instance for the compilation of test cases. This target links
# together the compiled ${OBJ} object files for each of the modules and
# additionally triggers the creation of the config.h file as it is used for all
# of the ${MAINS} builds.
${MAINS}: config.h ${OBJ}
	@echo "${YELLOW}Linking $@...${RESET}"
	${CC} -o $@ ${OBJ} ${LDFLAGS}

# }}}

# DOCUMENTATION CREATION TARGETS {{{
# These targets define the creation of the related ${MAN} page of the ${BIN}
# target.

# This target generates a troff manpage for installation of a manpage for
# ${BIN}. This follows the standard Unix documentation conventions.
${MAN}:
	@echo "${YELLOW}Generating ${MAN} manpage...${RESET}"
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

