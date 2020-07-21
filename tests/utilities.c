/**
 * Source file for testing the utilities.c module
 */

/* DEFINES {{{ */

#include "../defines.h"

/**
 * Define the current source file, this allows the
 * header file of this module to know that it has
 * been included in it's own module's source, as well
 * allowing the header files for any other modules to
 * know that they are being included in a different
 * module and making any necessary changes.
 */
#define TESTS_UTILITIES_C

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
 * Include the main unit test header file. This file
 * provides general functions for assertion, handling
 * errors, and test related IO.
 */
#include "tests.h"

/**
 * Include the header file for the module this file
 * is testing, this allows this source to call that
 * modules (PUBLIC) functions.
 */
#include "../utilities.h"

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "utilities.h"

/* }}} */

/* PUBLIC FUNCTIONS {{{ */

PUBLIC int main() { /* {{{ */
	TestErr();

	TestDie();

	TestFreeMem();

	/* If reached then all the tests must have passed */
	printf("%s\n", "All tests complete.");
	exit(EXIT_SUCCESS);
} /* }}} */

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

PRIVATE void TestErr() { /* {{{ */
	warn("utilities.err(char * msg) cannot be tested.");
} /* }}} */

PRIVATE void TestDie() { /* {{{ */
	warn("utilities.die(char * msg) cannot be tested.");
} /* }}} */

PRIVATE void TestFreeMem() { /* {{{ */
	warn("testing utilities.freeMem(void ** ptr)...");
	char * foo = malloc(sizeof (char) * 128);
	strcpy(foo, "Hello World!\n");
	int predicate = strcmp(foo, "Hello World!\n");
	assert(predicate == 0, "Test string is invalid.");
	freeMem((void **)&foo); /* Call utilities.freeMem(void ** ptr) */
	assert(foo == NULL, "String pointer was not reset to null.");
} /* }}} */

/* }}} */

