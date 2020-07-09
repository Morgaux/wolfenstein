/**
 * Source file for the rendering module of wolfenstein3D
 */

#include "defines.h"

/**
 * Define the current source file, this allows the
 * header file of this module to know that it has
 * been included in it's own module's source, as well
 * allowing the header files for any other modules to
 * know that they are being included in a different
 * module and making any necessary changes.
 */
#define RENDERING_C

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "rendering.h"

/**
 * TODO: Provide function implementations here.
 *
 * This is a dummy function to allow compilation to
 * succeed, remove the declaration and function body
 * once proper functions are added.
 */
PRIVATE void dummy() { /* {{{ */
	printf("Hello World!\n");
} /* }}} */

