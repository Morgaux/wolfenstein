#
#
# This file defines the main testing structures
#

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
	@${CLEAN}
	@if make -s run_$@ clean >.test_results 2>&1                         ; \
	then                                                                   \
		${CLEAR_LINE}                                                ; \
		${PRINTF} "${GREEN}PASS${RESET} for ${@:test_%=%}"           ; \
	else                                                                   \
		${CLEAR_LINE}                                                ; \
		${PRINTF} "${RED}FAIL${RESET} for ${@:test_%=%}"             ; \
		cat .test_results                                            ; \
		rm -f .test_results                                          ; \
		exit 1                                                       ; \
	fi

# This target triggers all test cases to be run in the order defined by
# ${TEST_ACTIONS} and runs the respective run_test_FOO action.
test: ${TEST_ACTIONS:%=test_%}
	${PRINTF} "${GREEN}ALL TESTS PASS${RESET}"
	${INDENT} "${YELLOW}COVERAGE: ${TEST_COVERAGE}${RESET}"

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

${TEST_ACTIONS:%=test_%_help}:
	@make ${@:%=%_message} test_after_help_message

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

