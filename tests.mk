#
# This file defines the main test cases and testing structures
#

# TEST MACROS {{{
# This section contains macros for use with test cases, especially 'assertion'
# statements that allow more programmatic and readable test cases.

# These are simple wrappers that encapsulate the test(1) utility on UNIX boxes.
ASSERT_TRUE  := echo "${YELLOW}[ASSERTION]${RESET}" ; test
ASSERT_FALSE := echo "${YELLOW}[NEGATIVE ASSERTION]${RESET}" ; test !

# These assertions are for testing and asserting the specific properties of
# given files by local or absolute file name.
ASSERT_FILE_EXISTS      := echo "${YELLOW}[ASSERT EXISTS]${RESET}"     ; test -f
ASSERT_DIRECTORY_EXISTS := echo "${YELLOW}[ASSERT DIR EXISTS]${RESET}" ; test -d
ASSERT_FILE_EXECUTABLE  := echo "${YELLOW}[ASSERT EXECUTABLE]${RESET}" ; test -x
ASSERT_FILE_READABLE    := echo "${YELLOW}[ASSERT READABLE]${RESET}"   ; test -r
ASSERT_FILE_NOT_EMPTY   := echo "${YELLOW}[ASSERT NOT EMPTY]${RESET}"  ; test -s

# These are the assertion macros for testing properties of shell strings, these
# may be expanded make(1) variables or shell expression results.
ASSERT_STRING_EMPTY     := echo "${YELLOW}[ASSERT EMPTY]${RESET}"     ; test -z
ASSERT_STRING_NOT_EMPTY := echo "${YELLOW}[ASSERT NOT EMPTY]${RESET}" ; test -n

# }}}

# TEST CONFIG {{{

# This variable defines all test case names, for each test case a matching
# 'run_test_FOO' and 'test_FOO_help_message' target must be specified, to
# provide the implementation and description of the given test case. The
# implementations should fail gracefully on any error, display an error message
# and clean up any temporary files created to allow a clean workspace for the
# next test in the queue. Note that values in ${TEST_ACTIONS} shouldn't conflict
# with other build targets.
TEST_ACTIONS := build ${DRUMMY_FISH_LIBS} ${MODULES}

# This specifies how long to wait for a test to complete, if this time elapses
# before the test completes, the test is marked as a failure.
TMOUT := 30s

# }}}

# TEST STRUCTURE {{{
# This section is a mess but is generalised for all test cases and so should
# only be modified in ways that are transparent to the defined structure of the
# test cases and help messages. Any additional tests should be created via the
# ${TEST_ACTIONS} variable and the addition of 'run_test_FOO' targets and
# matching 'test_FOO_help_message' targets in the sections further down.

# This target group provides the implementation for each 'test_FOO' target. This
# works by printing a running message and silently running the matching
# 'run_test_FOO' target in the background with a timeout, when the
# 'run_test_FOO' target completes or times out, the exit code is evaluated to
# determine the result of the test. Exit code 0 is assumed to be a success and a
# success message is printed in green, exit code 124 is used by the timeout(1)
# utility to indicate that the test timed out and so a timeout message is shown
# in red, any other exit code is treated as an error and shown in red. This
# final message, regardless of success state, overwrites the running message,
# keeping the total output to just one line per test case, indicating the
# success state of each.
${TEST_ACTIONS:%=test_%}:
	@printf "${YELLOW}Running test${RESET}: ${BOLD}${@:test_%=%}...${RESET}"
	@case                                                                  \
		"$$(                                                           \
			timeout ${TMOUT}                                       \
			make -s run_$@ clean >/dev/null 2>&1                 ; \
			echo $$?                                               \
		)"                                                             \
	in                                                                     \
		124|143)                                                       \
			${CLEAR_LINE}                                        ; \
			${PRINTF} "${RED}TIMEOUT${RESET} for ${@:test_%=%}"  ; \
		;;                                                             \
		0)                                                             \
			${CLEAR_LINE}                                        ; \
			${PRINTF} "${GREEN}PASS${RESET} for ${@:test_%=%}"   ; \
		;;                                                             \
		*)                                                             \
			${CLEAR_LINE}                                        ; \
			${PRINTF} "${RED}FAIL${RESET} for ${@:test_%=%}"     ; \
		;;                                                             \
	esac || true

# This target triggers all test cases to be run in the order defined by
# ${TEST_ACTIONS} and runs the respective run_test_FOO action.
test: ${TEST_ACTIONS:%=test_%}

# This target displays a help message of the available test cases to run in bulk
# via the 'test' action or individually via each respective 'test_FOO' action.
test_help: test_before_help_message \
           ${TEST_ACTIONS:%=test_%_help_message} \
           test_after_help_message

# This target runs before the main body of the help text displayed by
# 'test_help', this is the only time this target is triggered so it may be as
# specialised as desired.
test_before_help_message:
	@echo "${YELLOW}Automated test cases for ${WOLF_3D}:${RESET}"

