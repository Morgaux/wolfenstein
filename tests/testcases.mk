#
#
# This file defines the main test cases and their help messages
#

# TEST CASES {{{
# Populate this section with targets in the form of 'run_test_FOO' which contain
# the implementation for each test. The implementation can consist of anything,
# as long as the target completes without errors in an invocation of 'make
# run_test_FOO' then the test is considered to have passed, so if you want to
# write an assertion, using the 'test(1)' command is an excellent tool to check
# that the test case is passing muster. To make the test get included in an
# invocation of 'make test' or 'make test_FOO' you should add 'FOO' to the
# ${TEST_ACTIONS} list, be sure to provide a matching 'test_FOO_help_message'
# target under "HELP MESSAGES" below.

run_test_all:
	rm -f ${BIN}
	make all
	${ASSERT_FILE_EXISTS} ${BIN}

run_test_config:
	${ASSERT_STRING_NOT_EMPTY} "$$(make config)"

run_test_clean:
	rm -f ${MAN}
	touch ${MAN}
	${ASSERT_FILE_EXISTS} ${MAN}
	make clean
	${ASSERT_FALSE} -f ${MAN}

run_test_dist:
	make dist
	tar xzvf ${DIST_TGZ}
	${ASSERT_DIRECTORY_EXISTS} ${DIST_DIR}
	cd ${DIST_DIR} && make ${WOLF_3D:%=test_%}

run_test_run:
	make run

run_test_install:
	mkdir -p tmp
	make DESTDIR=tmp install
	${ASSERT_DIRECTORY_EXISTS} tmp${BIN_DIR}/
	${ASSERT_DIRECTORY_EXISTS} tmp${MAN_DIR}/
	${ASSERT_FILE_EXISTS}      tmp${BIN_DIR}/${WOLF_3D}
	${ASSERT_FILE_EXECUTABLE}  tmp${BIN_DIR}/${WOLF_3D}
	${ASSERT_FILE_NOT_EMPTY}   tmp${BIN_DIR}/${WOLF_3D}
	${ASSERT_FILE_EXISTS}      tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	${ASSERT_FILE_READABLE}    tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	${ASSERT_FILE_NOT_EMPTY}   tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	${CLEAN}
	${DELETE} tmp
	${ASSERT_FALSE} -d tmp

run_test_uninstall:
	mkdir -p tmp
	make DESTDIR=tmp install
	${ASSERT_DIRECTORY_EXISTS} tmp${BIN_DIR}/
	${ASSERT_DIRECTORY_EXISTS} tmp${MAN_DIR}/
	${ASSERT_FILE_EXISTS} tmp${BIN_DIR}/${WOLF_3D}
	${ASSERT_FILE_EXISTS} tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	make DESTDIR=tmp uninstall
	${ASSERT_FALSE} -f tmp${BIN_DIR}/${WOLF_3D}
	${ASSERT_FALSE} -f tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	${CLEAN}
	${DELETE} tmp
	${ASSERT_FALSE} -d tmp

${DRUMMY_FISH_LIBS:%=run_test_%}:
	make ${@:run_test_%=%}
	${ASSERT_DIRECTORY_EXISTS} ${@:run_test_%=%}
	${ASSERT_DIRECTORY_EXISTS} ${@:run_test_%=%}/programs
	${ASSERT_FILE_EXISTS} ${@:run_test_%=%}/programs/helloWorld.c
	cd ${@:run_test_%=%}/programs && \
		${CC} \
		${OPTIMISATION_FLAGS} -o helloWorld helloWorld.c
	${ASSERT_FILE_EXECUTABLE} ${@:run_test_%=%}/programs/helloWorld
	./${@:run_test_%=%}/programs/helloWorld

${WOLF_3D:%=run_test_%_no_warnings}:
	make WARNINGS=error BIN=${@:run_test_%_no_warnings=%} run

${MODULES:%=run_test_%}:
	make BIN=${@:run_test_%=%} run

${COMPILERS:%=run_test_%}:
	make CC=${@:run_test_%=%} run

# }}}

# HELP MESSAGES {{{
# Populate this section with targets in the form of 'test_FOO_help_message' and
# fill each with a description of the test case and it's purpose, in addition to
# any notes on it's dependencies (if any). Each target in this section should
# specify 'test_FOO_usage_message' as a dependency, this is so that the full
# message shown always includes the generalised preamble text. To fit the format
# requirements for this structure, these targets should be written to fit 80
# columns and use %{INDENT} "foo bar" rather than echo "foo bar" to add a single
# TAB indent in front of the message block. This is for consistency within the
# 'test_help' message. To include the test's description in the full help
# message add 'FOO' to the ${TEST_ACTIONS} list, be sure to provide a matching
# 'run_test_FOO' target above under "TEST CASES".

${PHONIES:%=test_%_help_message}:
	@make -s ${@:%_help_message=%_usage_message}
	@${INDENT} "This test ensures that the ${@:test_%_help_message=%} make"
	@${INDENT} "target can successfully run and does what it is meant to."
	@${INDENT} "This test is a smoke screen that simply breaks down the big"
	@${INDENT} "picture into the individual actions that a user can invoke:"
	@${INDENT} "	${BOLD}make ${@:test_%_help_message=%}${RESET}"

${DRUMMY_FISH_LIBS:%=test_%_help_message}:
	@make -s ${@:%_help_message=%_usage_message}
	@${INDENT} "This test ensures that this Drummy Fish library has been"
	@${INDENT} "correctly loaded and compiles successfully using the"
	@${INDENT} "${BOLD}\$${CFLAGS}${RESET} used to build ${WOLF_3D},"
	@${INDENT} "although only in a in a simple configuration similar to a"
	@${INDENT} "hello world program. This is checked for using one of the"
	@${INDENT} "provided files in this library's repo, at:"
	@${INDENT} "	${BOLD}${@:test_%_help_message=%}/programs/${RESET}"
	@${INDENT} "which simply renders a single frame in ASCII art. If this"
	@${INDENT} "fails then a more complex build will likely fail also."

${WOLF_3D:%=test_%_no_warnings_help_message}:
	@make -s ${@:%_help_message=%_usage_message}
	@${INDENT} "This test ensures that ${WOLF_3D} target can be build with"
	@${INDENT} "${BOLD}-Werror${RESET} compiler option, meaning that there"
	@${INDENT} "are no warnings generated by the compiler. Esentialy, the"
	@${INDENT} "${BOLD}${WOLF_3D:%=%_no_warnings}${RESET} test is simply a"
	@${INDENT} "stricter version of the ${BOLD}${WOLF_3D}${RESET} test."

${MODULES:%=test_%_help_message}:
	@make -s ${@:%_help_message=%_usage_message}
	@${INDENT} "This test ensures that the ${@:test_%_help_message=%}"
	@${INDENT} "module is functioning correctly. This is tested by linking"
	@${INDENT} "the ${@:test_%_help_message=%} module against a custom"
	@${INDENT} "main() function that runs the ${@:test_%_help_message=%}"
	@${INDENT} "module's functions with dummy inputs and sanity checks the"
	@${INDENT} "results."

${COMPILERS:%=test_%_help_message}:
	@make -s ${@:%_help_message=%_usage_message}
	@${INDENT} "This test ensures that ${WOLF_3D} project can be compiled"
	@${INDENT} "and linked with the ${BOLD}$${CC}${RESET} compiler set to"
	@${INDENT} "${BOLD}${@:test_%_help_message=%}${REST}, assuming that it"
	@${INDENT} "available on the building machine, if not then this test"
	@${INDENT} "will simply fail."

# }}}

