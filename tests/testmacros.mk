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

# }}}

