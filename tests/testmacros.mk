#
#
# This file defines the test case macros for assertion and error reporting
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

# This macro defines the manner in which the test output can give the test
# coverage of the test cases. This allows the make(1) utility to change the
# implementation of this estimate.
#
# The current implementation (primitively) estimates the test coverage buy
# assuming a one to one relation ship between lines of source code and lines of
# test code, and so reports coverage as the percentage of test code to source
# code.
#
# NOTE: This is a __very__ bad estimation strategy, however, due to the custom
# nature of the unit tests and the broad possible scope of coverage, there isn't
# an (easy) way of estimating test coverage right now, so this will have to do
# as an indicator of needing to write more test cases when the source code
# starts to grow faster.
CODE_LINE_COUNT := cat *.c | wc -l
TEST_LINE_COUNT := cat tests/*.c | wc -l
COVERAGE_CMD    := awk 'BEGIN { print '"$$(${TEST_LINE_COUNT})"'/'"$$(${CODE_LINE_COUNT})"'* 100 "%" }'
TEST_COVERAGE   := $$(${COVERAGE_CMD})

# }}}

