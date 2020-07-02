/**
 * Configuration file for __BIN__
 *
 * AUTHOR: Morgaux Meyer
 */

#ifndef CONFIG_H
#define CONFIG_H

/* DEFINE NEEDED SYMBOLS IF MISSING {{{ */

/**
 * Make sure that the VERSION is defined
 */
#ifndef VERSION
#define VERSION "__VERSION__"
#endif

/**
 * Make sure that the FLAVOUR is defined, must be RELEASE, CURRENT, or DEBUG
 */
#ifndef RELEASE
#ifndef CURRENT
#ifndef DEBUG
#error "The `FLAVOUR` of the __BIN__ build must be defined."
#endif
#endif
#endif

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

#endif

