/**
 * Header file for unit tests, provides generic assertion methods.
 */

/* PREVENT REEVALUATION {{{ */
#ifndef TESTS_H
#define TESTS_H

/* TEST FUNCTION DECLARATIONS {{{ */

static void warn(const char *);

static void fail(const char *);

static void assert(int, const char *);

/* }}} */

/* TEST FUNCTION IMPLEMENTATIONS {{{ */

static void warn(const char * msg) { /* {{{ */
	fprintf(stderr, "%swarning%s: %s\n", YELLOW, RESET, msg);
} /* }}} */

static void fail(const char * msg) { /* {{{ */
	fprintf(stderr, "%sFAILURE%s: %s\n", RED, RESET, msg);
	exit(EXIT_FAILURE);
} /* }}} */

static void assert(int cond, const char * msg) { /* {{{ */
	if (!cond) {
		fail(msg);
	}
} /* }}} */

/* }}} */

#endif /* TESTS_H */
/* }}} */

