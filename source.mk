#
# Main source skeleton generation rules and targets for my Wolfenstein 3D clone
#

# MODULE SOURCE GENERATION TARGETS {{{
# This section defines the rules and relationships for creating the source files
# for modules when new modules are created. The structure is as follows, each
# module has a C source file, as defined in ${SRC}, which depends on the
# matching header in ${HDR}, these define the internal functions, data
# structures, and module specific configuration.

# This target creates the bare bones structure of a source module and triggers
# the module's related header file to also be generated.
${MODULES:%=%.c}: %.c : %.h
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
${MODULES:%=%.h}:
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
		echo "#endif /* $$(echo '$@' | ${TO_UPPER}) */"              ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

# }}}

# MODULE TEST SOURCE GENERATION TARGETS {{{
# This section defines the rules for the generation of the test cases for the
# modules generated in the above section.

${MODULES:%=tests/%.c}: %.c : %.h
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * Source file for testing the ${@:tests/%=%} module"  ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "/* DEFINES {{{ */"                                     ; \
		echo ""                                                      ; \
		echo "#include \"../defines.h\""                             ; \
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
		echo "#include <stdlib.h>"                                   ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * Include the header file for the module this file"   ; \
		echo " * is testing, this allows this source to call that"   ; \
		echo " * modules (PUBLIC) functions."                        ; \
		echo " */"                                                   ; \
		echo "#include \"${@:tests/%.c=../%.h}\""                    ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * Include the header file for this module, note that" ; \
		echo " * this file should be included last."                 ; \
		echo " */"                                                   ; \
		echo "#include \"${<:tests/%=%}\""                           ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PUBLIC FUNCTIONS {{{ */"                            ; \
		echo ""                                                      ; \
		echo "PUBLIC int main() { /* {{{ */"                         ; \
		echo "	fail(\"Not implemented.\");"                         ; \
		echo ""                                                      ; \
		echo "	exit(EXIT_SUCCESS);"                                 ; \
		echo "} /* }}} */"                                           ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PRIVATE FUNCTIONS {{{ */"                           ; \
		echo ""                                                      ; \
		echo "PRIVATE void warn(char * msg) { /* {{{ */"             ; \
		echo "	fprintf(stderr, \"%s\\\\n\", msg);"                  ; \
		echo "} /* }}} */"                                           ; \
		echo ""                                                      ; \
		echo "PRIVATE void fail(char * msg) { /* {{{ */"             ; \
		echo "	warn(msg);"                                          ; \
		echo "	exit(EXIT_FAILURE);"                                 ; \
		echo "} /* }}} */"                                           ; \
		echo ""                                                      ; \
		echo "PRIVATE void assert(int cond, char * msg) { /* {{{ */" ; \
		echo "	if (!cond) {"                                        ; \
		echo "		fail(msg);"                                  ; \
		echo "	}"                                                   ; \
		echo "} /* }}} */"                                           ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

${MODULES:%=tests/%.h}:
	@[ -f $@ ] || echo "${YELLOW}Generating $@...${RESET} [update manually]"
	@[ -f $@ ] || {                                                        \
		echo "/**"                                                   ; \
		echo " * Header file for ${@:tests/%.h=%.c}"                 ; \
		echo " */"                                                   ; \
		echo ""                                                      ; \
		echo "/* PREVENT REEVALUATION {{{ */"                        ; \
		echo "#ifndef $$(echo '$@' | ${TO_UPPER})"                   ; \
		echo "#define $$(echo '$@' | ${TO_UPPER})"                   ; \
		echo ""                                                      ; \
		echo "/**"                                                   ; \
		echo " * As the unit tests are special modules that contain" ; \
		echo " * main function, all of the functions here should be" ; \
		echo " * static, aka PRIVATE. So in contrast to the module"  ; \
		echo " * sources, the test sources don't need the PRIVATE"   ; \
		echo " * and PUBLIC macros to be defined with any"           ; \
		echo " * conditional logic."                                 ; \
		echo " */"                                                   ; \
		echo "#define PRIVATE static"                                ; \
		echo "#define PUBLIC"                                        ; \
		echo ""                                                      ; \
		echo "/* PUBLIC FUNCTIONS {{{ */"                            ; \
		echo ""                                                      ; \
		echo "PUBLIC int main();"                                    ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "/* PRIVATE FUNCTIONS {{{ */"                           ; \
		echo ""                                                      ; \
		echo "PRIVATE void warn(char * msg);"                        ; \
		echo ""                                                      ; \
		echo "PRIVATE void fail(char * msg);"                        ; \
		echo ""                                                      ; \
		echo "PRIVATE void assert(int cond, char * msg);"            ; \
		echo ""                                                      ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
		echo "#endif /* $$(echo '$@' | ${TO_UPPER}) */"              ; \
		echo "/* }}} */"                                             ; \
		echo ""                                                      ; \
	} > $@

# }}}

