/**
 * Define needed macros and symbols, globally accessible preprocessor file.
 */

#ifndef DEFINES_H
#define DEFINES_H

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

#endif

