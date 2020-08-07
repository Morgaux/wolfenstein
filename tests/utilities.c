/**
 * tests/utilities.c source for testing the module of wolfenstein3D
 *
 * @AUTHOR:      Morgaux Meyer
 * @DESCRIPTION: [update manually]
 */

/* PREVENT REEVALUATION {{{ */
/**
 * Since the test source files are merely included in
 * other sources rather than directly compiled, it is
 * necessary to prevent duplicate inclusions.
 *
 * NOTE: For the above reasons it is also superfluous
 * to use the PRIVATE and PUBLIC macros, although if
 * these were to be used the would still work within
 * the parent module's scope. In their stead the TEST
 * macro is defined here to A) explicitly mark which
 * functions are testcases, similarly to the @Test
 * annotation in languages such as Java, and B) for
 * testcase functions to be clearly distinct from any
 * PRIVATE helpers that are defined here for the test
 * functions (and only those functions) to use.
 */

#ifndef TESTS_UTILITIES_C
#define TESTS_UTILITIES_C

/* DEFINES {{{ */

#include "../defines.h"

/* }}} */

/* INCLUDES {{{ */

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Ensure that the test cases have access to the data
 * and functions in the module. This is redundant if
 * these test cases are pulled into the source file
 * the module this test case is for, however, as a
 * fallback, in the event that the testcases are used
 * in a different module, or for error checking in a
 * text editor.
 */
#ifndef UTILITIES_C
#include "../utilities.h"
#endif /* UTILITIES_C */

/**
 * Include the main unit test header file. This file
 * provides general functions for assertion, handling
 * errors, and test related IO.
 */
#include "tests.h"

/* }}} */

/* TEST FUNCTIONS {{{ */

TEST(TestErr) { /* {{{ */
	warn("utilities.err(char * msg) cannot be tested.");
} /* }}} */

TEST(TestDie) { /* {{{ */
	warn("utilities.die(char * msg) cannot be tested.");
} /* }}} */

TEST(TestFreeMem) { /* {{{ */
	char * foo;
	int predicate;

	warn("testing utilities.freeMem(void ** ptr)...");
	foo = (char *)malloc(sizeof (char) * 128);

	strcpy(foo, "Hello World!\n");
	predicate = strcmp(foo, "Hello World!\n");
	assert(predicate == 0, "Test string is invalid.");

	freeMem((void **)&foo); /* Call utilities.freeMem(void ** ptr) */
	assert(foo == NULL, "String pointer was not reset to null.");
} /* }}} */

/* }}} */

#endif /* TESTS_UTILITIES_C */
/* }}} */

