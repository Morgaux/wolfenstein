/**
 * Header file for wolfenstein3D.c
 */

/* RAYCASTLIB DEFINITIONS {{{ */

/**
 * Tell raycastlib the name of the function with which we write pixels to the
 * screen.
 */
#define RCL_PIXEL_FUNCTION pixelFunc

/**
 * Turn off what we don't need, to improve performance.
 */
#define RCL_COMPUTE_FLOOR_DEPTH   0
#define RCL_COMPUTE_CEILING_DEPTH 0

/**
 * Define screen dimensions.
 */
#define SCREEN_W 80
#define SCREEN_H 40
#define PIXELS_TOTAL ((SCREEN_W + 1) * SCREEN_H + 1)

/* }}} */

/**
 * Define screen size accounting for terminating NULL and \n characters.
 */
char screen[(SCREEN_W + 1) * SCREEN_H + 1];

int main(int argc, char ** argv);