# This target runs after the main body of the help text displayed by
# 'test_help' OR by any of the individual 'test_FOO_help' targets. (Note is
# currently just prints a separating line.)
test_after_help_message:
	@echo " "

# This target group shows a formatted message for each help message given in the
# form 'test_FOO_help_message', as they give the matching
# 'test_FOO_usage_message' target as a dependency which in turn triggers this
# heading before the actual description text.
${TEST_ACTIONS:%=test_%_usage_message}:
	@${PRINTF} " "
	@${PRINTF} "${YELLOW}Test case:${RESET}"
	@${INDENT} "${BOLD}${@:test_%_usage_message=%}${RESET}"
	@${PRINTF} "${YELLOW}Usage:${RESET}"
	@${INDENT} "${BOLD}make test_${@:test_%_usage_message=%}${RESET}"
	@${INDENT} "${BOLD}make test_${@:test_%_usage_message=%}_help${RESET}"
	@${PRINTF} "${YELLOW}Description:${RESET}"

${TEST_ACTIONS:%=test_%_help}: % : %_message test_after_help_message

# This variable defines all of the possible targets that may be used, including
# those that are only used internally.
ALL_TEST_TARGETS := ${TEST_ACTIONS}                                            \
                    ${TEST_ACTIONS:%=test_%}                                   \
                    ${TEST_ACTIONS:%=run_test_%}                               \
                    ${TEST_ACTIONS:%=test_%_usage_message}                     \
                    ${TEST_ACTIONS:%=test_%_help_message}                      \
                    test                                                       \
                    test_help                                                  \
                    test_before_help_message                                   \
                    test_after_help_message

# All of these targets are of course PHONY as they are just abstractions to
# trigger different messages in the correct order, as well as trigger assertion
# targets to run the test, none of which create new files that they do not the
# clean up.
.PHONY: ${ALL_TEST_TARGETS}

# These test targets should also be SILENT, so only the desired output is given
# from the failure or success messages.
.SILENT: ${ALL_TEST_TARGETS}

# }}}

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

run_test_build:
	mkdir -p tmp
	make DESTDIR=tmp clean config all install uninstall dist
	${ASSERT_DIRECTORY_EXISTS} tmp${BIN_DIR}/
	${ASSERT_DIRECTORY_EXISTS} tmp${MAN_DIR}/
	${ASSERT_FILE_EXECUTABLE}  tmp${BIN_DIR}/${WOLF_3D}
	${ASSERT_FILE_EXISTS}      tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	${ASSERT_FILE_READABLE}    tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	${ASSERT_FILE_NOT_EMPTY}   tmp${MAN_DIR}/${WOLF_3D:%=%.1}
	${CLEAN}
	${DELETE} tmp
	${ASSERT_FALSE} -d tmp

${DRUMMY_FISH_LIBS:%=run_test_%}: run_test_% : %
	${ASSERT_DIRECTORY_EXISTS} $<
	${ASSERT_DIRECTORY_EXISTS} $</programs
	${ASSERT_FILE_EXISTS} $</programs/helloWorld.c
	cd $</programs && ${CC} ${CFLAGS} -o helloWorld helloWorld.c
	${ASSERT_FILE_EXECUTABLE} $</programs/helloWorld
	./$</programs/helloWorld

${MODULES:%=run_test_%}:
	make BIN=${@:run_test_%=tests/%} run

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

test_build_help_message: test_build_usage_message
	@${INDENT} "This test ensures that the makefile build system is"
	@${INDENT} "functional and that is will not only allow for the"
	@${INDENT} "${WOLF_3D} target to be compiled, but also that it will"
	@${INDENT} "clean up after itself throughout the process."

${DRUMMY_FISH_LIBS:%=test_%_help_message}: %_help_message : %_usage_message
	@${INDENT} "This test ensures that this Drummy Fish library has been"
	@${INDENT} "correctly loaded and compiles successfully using the"
	@${INDENT} "\$${CFLAGS} used to build ${WOLF_3D}, although only in a in"
	@${INDENT} "a simple configuration similar to a hello world program."
	@${INDENT} "This is checked for using one of the provided files in this"
	@${INDENT} "library's repo, at programs/helloWorld.c, which simply"
	@${INDENT} "renders a single frame in ASCII art. If this fails then a"
	@${INDENT} "more complex build will likely fail also."

${MODULES:%=test_%_help_message}: %_help_message : %_usage_message
	@${INDENT} "This test ensures that the ${@:test_%_help_message} module"
	@${INDENT} "is functioning correctly. This is tested by linking the"
	@${INDENT} "${@:test_%_help_message} module against a custom main()"
	@${INDENT} "function that runs the ${@:test_%_help_message} module's"
	@${INDENT} "functions with dummy inputs and sanity checks the results."

# }}}

