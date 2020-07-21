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

#define STDOUT(x) fprintf(stdout, x);
#define STDERR(x) fprintf(stderr, x);
#define STDALL(x) STDOUT(x) STDERR(x)

#define __RESET__   STDALL("\033[0m")
#define __BOLD__    STDALL("\033[1m")
#define __BLACK__   STDALL("\033[30m")
#define __RED__     STDALL("\033[31m")
#define __GREEN__   STDALL("\033[32m")
#define __YELLOW__  STDALL("\033[33m")
#define __BLUE__    STDALL("\033[34m")
#define __MAGENTA__ STDALL("\033[35m")
#define __CYAN__    STDALL("\033[36m")
#define __WHITE__   STDALL("\033[37m")

/* }}} */

#endif

