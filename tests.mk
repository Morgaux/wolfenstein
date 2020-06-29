#
# This file defines the main test cases and testing structures
#

# TEST CONFIG {{{

# This variable defines all test case names, for each test case a matching
# 'run_test_FOO' and 'test_FOO_help_message' target must be specified, to
# provide the implementation and description of the given test case. The
# implementations should fail gracefully on any error, display an error message
# and clean up any temporary files created to allow a clean workspace for the
# next test in the queue. Note that values in ${TEST_ACTIONS} shouldn't conflict
# with other build targets.
TEST_ACTIONS := build

# This specifies how long to wait for a test to complete, if this time elapses
# before the test completes, the test is marked as a failure.
TMOUT := 30s

# }}}

# TEST STRUCTURE {{{

# This section is kind of a mess, essentially it sets up a load of phony targets
# and creates them automatically from the ${TEST_ACTIONS} list. This allows a
# message to show before each test case, the test case to run and then the
# follow up message for that test case to show.

${TEST_ACTIONS:%=test_%}: % : %_start_message
	@if timeout ${TMOUT} make -s run_$@ 1>/dev/null 2>&1 ; \
	then \
		echo "${GREEN}PASS${RESET} for $@" ; \
	else \
		echo "${RED}FAIL${RESET} for $@" ; \
	fi
	@make -s $@_end_message ${SWALLOW_ERR}

${TEST_ACTIONS:%=test_%_start_message}:
	@echo "${YELLOW}Running test ${@:test_%_start_message=%}...${RESET}"

${TEST_ACTIONS:%=test_%_end_message}:
	@echo "${YELLOW}Completed test ${@:test_%_end_message=%}...${RESET}"

.PHONY: ${TEST_ACTIONS} \
        ${TEST_ACTIONS:%=test_%} \
        ${TEST_ACTIONS:%=test_%_start_message} \
        ${TEST_ACTIONS:%=test_%_end_message} \
        ${TEST_ACTIONS:%=run_test_%} \
        ${TEST_ACTIONS:%=test_%_usage_message} \
        ${TEST_ACTIONS:%=test_%_help_message} \
        test \
        test_help \
        test_before_help_message \
        test_after_help_message

.SILENT: ${TEST_ACTIONS} \
         ${TEST_ACTIONS:%=test_%} \
         ${TEST_ACTIONS:%=test_%_start_message} \
         ${TEST_ACTIONS:%=test_%_end_message} \
         ${TEST_ACTIONS:%=run_test_%} \
         ${TEST_ACTIONS:%=test_%_usage_message} \
         ${TEST_ACTIONS:%=test_%_help_message} \
         test \
         test_help \
         test_before_help_message \
         test_after_help_message

# }}}

# TEST CASES {{{

run_test_build:
	mkdir -p tmp
	make DESTDIR=tmp clean config all install uninstall dist
	test -f tmp${BIN_DIR}/${BIN}
	${CLEAN}
	${DELETE} tmp
	test ! -d tmp

test_build_help_message: test_build_usage_message
	@printf '\t%s\n' "This test ensures that the makefile build system is"
	@printf '\t%s\n' "functional and that is will not only allow for the"
	@printf '\t%s\n' "${BIN} target to be compiled, but also that it will"
	@printf '\t%s\n' "clean up after itself throughout the process."

# This target triggers all test cases to be run in the order defined by
# ${TEST_ACTIONS} and runs the respective run_test_FOO action.
test: ${TEST_ACTIONS:%=test_%} depends_on_timeout

# }}}

# HELP MESSAGES {{{

# These target displays a help message of the available test cases to run in
# bulk  via the 'test' action or individually via each respective 'test_FOO'
# action.
test_help: test_before_help_message \
           ${TEST_ACTIONS:%=test_%_help_message} \
           test_after_help_message

${TEST_ACTIONS:%=test_%_usage_message}:
	@printf   '%s\n' " "
	@printf   '%s\n' "${YELLOW}Test case:${RESET}"
	@printf '\t%s\n' "${BOLD}${@:test_%_usage_message=%}${RESET}"
	@printf   '%s\n' "${YELLOW}Usage:${RESET}"
	@printf '\t%s\n' "${BOLD}make test_${@:test_%_usage_message=%}${RESET}"
	@printf   '%s\n' "${YELLOW}Description:${RESET}"

test_before_help_message:
	@echo "${YELLOW}Automated test cases for ${BIN}:${RESET}"

test_after_help_message:
	@echo " "

# }}}

