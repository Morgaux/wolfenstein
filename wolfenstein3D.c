/**
 * Main source file for my Wolfenstein 3D clone
 * TODO: implement everything
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
#include <stdio.h>

/**
 * Include definitions and prototypes for main wolfenstein3D.c source.
 */
#include "wolfenstein3D.h"

int main(int argc, char ** argv) {
	printf("VERSION=%s\n", VERSION);
#ifdef DEBUG
	printf("DEBUG=%d\n", DEBUG);
#endif
	return 0;
}

