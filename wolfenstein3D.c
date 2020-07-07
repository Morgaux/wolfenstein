/**
 * Main source file for my Wolfenstein 3D clone
 */

/**
 * Include config.h, this should be done first, before any other includes or
 * definitions. This allows for the user configurable settings to be accessible
 * to the local code and headers.
 */
#include "config.h"

/**
 * Include any external libraries and system headers here, in order.
 */
#include <unistd.h>

/**
 * Include definitions and prototypes for main wolfenstein3D.c source. This
 * should be the last file included as it preforms the last definitions for this
 * source file.
 */
#include "wolfenstein3D.h"

/**
 * Main function and entry point
 */
int main(int argc, char ** argv) { /* {{{ */
	return initialize_rendering();
} /* }}} */

