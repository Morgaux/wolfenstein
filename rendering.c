/**
 * Source file for the rendering module of wolfenstein3D
 */

/* DEFINES {{{ */

#include "defines.h"

/**
 * Define the current source file, this allows the
 * header file of this module to know that it has
 * been included in it's own module's source, as well
 * allowing the header files for any other modules to
 * know that they are being included in a different
 * module and making any necessary changes.
 */
#define RENDERING_C

/* DEFINE RAYCASTLIB SYMBOLS {{{ */

/**
 * Tell raycastlib the name of the function with
 * which we write pixels to the screen.
 */
#define RCL_PIXEL_FUNCTION RenderPixel

/**
 * Turn off what we don't need, to improve performance.
 */
#define RCL_COMPUTE_FLOOR_DEPTH   0
#define RCL_COMPUTE_CEILING_DEPTH 0

/* }}} */

/* }}} */

/* INCLUDES {{{ */

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Include the raycastlib library for the rendering
 * backend. This library is pulled and installed to
 * the local build directory via git(1), and this
 * repo dir is passed to the compiler via the -I flag
 * to allow it to be included via <...> syntax rather
 * than "..." syntax.
 */
#include <raycastlib.h>

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "rendering.h"

/* }}} */

/* PUBLIC FUNCTIONS {{{ */

PUBLIC int64_t ConfigureRendering(RenderConfig config) { /* {{{ */
	RCL_initCamera(&camera);

	camera.position.x   = config.cameraPosX;
	camera.position.y   = config.cameraPosY;
	camera.resolution.x = config.cameraResX;
	camera.resolution.y = config.cameraResY;
	camera.direction    = config.cameraStartDirection;
	camera.height       = config.cameraStartHeight;

	RCL_initRayConstraints(&constraints);

	constraints.maxHits  = 1; // we don't need more than 1 hit here
	constraints.maxSteps = config.cameraViewDistance;

	CreateMap(config.mapWidth, config.mapHeight);

	CreateFrame(config.frameWidth, config.frameHeight);

	return 0;
} /* }}} */

PUBLIC Square GetSquare(uint64_t x, uint64_t y) { /* {{{ */
	Square square;

	return square;
} /* }}} */

PUBLIC void SetSquare(uint64_t x, uint64_t y, Square square) { /* {{{ */
} /* }}} */

PUBLIC void PlaceWall(uint64_t x, uint64_t y, int64_t dx, int64_t dy, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void PlaceRectangularRoom(uint64_t x, uint64_t y, int64_t dx, int64_t dy, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void PlaceCircularRoom(uint64_t x, uint64_t y, uint64_t r, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void Render(uint64_t width, uint64_t length) { /* {{{ */
} /* }}} */

PUBLIC void Turn(int64_t angle) { /* {{{ */
	camera.direction += angle;
} /* }}} */

PUBLIC void Walk(int64_t distance) { /* {{{ */
} /* }}} */

PUBLIC void Strafe(int64_t distance) { /* {{{ */
} /* }}} */

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

PRIVATE int64_t CreateMap(uint64_t width, uint64_t length) { /* {{{ */
	return 0;
} /* }}} */

PRIVATE int64_t CreateFrame(uint64_t width, uint64_t length) { /* {{{ */
	return 0;
} /* }}} */

PRIVATE Pixel GetPixel(uint64_t x, uint64_t y) { /* {{{ */
	Pixel pixel;

	return pixel;
} /* }}} */

PRIVATE void SetPixel(uint64_t x, uint64_t y, Pixel pixel) { /* {{{ */
} /* }}} */

/* }}} */

/* FUNCTIONS FOR RAYCASTLIB {{{ */
/**
 * The raycastlib library requires some code to be
 * written by it's user, in this case this module, to
 * act as a sort of callback function.
 */

/**
 * This function is used internally by the backend
 * raycastlib library and it called for every pixel
 * it renders, here we use it to transfer the
 * raycastlib pixel struct data to a rendering pixel
 * struct variable and using that pixel struct within
 * this module.
 */
void RenderPixel(RCL_PixelInfo* pixel) { /* {{{ */
	static const char asciiShades[] = "HXi/:;.              ";

	char c;
	uint8_t shade = 3 - RCL_min(3, pixel->depth / RCL_UNITS_PER_SQUARE);

	if (pixel->isWall) {
		switch (pixel->hit.direction) {
		case 0:
			shade += 2;
		case 1:
			c = asciiShades[shade];
			break;
		case 2:
			c = 'o';
			break;
		case 3:
		default:
			c = '.';
			break;
		}
	} else {
		c = pixel->isFloor ? '.' : ':';
	}

	Pixel ourPixel;

	ourPixel.r = 0xff;
	ourPixel.g = 0xff;
	ourPixel.b = 0xff;
	ourPixel.ascii = c;

	SetPixel(pixel->position.x, pixel->position.y, ourPixel);
} /* }}} */

/* }}} */

