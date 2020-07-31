#
#
# This file defines the main test configuration and execution order
#

# TEST CONFIG {{{

# This variable defines all test case names, for each test case a matching
# 'run_test_FOO' and 'test_FOO_help_message' target must be specified, to
# provide the implementation and description of the given test case. The
# implementations should fail gracefully on any error, display an error message
# and clean up any temporary files created to allow a clean workspace for the
# next test in the queue. Note that values in ${TEST_ACTIONS} shouldn't conflict
# with other build targets.
TEST_ACTIONS := ${PHONIES} \
                ${DRUMMY_FISH_LIBS} \
                ${MODULES} \
                ${WOLF_3D:%=%_no_warnings} \
                ${COMPILERS}

# }}}

