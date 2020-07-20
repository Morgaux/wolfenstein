/**
 * Source file for testing the rendering.c module
 */

/* DEFINES {{{ */

#include "../defines.h"

/**
 * Define the current source file, this allows the
 * header file of this module to know that it has
 * been included in it's own module's source, as well
 * allowing the header files for any other modules to
 * know that they are being included in a different
 * module and making any necessary changes.
 */
#define TESTS_RENDERING_C

/* }}} */

/* INCLUDES {{{ */

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/**
 * Include the header file for the module this file
 * is testing, this allows this source to call that
 * modules (PUBLIC) functions.
 */
#include "../rendering.h"

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "rendering.h"

/* }}} */

/* PUBLIC FUNCTIONS {{{ */

PUBLIC int main() { /* {{{ */
	TestConfigureRendering();

	TestGetSetSquare();

	TestConfigureRendering();

	TestGetSetSquare();

	TestPlaceWall();

	TestPlaceRectangularRoom();

	TestPlaceCircularRoom();

	TestRender();

	TestTurn();

	TestWalk();

	TestStrafe();

	/* If reached then all the tests must have passed */
	printf("%s\n", "All tests complete.");
	exit(EXIT_SUCCESS);
} /* }}} */

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

PRIVATE void warn(char * msg) { /* {{{ */
	fprintf(stderr, "warning: %s\n", msg);
} /* }}} */

PRIVATE void fail(char * msg) { /* {{{ */
	fprintf(stderr, "FAILURE: %s\n", msg);
	exit(EXIT_FAILURE);
} /* }}} */

PRIVATE void assert(int cond, char * msg) { /* {{{ */
	if (!cond) {
		fail(msg);
	}
} /* }}} */

PRIVATE void TestConfigureRendering() { /* {{{ */
	warn("testing rendering.ConfigureRendering(RenderConfig config)...");
	warn("there is no direct way to confirm this function's success, but");
	warn("it must be called for the rest of the module to work correctly.");
	warn("So if it does indeed fail then the rest of these tests will");
	warn("fail anyway.");

	warn("using testing configuration...");
	RenderConfig config;
	config.cameraPosX = 0;
	config.cameraPosY = 0;
	config.cameraResX = 100;
	config.cameraResY = 100;
	config.cameraStartHeight = 2;
	config.cameraStartDirection = 0;
	config.cameraViewDistance = 40;
	config.mapWidth = 100;
	config.mapHeight = 100;
	config.frameWidth = 100;
	config.frameHeight = 100;

	warn("calling rendering.ConfigureRendering(RenderConfig config)");
	ConfigureRendering(config);
} /* }}} */

PRIVATE void TestGetSetSquare() { /* {{{ */
	warn("testing rendering.GetSquare(uint64_t x, uint64_t y) and...");
	warn("testing rendering.SetSquare(uint64_t x, uint64_t y, Square square)...");

	warn("Setting up first square...");
	Square square;
	square.height = 2;
	square.pixels = malloc(sizeof (Pixel) * square.height);

	warn("Setting first square to (0, 0)...");
	SetSquare(0, 0, square);

	warn("Getting second square from (0, 0)...");
	Square newSqr = GetSquare(0, 0);

	assert(square.height == newSqr.height, "Square heights don't match.");
	assert(square.pixels == newSqr.pixels, "Square pixels don't match.");
} /* }}} */

PRIVATE void TestPlaceWall() { /* {{{ */
	warn("No testcases for rendering.PlaceWall(uint64_t x, uint64_t y, int64_t dx, int64_t dy, Texture texture).");
} /* }}} */

PRIVATE void TestPlaceRectangularRoom() { /* {{{ */
	warn("No testcases for rendering.PlaceRectangularRoom(uint64_t x, uint64_t y, int64_t dx, int64_t dy, Texture texture).");
} /* }}} */

PRIVATE void TestPlaceCircularRoom() { /* {{{ */
	warn("No testcases for rendering.PlaceCircularRoom(uint64_t x, uint64_t y, uint64_t r, Texture texture).");
} /* }}} */

PRIVATE void TestRender() { /* {{{ */
	warn("No testcases for rendering.Render(uint64_t width, uint64_t length).");
} /* }}} */

PRIVATE void TestTurn() { /* {{{ */
	warn("No testcases for rendering.Turn(int64_t angle).");
} /* }}} */

PRIVATE void TestWalk() { /* {{{ */
	warn("No testcases for rendering.Walk(int64_t distance).");
} /* }}} */

PRIVATE void TestStrafe() { /* {{{ */
	warn("No testcases for rendering.Strafe(int64_t distance).");
} /* }}} */

/* }}} */

