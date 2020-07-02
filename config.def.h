/**
 * Configuration file for __BIN__
 *
 * AUTHOR: Morgaux Meyer
 */

#ifndef CONFIG_H
#define CONFIG_H

/* DEFINE CONFIGURATION SYMBOLS {{{ */

/**
 * Define screen dimensions.
 */
#define SCREEN_W 80
#define SCREEN_H 40
#define PIXELS_TOTAL ((SCREEN_W + 1) * SCREEN_H + 1)

/**
 * Define map dimensions.
 */
#define MAP_W 15
#define MAP_H 20

/* }}} */

/* DEFINE RAYCASTLIB SYMBOLS {{{ */

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

/* }}} */

#endif

