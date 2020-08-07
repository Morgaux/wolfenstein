/**
 * Header file for unit tests, provides generic assertion methods.
 */

/* PREVENT REEVALUATION {{{ */
#ifndef TESTS_H
#define TESTS_H

/* TEST HELPERS {{{ */

#define TEST(func) static void func (void); static void func ()

#define warn(msg) do { \
	fprintf(stderr, "%swarning%s: %s\n", YELLOW, RESET, msg); \
} while (0)

#define fail(msg) do { \
	fprintf(stderr, "%sFAILURE%s: %s\n", RED, RESET, msg); \
	exit(EXIT_FAILURE); \
} while (0)

#define pass(msg) do { \
	fprintf(stderr, "%sSUCCESS%s: %s\n", GREEN, RESET, msg); \
} while (0)

#define assert(cond, msg) do { \
	if (cond) { \
		pass("Assertion passes"); \
	} else { \
		fail(msg); \
	} \
} while (0)

/* }}} */

#endif /* TESTS_H */
/* }}} */

