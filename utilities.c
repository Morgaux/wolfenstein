/**
 * utilities.c source module of wolfenstein3D
 *
 * @AUTHOR:      Morgaux Meyer
 * @DESCRIPTION: [update manually]
 */

/* DEFINES {{{ */

#include "defines.h"

/**
 * Define the current source file, this allows the
 * header file of this module to know that it has
 * been included in it's own module's source, as well
 * allowing the header files for any other modules to
 * know that they are being included in a different
 * module and making any necessary changes.
 */
#define UTILITIES_C

/* }}} */

/* INCLUDES {{{ */

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "utilities.h"

/* }}} */

/* PUBLIC FUNCTIONS {{{ */

public void err(const char * msg) {
	fprintf(stderr, "%s\n", msg);
}

public void die(const char * msg) {
	err(msg);
	exit((errno == 0) ? 1 : errno);
}

public void freeMem(void ** ptr) {
	if (ptr != NULL && *ptr != NULL) {
		free(*ptr);
		*ptr = NULL;
	}
}

/* }}} */

/* PRIVATE FUNCTIONS {{{ */


/* }}} */

/* MAIN FUNCTION {{{ */
/**
 * Here we check if the current module is set as the
 * BIN value, which indicates that that module's main
 * function should be used as the main function for
 * resulting executable being built.
 */
#ifdef utilities_main

/**
 * Include the test source for this module, the tests
 * may only be called by the main function so we only
 * want them when the main function will also be
 * included. So it is included within this '#ifdef'.
 */

#include "tests/utilities.c"

public int main(void);
public int main() { /* {{{ */
	TestErr();

	TestDie();

	TestFreeMem();

	/* If reached then all the tests must have passed */
	printf("%s\n", "All tests complete.");
	exit(EXIT_SUCCESS);
} /* }}} */

#endif /* utilities_main */
/* }}} */

