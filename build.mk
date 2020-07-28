#
# Main build rules and targets for my Wolfenstein 3D clone
#

# OBJECT COMPILATION TARGETS {{{
# These targets define the compilation and interrelated dependencies of the
# object files defined in ${OBJ} that are used to build the final executable.

# This rule defines the dependency of the individual module object files upon
# their source files, from which they are compiled, their header files, from
# which the other modules may access their functions for linkage, and the Drummy
# Fish libraries, raycastlib and small3dlib, which provide the backend to the
# rendering.
${OBJ}: ${SRC} ${LIB} ${HDR}

# This rule defines the compilation of the individual C modules to object files,
# these are later linked together to for the final ${BIN} target, or may be
# combined individually with test object files to create unit tests.
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
${MAINS}: ${OBJ}
	@echo "${YELLOW}Linking $@...${RESET}"
	${CC} -o $@ ${OBJ} ${LDFLAGS}

# }}}

