#
# Main source skeleton generation rules and targets for my Wolfenstein 3D clone
#

# LIBRARY GENERATION TARGETS {{{
# These targets allow for the creation or fetching of any library dependencies
# given in the ${LIB} and ${HDR} variables, save for the headers directly
# relating to the module sources and tests.

# The ${DRUMMY_FISH_LIBS} libraries are used for the rendering backend and are
# frequently updated. To keep the sources for these upto date, these are pulled
# from their git repositories rather than being included as part of this repo.
# To ensure that the latest version is used, the repo subdirs are removed in the
# 'clean' target and if the subdir exists, it is entered and a git pull is run
# instead of the clone.
#
# NOTE: Currently, my forks of these are being used as these libraries fail
# certain compiler warnings I've enabled, my forks will be updated to pass these
# warnings and a pull request for each will be created.
${DRUMMY_FISH_LIBS}:
	@if ! test -d $@ >/dev/null 2>&1                                     ; \
	then                                                                   \
		echo "${YELLOW}Fetching $@...${RESET}"                       ; \
		git clone https://gitlab.com/morgaux/$@.git/                 ; \
	fi

# The config.h file is used to define user level configuration that isn't
# available at run time. The default values are provided in config.def.h,
# however, to avoid overwriting the defaults, an untracked copy is used.
config.h: config.def.h
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || cp config.def.h $@

# }}}

# SOURCE GENERATION TARGETS {{{
# This section defines the rules and relationships for creating the source files
# for modules when new modules are created. The structure is as follows, each
# module has a C source file, as defined in ${SRC}, which depends on the
# matching header in ${HDR}, these define the internal functions, data
# structures, and module specific configuration.

# This rule defines the dependency of the individual module source files upon
# their header files, with which they are compiled into the module objects, and
# the creation of the *.c file if it doesn't already exist.
.h.c:
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * $@ source module of ${BIN}"                         ; \
		echo " *"                                                    ; \
		echo " * @AUTHOR:      ${AUTHOR}"                            ; \
		echo " * @DESCRIPTION: [update manually]"                    ; \
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
		echo "TODO(\"Implement the public functions for $@\")"       ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PRIVATE FUNCTIONS {{{ */"                           ; \
		echo ""                                                      ; \
		echo "TODO(\"Implement the private functions for $@\")"      ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* MAIN FUNCTION {{{ */"                               ; \
		echo "/**"                                                   ; \
		echo " * Here we check if the current module is set as the"  ; \
		echo " * BIN value, which indicates that that module's main" ; \
		echo " * function should be used as the main function for"   ; \
		echo " * resulting executable being built."                  ; \
		echo " */"                                                   ; \
		echo "#ifdef ${@:%.c=%_main}"                                ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * Include the test source for this module, the tests" ; \
		echo " * may only be called by the main function so we only" ; \
		echo " * want them when the main function will also be"      ; \
		echo " * included. So it is included within this '#ifdef'."  ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "#include \"tests/$@\""                                 ; \
		echo ""                                                      ; \
		echo "int main(void);"                                       ; \
		echo "int main() { /* {{{ */"                                ; \
		echo "	return 0;"                                           ; \
		echo "} /* }}} */"                                           ; \
		echo ""                                                      ; \
		echo "#endif /* ${@:%.c=%_main} */"                          ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

# This rule defines the dependency of the each header file on the required
# library directories, while the headerfiles don't directly require them, they
# may be used in another module other than their own, and the header may
# internally use data types or structures defined in these libraries.
${SRC:.c=.h}: ${LIB}
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * $@ header for ${@:%.h=%.c} source module of ${BIN}" ; \
		echo " *"                                                    ; \
		echo " * @AUTHOR:      ${AUTHOR}"                            ; \
		echo " * @DESCRIPTION: [update manually]"                    ; \
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
		echo ""                                                      ; \
		echo "#endif"                                                ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "#endif /* $$(echo '$@' | ${TO_UPPER}) */"              ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

# }}}

# TEST SOURCE GENERATION TARGETS {{{
# This section defines the rules for the generation of the test cases for the
# modules generated in the above section.

${MODULES:%=tests/%.c}:
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * $@ source for testing the module of ${BIN}"         ; \
		echo " *"                                                    ; \
		echo " * @AUTHOR:      ${AUTHOR}"                            ; \
		echo " * @DESCRIPTION: [update manually]"                    ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "/* PREVENT REEVALUATION {{{ */"                        ; \
		echo "/**"                                                   ; \
		echo " * Since the test source files are merely included in" ; \
		echo " * other sources rather than directly compiled, it is" ; \
		echo " * necessary to prevent duplicate inclusions."         ; \
		echo " *"                                                    ; \
		echo " * NOTE: For the above reasons it is also superfluous" ; \
		echo " * to use the PRIVATE and PUBLIC macros, although if"  ; \
		echo " * these were to be used the would still work within"  ; \
		echo " * the parent module's scope. In their stead the TEST" ; \
		echo " * macro is defined here to A) explicitly mark which"  ; \
		echo " * functions are testcases, similarly to the @Test"    ; \
		echo " * annotation in languages such as Java, and B) for"   ; \
		echo " * testcase functions to be clearly distinct from any" ; \
		echo " * PRIVATE helpers that are defined here for the test" ; \
		echo " * functions (and only those functions) to use."       ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "#ifndef $$(echo '$@' | ${TO_UPPER})"                   ; \
		echo "#define $$(echo '$@' | ${TO_UPPER})"                   ; \
		echo "#undef  TEST"                                          ; \
		echo "#define TEST static"                                   ; \
		echo ""                                                      ; \
		echo "/* DEFINES {{{ */"                                     ; \
		echo ""                                                      ; \
		echo "#include \"../defines.h\""                             ; \
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
		echo "#include <stdlib.h>"                                   ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * Include the main unit test header file. This file"  ; \
		echo " * provides general functions for assertion, handling" ; \
		echo " * errors, and test related IO."                       ; \
		echo " */"                                                   ; \
		echo "#include \"tests.h\""                                  ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* TEST FUNCTIONS {{{ */"                              ; \
		echo ""                                                      ; \
		echo "TEST void TestSomeFunction(void);"                     ; \
		echo "TEST void TestSomeFunction() { /* {{{ */"              ; \
		echo "	ERRO(\"Dummy test case still present.\")"            ; \
		echo "} /* }}} */"                                           ; \
		echo ""                                                      ; \
		echo "/* }}} */" ; \
		echo ""                                                      ; \
		echo "#endif /* $$(echo '$@' | ${TO_UPPER}) */"              ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

# }}}

