/**
 * Source file for testing the rendering.c module
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
#define TESTS_RENDERING_C

/* }}} */

/* INCLUDES {{{ */

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdio.h>
#include <stdlib.h>

/**
 * Include the header file for the module this file
 * is testing, this allows this source to call that
 * modules (PUBLIC) functions.
 */
#include "../rendering.h"

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "rendering.h"

/* }}} */

/* PUBLIC FUNCTIONS {{{ */

PUBLIC int main() { /* {{{ */
	fail("Not implemented.");

	exit(EXIT_SUCCESS);
} /* }}} */

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

PRIVATE void warn(char * msg) { /* {{{ */
	fprintf(stderr, "%s\n", msg);
} /* }}} */

PRIVATE void fail(char * msg) { /* {{{ */
	warn(msg);
	exit(EXIT_FAILURE);
} /* }}} */

PRIVATE void assert(int cond, char * msg) { /* {{{ */
	if (!cond) {
		fail(msg);
	}
} /* }}} */

/* }}} */

