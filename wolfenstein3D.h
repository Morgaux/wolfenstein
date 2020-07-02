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
#error "The `VERSION` of the wolfenstein3D build must be defined."
#endif

/**
 * Make sure that the FLAVOUR is defined, must be RELEASE, CURRENT, or DEBUG
 */
#ifndef RELEASE
#ifndef CURRENT
#ifndef DEBUG
#error "The `FLAVOUR` of the wolfenstein3D build must be defined."
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
const int8_t map[MAP_W * MAP_H] = {
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

/**
 * Define the camera to control the view of the space.
 */
RCL_Camera camera;

/**
 * This struct tell the library more details about how it should cast
 * each of the rays.
 */
RCL_RayConstraints constraints;

/* }}} */

/* FUNCTION DECLARATIONS {{{ */

static RCL_Unit heightAt(int16_t x, int16_t y);
static void draw();
void pixelFunc(RCL_PixelInfo *p);
int main(int argc, char ** argv);

/* }}} */

#endif

