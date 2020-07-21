/**
 * Header file for unit tests, provides generic assertion methods.
 */

/* PREVENT REEVALUATION {{{ */
#ifndef TESTS_H
#define TESTS_H

/* TEST FUNCTION DECLARATIONS {{{ */

void warn(const char * msg);

void fail(const char * msg);

void assert(int cond, const char * msg);

/* }}} */

/* TEST FUNCTION IMPLEMENTATIONS {{{ */

void warn(const char * msg) { /* {{{ */
	fprintf(stderr, "%swarning%s: %s\n", YELLOW, RESET, msg);
} /* }}} */

void fail(const char * msg) { /* {{{ */
	fprintf(stderr, "%sFAILURE%s: %s\n", RED, RESET, msg);
	exit(EXIT_FAILURE);
} /* }}} */

void assert(int cond, const char * msg) { /* {{{ */
	if (!cond) {
		fail(msg);
	}
} /* }}} */

/* }}} */

#endif /* TESTS_H */
/* }}} */

