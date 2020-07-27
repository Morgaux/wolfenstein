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
PUSH_DIAGNOSTIC("-Wconversion")
PUSH_DIAGNOSTIC("-Wdeclaration-after-statement")
PUSH_DIAGNOSTIC("-Wmissing-prototypes")
PUSH_DIAGNOSTIC("-Wsign-conversion")
PUSH_DIAGNOSTIC("-Wtraditional")
PUSH_DIAGNOSTIC("-Wtraditional-conversion")
TODO("Create a Pull Request to fix raycastlib.h warnings")
#include <raycastlib.h>
POP_DIAGNOSTIC("-Wtraditional-conversion")
POP_DIAGNOSTIC("-Wtraditional")
POP_DIAGNOSTIC("-Wsign-conversion")
POP_DIAGNOSTIC("-Wmissing-prototypes")
POP_DIAGNOSTIC("-Wdeclaration-after-statement")
POP_DIAGNOSTIC("-Wconversion")

/**
 * This module provides useful abstractions for some
 * common tasks such as IO and error handling.
 */
#include "utilities.h"

/**
 * Include the header file for this module, note that
 * this file should be included last.
 */
#include "rendering.h"

/* }}} */

/* PUBLIC FUNCTIONS {{{ */

PUBLIC int ConfigureRendering(RenderConfig config) { /* {{{ */
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

PUBLIC Square GetSquare(int x, int y) { /* {{{ */
	int index = y * map.width + x;

	if (mapCreatedSuccess != initialised) {
		die("The rendering.c 'map' has not been initialised.");
	}

	return *(map.grid + index);
} /* }}} */

PUBLIC void SetSquare(int x, int y, Square square) { /* {{{ */
	int index = y * map.width + x;

	if (mapCreatedSuccess != initialised) {
		die("The rendering.c 'map' has not been initialised.");
	}

	*(map.grid + index) = square;
} /* }}} */

PUBLIC void PlaceWall(int x, int y, int dx, int dy, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void PlaceRectangularRoom(int x, int y, int dx, int dy, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void PlaceCircularRoom(int x, int y, int r, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void Render(int width, int length) { /* {{{ */
} /* }}} */

PUBLIC void Turn(int angle) { /* {{{ */
	camera.direction += angle;
} /* }}} */

PUBLIC void Walk(int distance) { /* {{{ */
} /* }}} */

PUBLIC void Strafe(int distance) { /* {{{ */
} /* }}} */

/* }}} */

/* PRIVATE FUNCTIONS {{{ */

PRIVATE initState CreateMap(int width, int length) { /* {{{ */
	switch (mapCreatedSuccess) {
	case uninitialised:
		/* map has not been initialized yet, do it now */
		map.width  = width;
		map.length = length;
		map.grid   = (Square *)malloc(sizeof (Square) * (size_t)(width * length));

		/* mark completion */
		mapCreatedSuccess = initialised;

		/* return success */
		return initialised;

	case initialised:
		/* map has already be initialized */
		err("The rendering.c 'map' has already been initialised.");
		break;

	case recreate:
		/* map needs to be re-created, this is ok */
		mapCreatedSuccess = uninitialised;
		freeMem((void **)&(map.grid));
		return CreateMap(width, length);

	default:
		/* some other error occurred */
		die("Failure to create 'map' in rendering.c, exiting...");
	}

	/* return failure / success code */
	return mapCreatedSuccess;
} /* }}} */

PRIVATE initState CreateFrame(int width, int height) { /* {{{ */
	switch (frameCreatedSuccess) {
	case uninitialised:
		/* frame has not been initialized yet, do it now */
		frame.width  = width;
		frame.height = height;
		frame.pixels = (Pixel *)malloc(sizeof (Pixel) * (size_t)(width * height));

		/* mark completion */
		frameCreatedSuccess = initialised;

		/* return success */
		return initialised;

	case initialised:
		/* frame has already be initialized */
		err("The rendering.c 'frame' has already been initialised.");
		break;

	case recreate:
		/* frame needs to be re-created, this is ok */
		frameCreatedSuccess = uninitialised;
		freeMem((void **)&(frame.pixels));
		return CreateFrame(width, height);

	default:
		/* some other error occurred */
		die("Failure to create 'frame' in rendering.c, exiting...");
	}

	/* return failure / success code */
	return frameCreatedSuccess;
} /* }}} */

PRIVATE Pixel GetPixel(int x, int y) { /* {{{ */
	int index = y * frame.width + x;

	if (frameCreatedSuccess != initialised) {
		die("The rendering.c 'frame' has not been initialised.");
	}

	return *(frame.pixels + index);
} /* }}} */

PRIVATE void SetPixel(int x, int y, Pixel pixel) { /* {{{ */
	int index = y * frame.width + x;

	if (frameCreatedSuccess != initialised) {
		die("The rendering.c 'frame' has not been initialised.");
	}

	*(frame.pixels + index) = pixel;
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
	Pixel ourPixel;
	char c;
	int shade;

	/* These casts are safe since we are casting literals */
	shade = 3 - RCL_min(3, pixel->depth / RCL_UNITS_PER_SQUARE);

	if (pixel->isWall) {
		switch (pixel->hit.direction) {
		case 0:
			shade += 2; /* FALLTHROUGH */
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

	ourPixel.r = 0xff;
	ourPixel.g = 0xff;
	ourPixel.b = 0xff;
	ourPixel.ascii = c;

	SetPixel(pixel->position.x, pixel->position.y, ourPixel);
} /* }}} */

/**
 * This function is passed to the raycastlib
 * rendering functions, e.g. RCL_renderSimple(). It
 * allows the library to see the Squares in our map
 * without hampering our implementation of the map.
 */
RCL_Unit QueryPixelHeight(int x, int y) { /* {{{ */
	int64_t index = y * map.width + x;

	return (index < 0 || (index >= (int64_t)(map.width * map.length))
		? 1
		: (*(map.grid + index)).height
	) * 2 * RCL_UNITS_PER_SQUARE;
} /* }}} */

/* }}} */

