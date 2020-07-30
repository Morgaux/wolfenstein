/**
 * wolfenstein3D.c source module of wolfenstein3D
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
#define WOLFENSTEIN3D_C

/* }}} */

/* INCLUDES {{{ */

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdio.h>

/**
 * Include any user configurations.
 */
#include "config.h"

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "wolfenstein3D.h"

/* }}} */

/* PUBLIC FUNCTIONS {{{ */

TODO("Implement the public functions for wolfenstein3D.c")

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

TODO("Implement the private functions for wolfenstein3D.c")

/* }}} */

/* MAIN FUNCTION {{{ */
/**
 * Here we check if the current module is set as the
 * BIN value, which indicates that that module's main
 * function should be used as the main function for
 * resulting executable being built.
 */
#ifdef wolfenstein3D_main

/**
 * Include the test source for this module, the tests
 * may only be called by the main function so we only
 * want them when the main function will also be
 * included. So it is included within this '#ifdef'.
 */

#include "tests/wolfenstein3D.c"

int main(void);
int main() { /* {{{ */
	printf("Hello World!\n");
	return 0;
} /* }}} */

#endif /* wolfenstein3D_main */
/* }}} */

