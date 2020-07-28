/**
 * tests/wolfenstein3D.c source for testing the module of wolfenstein3D
 *
 * @AUTHOR:      Morgaux Meyer
 * @DESCRIPTION: [update manually]
 */

/* PREVENT REEVALUATION {{{ */
/**
 * Since the test source files are merely included in
 * other sources rather than directly compiled, it is
 * necessary to prevent duplicate inclusions.
 *
 * NOTE: For the above reasons it is also superfluous
 * to use the PRIVATE and PUBLIC macros, although if
 * these were to be used the would still work within
 * the parent module's scope. In their stead the TEST
 * macro is defined here to A) explicitly mark which
 * functions are testcases, similarly to the @Test
 * annotation in languages such as Java, and B) for
 * testcase functions to be clearly distinct from any
 * PRIVATE helpers that are defined here for the test
 * functions (and only those functions) to use.
 */

#ifndef TESTS_WOLFENSTEIN3D_C
#define TESTS_WOLFENSTEIN3D_C
#undef  TEST
#define TEST static

/* DEFINES {{{ */

#include "../defines.h"

/* }}} */

/* INCLUDES {{{ */

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdio.h>
#include <stdlib.h>

/**
 * Include the main unit test header file. This file
 * provides general functions for assertion, handling
 * errors, and test related IO.
 */
#include "tests.h"

/* }}} */

/* TEST FUNCTIONS {{{ */


/* }}} */

#endif /* TESTS_WOLFENSTEIN3D_C */
/* }}} */

