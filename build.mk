#
# Main build rules and targets for my Wolfenstein 3D clone
#

# OBJECT COMPILATION TARGETS {{{
# These targets define the compilation and interrelated dependencies of the
# object files defined in ${OBJ} that are used to build the final executable.

# This rule defines the compilation of the individual C modules to object files,
# these are later linked together to for the final ${BIN} target, or may be
# combined individually with test object files to create unit tests.
.c.o:
	@echo "${YELLOW}Building $@...${RESET}"
	${CC} -o $@ -c ${CFLAGS} $<

# This target also defines the dependency of the ${OBJ} object files on the test
# files for each module. It is a separate target to allow the suffix implicit
# rule to remain free of any explicit dependencies.
#
# NOTE: the test C sources are not compiled into .o object files, but are rather
# included directly in the ${MODULES} sources with their main functions.
${OBJ}: ${MODULES:%=tests/%.c}

# }}}

# BINARY COMPILATION TARGETS {{{
# These targets define the related ${OBJ} targets needed to build ${BIN} and
# provides the implementation to do so.

# This target defines the final compilation and linking of the final executable.
${BIN}: ${OBJ} ${BIN:%=tests/%.c}
	@[ -f "$@" ] || echo "${YELLOW}Linking $@...${RESET}"
	${CC} -o $@ ${OBJ} ${LDFLAGS}

# }}}

