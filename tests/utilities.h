/**
 * Header file for utilities.c
 */

/* PREVENT REEVALUATION {{{ */
#ifndef TESTS_UTILITIES_H
#define TESTS_UTILITIES_H

/**
 * As the unit tests are special modules that contain
 * main function, all of the functions here should be
 * static, aka PRIVATE. So in contrast to the module
 * sources, the test sources don't need the PRIVATE
 * and PUBLIC macros to be defined with any
 * conditional logic.
 */
#undef PRIVATE
#undef PUBLIC
#define PRIVATE static
#define PUBLIC

/* PUBLIC FUNCTIONS {{{ */

PUBLIC int main();

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

PRIVATE void warn(char * msg);

PRIVATE void fail(char * msg);

PRIVATE void assert(int cond, char * msg);

PRIVATE void TestErr();

PRIVATE void TestDie();

PRIVATE void TestFreeMem();

/* }}} */

#endif /* TESTS_UTILITIES_H */
/* }}} */

