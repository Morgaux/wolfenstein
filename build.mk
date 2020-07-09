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
	@if cd $@ >/dev/null 2>&1                                            ; \
	then                                                                   \
		echo "${YELLOW}Updating $@...${RESET}"                       ; \
		git pull                                                     ; \
	else                                                                   \
		echo "${YELLOW}Fetching $@...${RESET}"                       ; \
		git clone https://gitlab.com/drummyfish/$@.git/              ; \
	fi

# }}}

# SOURCE BUILD TARGETS  {{{
# This section defines the rules and relationships for creating the source files
# for modules when new modules are created. The structure is as follows, each
# module has a C source file, as defined in ${SRC}, which depends on the
# matching header in ${HDR}, these define the internal functions, data
# structures, and module specific configuration.

# This target creates the bare bones structure of a source module and triggers
# the module's related header file to also be generated.
${SRC}: %.c : %.h
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * Source file for the ${@:%.c=%} module of ${BIN}"    ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "/* DEFINES {{{ */"                                     ; \
		echo ""                                                      ; \
		echo "#include \"defines.h\""                                ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * Define the current source file, this allows the"    ; \
		echo " * header file of this module to know that it has"     ; \
		echo " * been included in it's own module's source, as well" ; \
		echo " * allowing the header files for any other modules to" ; \
		echo " * know that they are being included in a different"   ; \
		echo " * module and making any necessary changes."           ; \
		echo " */"                                                   ; \
		echo "#define $$(echo '$@' | ${TO_UPPER})"                   ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* INCLUDES {{{ */"                                    ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * Include any external libraries and system headers"  ; \
		echo " * here, in order."                                    ; \
		echo " */"                                                   ; \
		echo "#include <stdio.h>"                                    ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * Include the header file for this module, note that" ; \
		echo " * this file should be included last."                 ; \
		echo " */"                                                   ; \
		echo "#include \"$<\""                                       ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PUBLIC FUNCTIONS {{{ */"                            ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PRIVATE FUNCTIONS {{{ */"                           ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * TODO: Provide function implementations here."       ; \
		echo " *"                                                    ; \
		echo " * This is a dummy function to allow compilation to"   ; \
		echo " * succeed, remove the declaration and function body"  ; \
		echo " * once proper functions are added."                   ; \
		echo " */"                                                   ; \
		echo "PRIVATE void dummy() { /* {{{ */"                      ; \
		echo '	printf("Hello World!\\n");'                          ; \
		echo "} /* }}} */"                                           ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

# This target generates the bare bones framework for the header file of each
# module. It includes abstractions for the scope of the functions and data
# structures it provides, allowing the same header file to function for both
# within the module's source and within other modules calling that module's
# functionality. See the source below for further details.
${HDR}:
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * Header file for ${@:%.h=%.c}"                       ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "/* PREVENT REEVALUATION {{{ */"                        ; \
		echo "#ifndef $$(echo '$@' | ${TO_UPPER})"                   ; \
		echo "#define $$(echo '$@' | ${TO_UPPER})"                   ; \
		echo ""                                                      ; \
		echo "/* DETERMINE SCOPE OF SYMBOLS {{{ */"                  ; \
		echo "/**"                                                   ; \
		echo " * The way we control the access level of a function"  ; \
		echo " * or variable in C is via the use of the static and"  ; \
		echo " * extern keywords. However, contrary to the use of"   ; \
		echo " * the private and public keywords, the declaration"   ; \
		echo " * of a function in C must vary for use in the same"   ; \
		echo " * source as the declaration and use in an externally" ; \
		echo " * linked object file. To allow a single function"     ; \
		echo " * declaration to function for both internal and"      ; \
		echo " * external use, here the PUBLIC and PRIVATE symbols"  ; \
		echo " * are defined depending on whether this header is"    ; \
		echo " * included in the module of the same name (this is"   ; \
		echo " * determined via the '#ifdef' preprocessor, as all"   ; \
		echo " * modules define a symbol of their name)."            ; \
		echo " *"                                                    ; \
		echo " * Here, if the source file including this header is"  ; \
		echo " * part of the same module, then the PRIVATE symbol"   ; \
		echo " * defined as the static key word, allowing functions" ; \
		echo " * declared as 'PRIVATE void foo();' to be expanded"   ; \
		echo " * as 'static void foo();'. However, if the file is"   ; \
		echo " * not part of the same module, PUBLIC is defined as"  ; \
		echo " * the extern keyword, which allows for the functions" ; \
		echo " * available to the other module to be accessed. In"   ; \
		echo " * each case the other symbol is defined as NO_OP, a"  ; \
		echo " * non-action which is defined in defines.h and this"  ; \
		echo " * allows a PUBLIC function to skip using the  extern" ; \
		echo " * keyword when used within the same module."          ; \
		echo " *"                                                    ; \
		echo " * NOTE: PRIVATE functions should be hidden from the"  ; \
		echo " * other modules to prevent any conflicts with other"  ; \
		echo " * functions in that module. They should instead be"   ; \
		echo " * wrapped in another #ifdef block below."             ; \
		echo " */"                                                   ; \
		echo "#undef PUBLIC"                                         ; \
		echo "#undef PRIVATE"                                        ; \
		echo ""                                                      ; \
		echo "#define PRIVATE static"                                ; \
		echo ""                                                      ; \
		echo "#ifdef $$(echo '${@:%.h=%.c}' | ${TO_UPPER})"          ; \
		echo "#define PUBLIC"                                        ; \
		echo "#else"                                                 ; \
		echo "#define PUBLIC extern"                                 ; \
		echo "#endif"                                                ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PUBLICS {{{ */"                                     ; \
		echo "/**"                                                   ; \
		echo " * All data structures and function definitions that"  ; \
		echo " * need to be available to other functions should be"  ; \
		echo " * provided here with the PUBLIC keyword."             ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PRIVATES {{{ */"                                    ; \
		echo "/**"                                                   ; \
		echo " * All data structures and function definitions that"  ; \
		echo " * need to be limited to the current module should be" ; \
		echo " * provided within the #ifdef...#endif block below,"   ; \
		echo " * with the PRIVATE keyword."                          ; \
		echo " */"                                                   ; \
		echo "#ifdef $$(echo '${@:%.h=%.c}' | ${TO_UPPER})"          ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * TODO: Provide function declarations here."          ; \
		echo " *"                                                    ; \
		echo " * This is a dummy function to allow compilation to"   ; \
		echo " * succeed, remove the declaration and function body"  ; \
		echo " * once proper functions are added."                   ; \
		echo " */"                                                   ; \
		echo "PRIVATE void dummy();"                                 ; \
		echo ""                                                      ; \
		echo "#endif"                                                ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "#endif"                                                ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

# }}}

# OBJECT COMPILATION TARGETS {{{
# These targets define the compilation and interrelated dependencies of the
# object files defined in ${OBJ} that are used to build the final executable.

# This rule defines the compilation of the individual C modules to object files,
# these are later linked together to for the final ${BIN} target, or may be
# combined individually with test object files to create unit tests.
${OBJ}: %.o: %.c
	@echo "${YELLOW}Building $@...${RESET}"
	${CC} -c ${CFLAGS} $<

# }}}

# BINARY COMPILATION TARGETS {{{
# These targets define the related ${OBJ} targets needed to build ${BIN} and
# provides the implementation to do so.

# The config.h file is used to define user level configuration that isn't
# available at run time. The default values are provided in config.def.h,
# however, to avoid overwriting the defaults, an untracked copy is used.
config.h:
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || cat config.def.h | ${SUBSTITUTE} > $@

# This rule defines the compilation of a ${MAINS} executable, this is generally
# used to compile ${BIN} (which must be defined in ${MAINS} for this reason),
# however, this target is also used for the compilation of other ${MAINS}
# targets, for instance for the compilation of test cases. This target links
# together the compiled ${OBJ} object files for each of the modules and
# additionally triggers the creation of the config.h file as it is used for all
# of the ${MAINS} builds. Each build also depends on the ${LIB} directories, and
# the ${INC} headers, these may also be depended on by individual modules,
# however, the primary purpose of the ${INC} headers is to allow the ${MAINS}
# sources to access the external functions exposed by each module. Similarly,
# the ${LIB} directories contain library resources that may be required by any
# of the modules, however, they are only defined as a dependency of the ${MAINS}
# target currently being built before the ${OBJ} dependencies, and so will be
# generated before the ${OBJ} targets are built.
${MAINS}: config.h ${INC} ${LIB} ${OBJ}
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

