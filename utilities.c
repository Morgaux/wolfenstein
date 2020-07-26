/**
 * Source file for the utilities module of wolfenstein3D
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

PUBLIC void err(const char * msg) {
	fprintf(stderr, "%s\n", msg);
}

PUBLIC void die(const char * msg) {
	err(msg);
	exit((errno == 0) ? 1 : errno);
}

PUBLIC void freeMem(void ** ptr) {
	if (ptr != NULL && *ptr != NULL) {
		free(*ptr);
		*ptr = NULL;
	}
}

/* }}} */

/* PRIVATE FUNCTIONS {{{ */


/* }}} */

