/**
 * Header file for rendering.c
 */

/* PREVENT REEVALUATION {{{ */
#ifndef TESTS_RENDERING_H
#define TESTS_RENDERING_H

/**
 * As the unit tests are special modules that contain
 * main function, all of the functions here should be
 * static, aka PRIVATE. So in contrast to the module
 * sources, the test sources don't need the PRIVATE
 * and PUBLIC macros to be defined with any
 * conditional logic.
 */
#undef PRIVATE
#undef PUBLIC
#define PRIVATE static
#define PUBLIC

/* PUBLIC FUNCTIONS {{{ */

PUBLIC int main(void);

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

PRIVATE void TestConfigureRendering(void);

PRIVATE void TestGetSetSquare(void);

PRIVATE void TestPlaceWall(void);

PRIVATE void TestPlaceRectangularRoom(void);

PRIVATE void TestPlaceCircularRoom(void);

PRIVATE void TestRender(void);

PRIVATE void TestTurn(void);

PRIVATE void TestWalk(void);

PRIVATE void TestStrafe(void);

/* }}} */

#endif /* TESTS_RENDERING_H */
/* }}} */

