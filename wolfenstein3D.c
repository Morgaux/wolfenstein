/**
 * Source file for the wolfenstein3D module of wolfenstein3D
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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/**
 * This module provides an abstraction over the lower
 * level mathematics and complexities of the backend
 * libraries used. It has been compiled separately
 * and will be linked together with this source file,
 * to allow it's functions to be accessed, include
 * it's headerfile here.
 */
#include "rendering.h"

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "wolfenstein3D.h"

/* }}} */

/**
 * Main entry point
 */
int main() { /* {{{ */
	printf("Hello World!\n");
	return 0;
} /* }}} */

