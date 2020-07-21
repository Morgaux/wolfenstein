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

/* DEFINE COLOUR MACROS {{{ */

#define RESET   "\033[0m"
#define BOLD    "\033[1m"
#define BLACK   "\033[30m"
#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define YELLOW  "\033[33m"
#define BLUE    "\033[34m"
#define MAGENTA "\033[35m"
#define CYAN    "\033[36m"
#define WHITE   "\033[37m"

/* }}} */

#endif

