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
	__YELLOW__
	fprintf(stderr, "warning");
	__RESET__
	fprintf(stderr, ": %s\n", msg);
} /* }}} */

PRIVATE void fail(char * msg) { /* {{{ */
	__RED__
	fprintf(stderr, "FAILURE");
	__RESET__
	fprintf(stderr, ": %s\n", msg);
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
	RenderConfig config = {
		.cameraPosX           = 0,
		.cameraPosY           = 0,
		.cameraResX           = 100,
		.cameraResY           = 100,
		.cameraStartHeight    = 2,
		.cameraStartDirection = 0,
		.cameraViewDistance   = 40,
		.mapWidth             = 100,
		.mapHeight            = 100,
		.frameWidth           = 100,
		.frameHeight          = 100,
	};

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
	warn("testing rendering.PlaceWall(uint64_t x, uint64_t y, int64_t dx, int64_t dy, Texture texture)...");

	warn("Setting up dummy texture...");
	int textureW = 1;
	int textureH = 1;
	Pixel * pixels = malloc(sizeof (Pixel) * textureW * textureH);

	for (int i = 0; i < textureW * textureH; i++) {
		/* Set all of the pixels to a red '@' */
		(*pixels).r     = 0xFF;
		(*pixels).g     = 0x00;
		(*pixels).b     = 0x00;
		(*pixels).ascii = '@';
	}

	Texture texture = {
		.width  = textureW,
		.height = textureH,
		.pixels = pixels
	};

	warn("testing single point wall...");
	int x  = 0;
	int y  = 0;
	int dx = 1;
	int dy = 1;
	PlaceWall(x, y, dx, dy, texture);
	assert(GetSquare(x, y).pixels == pixels,                "Incorrect pixels in wall.");
	assert(GetSquare(x + dx, y).pixels != pixels,           "Wall exceeds given dimensions.");
	assert(GetSquare(x, y + dy + dx).pixels != pixels,      "Wall exceeds given dimensions.");
	assert(GetSquare(x + dx, y + dy + dx).pixels != pixels, "Wall exceeds given dimensions.");

	warn("testing horizontal (x axis) wall...");

	warn("testing vertical (y axis) wall...");

	warn("testing diagonal (45 degrees, north east) wall...");

	warn("testing angled (27.5 degrees, north east) wall...");
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

