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

/* PRAGMA WRAPPERS {{{ */
/**
 * This section defines _Pragma() macro wrappers (in a compiler) portable way to
 * allow for the source to be mostly readable and simple to write. Currently
 * only GCC and clang are explicitly checked for, but theoretically any compiler
 * could be checked for.
 *
 * The macros are as follows:
 *
 * - TODO(msg): the 'msg' param should be a string literal and should be
 *   displayed as a compilation message (i.e. not a warning or error) and should
 *   ideally print the line number if possible. This allows for easily marking a
 *   piece of code as a TODO both visually (like a comment) but also as a
 *   compilation stage reminder.
 *
 * - WARN(msg): the 'msg' param should be a string literal to be given as a
 *   compiler warning, further this has the benefit of allowing specific
 *   conditions to trigger the message, such as on certain operating systems or
 *   compilers.
 *
 *   e.g.: WARN("OpenBSD supports strlcpy(), use instead of strcpy")
 *
 * - ERRO(msg): the 'msg' param should be a string literal to be given as a
 *   compiler error. As with WARN, this allows an easy way crying out and
 *   halting the build if a red flag is raised.
 *
 * - PUSH_DIAGNOSTIC(flag): the 'flag' param should be a string literal that
 *   defines a '-W<foo>' compiler warning (or error) to be ignored until a
 *   matching POP_DIAGNOSTIC(flag) macro is called.
 *
 * - POP_DIAGNOSTIC(flag): the 'flag' param should be a string literal that
 *   matches the previous call to PUSH_DIAGNOSTIC(flag).
 */

/* This little helper encapsulates the _Pragma call */
#define DO_PRAGMA(x) _Pragma(#x)

/* GCC MACRO IMPLEMENTATIONS {{{ */
#ifdef __GNUC__

/**
 * Define the above macros for the GNU Compiler here:
 */
#define TODO(msg)             DO_PRAGMA(message("TODO - " # msg))
#define WARN(msg)             DO_PRAGMA(GCC warning msg)
#define ERRO(msg)             DO_PRAGMA(GCC error msg)
#define PUSH_DIAGNOSTIC(flag) DO_PRAGMA(message("Ignoring warning: " # flag))  \
                              DO_PRAGMA(GCC diagnostic push)                   \
                              DO_PRAGMA(GCC diagnostic ignored flag)
#define POP_DIAGNOSTIC(flag)  DO_PRAGMA(message("Restoring warning: " # flag)) \
                              DO_PRAGMA(GCC diagnostic pop)

#else
/* }}} */

/* CLANG MACRO IMPLEMENTATIONS {{{ */
#ifdef __clang__

/**
 * Define the above macros for the CLANG/LLVM Compiler here:
 */
#define TODO(msg)             DO_PRAGMA(message("TODO - " # msg))
#define WARN(msg)             DO_PRAGMA(GCC warning msg)
#define ERRO(msg)             DO_PRAGMA(GCC error msg)
#define PUSH_DIAGNOSTIC(flag) DO_PRAGMA(message("Ignoring warning: " # flag))  \
                              DO_PRAGMA(clang diagnostic push)                 \
                              DO_PRAGMA(clang diagnostic ignored flag)
#define POP_DIAGNOSTIC(flag)  DO_PRAGMA(message("Restoring warning: " # flag)) \
                              DO_PRAGMA(clang diagnostic pop)

#else
/* }}} */

/* FALLBACK MACRO IMPLEMENTATIONS {{{ */

/**
 * Define the macros as empty to allow compilation on other compilers, if needed
 * more implementations may be added for the missing compilers, e.g. if you
 * __really__ need to compile on Solaris or whatever.
 */
#define TODO(msg)             do { } while (0)
#define WARN(msg)             do { } while (0)
#define ERRO(msg)             do { } while (0)
#define PUSH_DIAGNOSTIC(flag) do { } while (0)
#define POP_DIAGNOSTIC(flag)  do { } while (0)

#endif
#endif
/* }}} */

/* }}} */

#endif

