/**
 * Main source file for my Wolfenstein 3D clone
 * TODO: implement everything
 */

/**
 * Include config.h, this should be done first, before any other includes or
 * definitions. This allows for the user configurable settings to be accessible
 * to the local code and headers.
 */
#include "config.h"

/**
 * Include any external libraries and system headers here, in order.
 */
#include <stdio.h>

/**
 * Include the raycastlib library for the rendering backend. This library is
 * pulled and installed to the local build directory which is passed to the
 * compiler via the -I flag. It is for this reason that it may be included using
 * <...> rather than "..." syntax.
 */
#include <raycastlib.h>

/**
 * Include definitions and prototypes for main wolfenstein3D.c source. This
 * should be the last file included as it preforms the last definitions for this
 * source file.
 */
#include "wolfenstein3D.h"

/**
 * Function that will tell the library height of square at each coordinates.
 * We may implement it however we like, it may e.g. read the height out of a
 * level array. Here we simply compute the height procedurally, without needing
 * extra data.
 */
RCL_Unit heightAt(int16_t x, int16_t y) { /* {{{ */
	return ((x < 0 || x > 10 || y < 0 || y > 10)
	     ? 2 * RCL_UNITS_PER_SQUARE
	     : 0); // library units, imagine e.g. 2 meters
} /* }}} */

/**
 * This is the function we write pixels to our ASCII screen with. Above we have
 * told the library it should call this function during rendering.
 */
void pixelFunc(RCL_PixelInfo *p) { /* {{{ */
	char c = ' ';

	if (p->isWall) { // ray hit wall
		switch (p->hit.direction) {
		case 1:
		case 2:
			c = '#';
			break;
		case 0:
		case 3:
			c = '/';
			break;
		default:
			break;
		}
	} else { // ray hit a floor or ceiling
		c = p->isFloor ? '.' : ':';
	}

	screen[p->position.y * (SCREEN_W + 1) + p->position.x] = c;
} /* }}} */

/**
 * Main function and entry point
 */
int main(int argc, char ** argv) { /* {{{ */
	// prefill screen with newlines
	for (int i = 0; i < PIXELS_TOTAL; ++i) {
		screen[i] = '\n';
	}

	// terminate the string
	screen[PIXELS_TOTAL - 1] = 0;

	// camera to specify our view
	RCL_Camera camera;
	RCL_initCamera(&camera);

	// set up the camera:
	camera.position.x   = 5 * RCL_UNITS_PER_SQUARE;
	camera.position.y   = 6 * RCL_UNITS_PER_SQUARE;
	camera.direction    = 5 * RCL_UNITS_PER_SQUARE / 6; // 4/5 of full angle
	camera.resolution.x =     SCREEN_W;
	camera.resolution.y =     SCREEN_H;

	/**
	 * This struct tell the library more details about how it should cast
	 * each of the rays.
	 */
	RCL_RayConstraints constraints;

	/**
	 * Set up the constraints on how to cast rays.
	 */
	RCL_initRayConstraints(&constraints);
	constraints.maxHits  = 1;  // we don't need more than 1 hit here
	constraints.maxSteps = 40; // max squares a ray will travel

	/**
	 * This will start the rendering itself. The library will start calling
	 * our pixelFunc to render one frame. You can also try to use the
	 * complex rendering function, the result should be practically the
	 * same:
	 *
	 * RCL_renderComplex(camera, heightAt, 0, 0, constraints);
	 */
	RCL_renderSimple(camera, heightAt, 0, 0, constraints);

	// print out the rendered frame
	puts(screen);

	return 0;
} /* }}} */

