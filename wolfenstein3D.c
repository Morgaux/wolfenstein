/**
 * Main source file for my Wolfenstein 3D clone
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
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

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
static RCL_Unit heightAt(int16_t x, int16_t y) { /* {{{ */
	int32_t index = y * MAP_W + x;

	return (index < 0 || (index >= MAP_W * MAP_H)
	        ? 1
	        : map[y * MAP_W + x]
	       ) * 2 * RCL_UNITS_PER_SQUARE; // library units, e.g. 2 meters
} /* }}} */

/**
 * This is the function we write pixels to our ASCII screen with. Above we have
 * told the library it should call this function during rendering.
 */
void pixelFunc(RCL_PixelInfo *p) { /* {{{ */
	/* Define the shading ASCII characters. */
	static const char asciiShades[] = "HXi/;,.               ";

	/* The character to print for that pixel */
	char c = ' ';

	/* The shade of this pixel (depending on the angle) */
	uint8_t shade = 3;

	shade -= RCL_min(3,p->depth / RCL_UNITS_PER_SQUARE);

	if (p->isWall) { // ray hit wall
		switch (p->hit.direction) {
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
	} else { // ray hit a floor or ceiling
		c = p->isFloor ? '.' : ':';
	}

	screen[p->position.y * (SCREEN_W + 1) + p->position.x] = c;
} /* }}} */

/**
 * Drawing function to do the actual drawing of pixels to the screen
 */
static void draw() { /* {{{ */
	// prefill screen with newlines
	memset(screen,'\n',PIXELS_TOTAL);

	// terminate the string
	screen[PIXELS_TOTAL - 1] = 0;

	/**
	 * Set up the constraints on how to cast rays.
	 */
	RCL_initRayConstraints(&constraints);
	constraints.maxHits  =  1; // we don't need more than 1 hit here
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

	/* Clear the screen */
	for (int i = 0; i < SCREEN_H; i++) {
		puts("\n");
	}

	/* Display the frame */
	puts(screen);
} /* }}} */

/**
 * Main function and entry point
 */
int main(int argc, char ** argv) { /* {{{ */
	int dx = 1;
	int dy = 0;
	int dr = 1;
	int frame = 0;

	// camera to specify our view
	RCL_initCamera(&camera);

	// set up the camera:
	camera.position.x   = 2 * RCL_UNITS_PER_SQUARE;
	camera.position.y   = 2 * RCL_UNITS_PER_SQUARE;
	camera.direction    = 0;
	camera.resolution.x = SCREEN_W;
	camera.resolution.y = SCREEN_H;

	for (int i = 0; i < 10000; ++i) {
		draw();

		int squareX = RCL_divRoundDown(camera.position.x,RCL_UNITS_PER_SQUARE);
		int squareY = RCL_divRoundDown(camera.position.y,RCL_UNITS_PER_SQUARE);

		if (rand() % 100 == 0) {
			dx = 1 - rand() % 3;
			dy = 1 - rand() % 3;
			dr = 1 - rand() % 3;
		}
		
		while (heightAt(squareX + dx,squareY + dy) > 0) {
			dx = 1 - rand() % 3;
			dy = 1 - rand() % 3;
			dr = 1 - rand() % 3;
		}

		camera.position.x += dx * 200;
		camera.position.y += dy * 200;
		camera.direction  += dr * 10;

		camera.height = RCL_UNITS_PER_SQUARE + RCL_sin(frame * 16) / 2;

		usleep(100000);

		frame++;
	}

	return 0;
} /* }}} */

