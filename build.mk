#
# Main build rules and targets for my Wolfenstein 3D clone
#

# LIBRARY BUILD TARGETS {{{
# These targets allow for the creation or fetching of any library dependencies
# given in the ${LIB} variable, as well as any custom defined headerfiles.

# The ${DRUMMY_FISH_LIBS} libraries are used for the rendering backend and are
# frequently updated. To keep the sources for these upto date, these are pulled
# from their git repositories rather than being included as part of this repo.
# To ensure that the latest version is used, the repo subdirs are removed in the
# 'clean' target and if the subdir exists, it is entered and a git pull is run
# instead of the clone.
${DRUMMY_FISH_LIBS}: depends_on_git
	@if cd $@ >/dev/null 2>&1                                            ; \
	then                                                                   \
		echo "${YELLOW}Updating $@...${RESET}"                       ; \
		git pull                                                     ; \
	else                                                                   \
		echo "${YELLOW}Fetching $@...${RESET}"                       ; \
		git clone https://gitlab.com/drummyfish/$@                   ; \
	fi

# This rule enforces a header file for each source file. These should NOT be
# confused with the config.h header, which is for configuration of compile time
# settings and behaviour. These headers are for function declarations and
# preprocessor ugliness.
${HDR}: depends_on_grep depends_on_sed depends_on_tee
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * Header file for $$(echo '$@' | sed 's/.h/.c/g')"    ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
	} | ${CREATE} $@

# The config.h file is used to define user level configuration that isn't
# available at run time. The default values are provided in config.def.h,
# however, to avoid overwriting the defaults, an untracked copy is used.
config.h: depends_on_sed depends_on_tee
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || cat config.def.h | ${SUBSTITUTE} > $@

# }}}

# OBJECT COMPILATION TARGETS {{{
# These targets define the compilation and interrelated dependencies of the
# object files defined in ${OBJ} that are used to build the final executable.

# This rule defines the compilation of the individual C modules to object files,
# these are later linked together to for the final ${BIN} target, or may be
# combined individually with test object files to create unit tests.
%.o: %.c
	@echo "${YELLOW}Building $@...${RESET}"
	${CC} -c ${CFLAGS} $<

# This rule defines the dependency of any given object file on the config.h file
# and the ${LIB} dirs, this trigger the creation of the config.h file if it has
# been cleaned and triggers an error if a library directory is missing. This is
# preferable to a linker failure as it is more descriptive of any OS or
# architecture differences in library management.
${OBJ}: config.h ${HDR} ${LIB}

# }}}

# BINARY COMPILATION TARGETS {{{
# These targets define the related ${OBJ} targets needed to build ${BIN} and
# provides the implementation to do so.

# This is the build rule for ${BIN} which creates a binary executable for
# installation or testing. All ${OBJ} files are compiled separately in the
# OBJECT COMPILATION TARGETS listed above.
${BIN}: ${OBJ}
	@echo "${YELLOW}Linking $@...${RESET}"
	${CC} -o $@ $^ ${LDFLAGS}

# }}}

# DOCUMENTATION CREATION TARGETS {{{
# These targets define the creation of the related ${MAN} page of the ${BIN}
# target.

# This target generates a troff manpage for installation of a manpage for
# ${BIN}. This follows the standard Unix documentation conventions.
${MAN}: depends_on_grep depends_on_sed depends_on_tee
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

