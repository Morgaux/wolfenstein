/**
 * tests/rendering.c source for testing the module of wolfenstein3D
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

#ifndef TESTS_RENDERING_C
#define TESTS_RENDERING_C
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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/**
 * Ensure that the test cases have access to the data
 * and functions in the module. This is redundant if
 * these test cases are pulled into the source file
 * the module this test case is for, however, as a
 * fallback, in the event that the testcases are used
 * in a different module, or for error checking in a
 * text editor.
 */
#ifndef RENDERING_C
#include "../rendering.h"
#endif /* RENDERING_C */

/**
 * Include the main unit test header file. This file
 * provides general functions for assertion, handling
 * errors, and test related IO.
 */
#include "tests.h"

/* }}} */

/* TEST FUNCTIONS {{{ */

TEST void TestConfigureRendering(void);
TEST void TestConfigureRendering() { /* {{{ */
	RenderConfig config;

	warn("testing rendering.ConfigureRendering(RenderConfig config)...");
	warn("there is no direct way to confirm this function's success, but");
	warn("it must be called for the rest of the module to work correctly.");
	warn("So if it does indeed fail then the rest of these tests will");
	warn("fail anyway.");

	warn("using testing configuration...");
	config.cameraPosX           = 0;
	config.cameraPosY           = 0;
	config.cameraResX           = 100;
	config.cameraResY           = 100;
	config.cameraStartHeight    = 2;
	config.cameraStartDirection = 0;
	config.cameraViewDistance   = 40;
	config.mapWidth             = 100;
	config.mapHeight            = 100;
	config.frameWidth           = 100;
	config.frameHeight          = 100;

	warn("calling rendering.ConfigureRendering(RenderConfig config)");
	ConfigureRendering(config);

	assert(camera.position.x    == config.cameraPosX,           "");
	assert(camera.position.y    == config.cameraPosY,           "");
	assert(camera.resolution.x  == config.cameraResX,           "");
	assert(camera.resolution.y  == config.cameraResY,           "");
	assert(camera.direction     == config.cameraStartDirection, "");
	assert(camera.height        == config.cameraStartHeight,    "");
	assert(constraints.maxHits  == 1,                           "");
	assert(constraints.maxSteps == config.cameraViewDistance,   "");

	pass("rendering.ConfigureRendering(RenderConfig config) tests pass");
} /* }}} */

TEST void TestCreateMap(void);
TEST void TestCreateMap() { /* {{{ */
	int width  = map.width,
	    length = map.length;

	warn("testing rendering.CreateMap(int width, int length)...");
	mapCreatedSuccess = recreate;

	warn("calling rendering.CreateMap(int width, int length)");
	assert(CreateMap(width, length) == initialised, "Failure to initialize map");
	assert(map.width                == width,       "Map width is incorrect");
	assert(map.length               == length,      "Map length is Incorrect");

	pass("rendering.CreateMap(int width, int length) tests pass");
} /* }}} */

TEST void TestCreateFrame(void);
TEST void TestCreateFrame() { /* {{{ */
	int width  = frame.width,
	    height = frame.height;

	warn("testing rendering.CreateFrame(int width, int height)...");
	frameCreatedSuccess = recreate;

	warn("calling rendering.CreateFrame(int width, int height)");
	assert(CreateFrame(width, height) == initialised, "Failure to initialize frame");
	assert(frame.width                == width,       "Frame width is incorrect");
	assert(frame.height               == height,      "Frame length is Incorrect");

	pass("rendering.CreateFrame(int width, int height) tests pass");
} /* }}} */

TEST void TestGetSetSquare(void);
TEST void TestGetSetSquare() { /* {{{ */
	Square square, newSqr;

	warn("testing rendering.GetSquare(int x, int y) and...");
	warn("testing rendering.SetSquare(int x, int y, Square square)...");

	warn("Setting up first square...");
	square.height = 2;
	square.pixels = (Pixel *)malloc(sizeof (Pixel) * (size_t)square.height);

	warn("Setting first square to (0, 0)...");
	SetSquare(0, 0, square);

	warn("Getting second square from (0, 0)...");
	newSqr = GetSquare(0, 0);

	assert(square.height == newSqr.height, "Square heights don't match.");
	assert(square.pixels == newSqr.pixels, "Square pixels don't match.");
} /* }}} */

TEST void TestPlaceWall(void);
TEST void TestPlaceWall() { /* {{{ */
	int textureW = 1,
	    textureH = 1,
	    x        = 0,
	    y        = 0,
	    dx       = 1,
	    dy       = 1;
	Pixel * pixels;
	Texture texture;

	warn("testing rendering.PlaceWall(uint64_t x, uint64_t y, int64_t dx, int64_t dy, Texture texture)...");

	warn("Setting up dummy texture...");
	pixels = (Pixel *)malloc(sizeof (Pixel) * (size_t)(textureW * textureH));

	for (int i = 0; i < textureW * textureH; i++) {
		/* Set all of the pixels to a red '@' */
		(pixels + i)->r     = 0xFF;
		(pixels + i)->g     = 0x00;
		(pixels + i)->b     = 0x00;
		(pixels + i)->ascii = '@';
	}

	texture.width  = textureW;
	texture.height = textureH;
	texture.pixels = pixels;

	warn("testing single point wall...");
	PlaceWall(x, y, dx, dy, texture);
	assert(GetSquare(x, y).pixels->ascii == pixels->ascii,  "Incorrect pixels in wall.");
	assert(GetSquare(x + dx, y).pixels != pixels,           "Wall exceeds given dimensions.");
	assert(GetSquare(x, y + dy + dx).pixels != pixels,      "Wall exceeds given dimensions.");
	assert(GetSquare(x + dx, y + dy + dx).pixels != pixels, "Wall exceeds given dimensions.");

	warn("testing horizontal (x axis) wall...");

	warn("testing vertical (y axis) wall...");

	warn("testing diagonal (45 degrees, north east) wall...");

	warn("testing angled (27.5 degrees, north east) wall...");
} /* }}} */

TEST void TestPlaceRectangularRoom(void);
TEST void TestPlaceRectangularRoom() { /* {{{ */
	warn("No testcases for rendering.PlaceRectangularRoom(uint64_t x, uint64_t y, int64_t dx, int64_t dy, Texture texture).");
} /* }}} */

TEST void TestPlaceCircularRoom(void);
TEST void TestPlaceCircularRoom() { /* {{{ */
	warn("No testcases for rendering.PlaceCircularRoom(uint64_t x, uint64_t y, uint64_t r, Texture texture).");
} /* }}} */

TEST void TestRender(void);
TEST void TestRender() { /* {{{ */
	warn("No testcases for rendering.Render(uint64_t width, uint64_t length).");
} /* }}} */

TEST void TestTurn(void);
TEST void TestTurn() { /* {{{ */
	warn("No testcases for rendering.Turn(int64_t angle).");
} /* }}} */

TEST void TestWalk(void);
TEST void TestWalk() { /* {{{ */
	warn("No testcases for rendering.Walk(int64_t distance).");
} /* }}} */

TEST void TestStrafe(void);
TEST void TestStrafe() { /* {{{ */
	warn("No testcases for rendering.Strafe(int64_t distance).");
} /* }}} */

/* }}} */

#endif /* TESTS_RENDERING_C */
/* }}} */

