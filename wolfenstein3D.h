/**
 * Header file for wolfenstein3D.c
 */

#ifndef WOLFENSTEIN3D_H
#define WOLFENSTEIN3D_H

/* DEFINE NEEDED SYMBOLS IF MISSING {{{ */

/**
 * Make sure that the VERSION is defined
 */
#ifndef VERSION
#define VERSION "0.0.0"
#endif

/**
 * Make sure that the FLAVOUR is defined, must be RELEASE, CURRENT, or DEBUG
 */
#ifndef RELEASE
#ifndef CURRENT
#ifndef DEBUG
#define DEBUG
#endif
#endif
#endif

/* }}} */

/* GLOBAL VARS {{{ */

/**
 * Define screen size accounting for terminating NULL and \n characters.
 */
char screen[(SCREEN_W + 1) * SCREEN_H + 1];

/**
 * Define the map as a 1D array of bytes, here we'll use 1 as a wall and 0 as an
 * empty space. Note it must match the dimensions given in MAP_W and MAP_H.
 */
int map[MAP_W * MAP_H] = {
	0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,
	1,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,1,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,
	1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,
	0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,
	0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,1,
	0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,
	0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,1,0,0,1,
	0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,0,1,0,0,0,1,1,1,0,0,1,0,0,0,0,0,
	0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0
};

/* }}} */

/* FUNCTION DECLARATIONS {{{ */

/**
 * External functions and values, these are used within this module, but defined
 * and implemented within a different module.
 */
extern int initialize_rendering();

/**
 * Static functions, these are private to this module.
 */

/**
 * Global functions, these are non static and accessible to other modules.
 */
int main(int argc, char ** argv);

/* }}} */

#endif

