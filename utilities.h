/**
 * utilities.h header for utilities.c source module of wolfenstein3D
 *
 * @AUTHOR:      Morgaux Meyer
 * @DESCRIPTION: [update manually]
 */

/* PREVENT REEVALUATION {{{ */
#ifndef UTILITIES_H
#define UTILITIES_H

/* DETERMINE SCOPE OF SYMBOLS {{{ */
/**
 * The way we control the access level of a function
 * or variable in C is via the use of the static and
 * extern keywords. However, contrary to the use of
 * the private and public keywords, the declaration
 * of a function in C must vary for use in the same
 * source as the declaration and use in an externally
 * linked object file. To allow a single function
 * declaration to function for both internal and
 * external use, here the public and private symbols
 * are defined depending on whether this header is
 * included in the module of the same name (this is
 * determined via the '#ifdef' preprocessor, as all
 * modules define a symbol of their name).
 *
 * Here, if the source file including this header is
 * part of the same module, then the private symbol
 * defined as the static key word, allowing functions
 * declared as 'private void foo();' to be expanded
 * as 'static void foo();'. However, if the file is
 * not part of the same module, public is defined as
 * the extern keyword, which allows for the functions
 * available to the other module to be accessed. In
 * each case the other symbol is defined as NO_OP, a
 * non-action which is defined in defines.h and this
 * allows a public function to skip using the  extern
 * keyword when used within the same module.
 *
 * NOTE: private functions should be hidden from the
 * other modules to prevent any conflicts with other
 * functions in that module. They should instead be
 * wrapped in another #ifdef block below.
 */
#undef public
#undef private

#define private static

#ifdef UTILITIES_C
#define public
#else
#define public extern
#endif
/* }}} */

/* PUBLICS {{{ */
/**
 * All data structures and function definitions that
 * need to be available to other functions should be
 * provided here with the public keyword.
 */

public void err(const char *);

public void die(const char *);

public void freeMem(void **);

/* }}} */

/* PRIVATES {{{ */
/**
 * All data structures and function definitions that
 * need to be limited to the current module should be
 * provided within the #ifdef...#endif block below,
 * with the private keyword.
 */
#ifdef UTILITIES_C


#endif
/* }}} */

#endif /* UTILITIES_H */
/* }}} */

