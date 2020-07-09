/**
 * Source file for the rendering module of wolfenstein3D
 */

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

/**
 * Include any external libraries and system headers
 * here, in order.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/* DEFINE RAYCASTLIB SYMBOLS {{{ */

/**
 * Tell raycastlib the name of the function with which we write pixels to the
 * screen.
 */
#define RCL_PIXEL_FUNCTION RenderPixel

/**
 * Turn off what we don't need, to improve performance.
 */
#define RCL_COMPUTE_FLOOR_DEPTH   0
#define RCL_COMPUTE_CEILING_DEPTH 0

/* }}} */

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

PUBLIC int64_t CreateMap(u_int64_t width, u_int64_t length) { /* {{{ */
	return 0;
} /* }}} */

PUBLIC Square GetSquare(u_int64_t x, u_int64_t y) { /* {{{ */
	Square square;

	return square;
} /* }}} */

PUBLIC void SetSquare(u_int64_t x, u_int64_t y, Square square) { /* {{{ */
} /* }}} */

PUBLIC void PlaceWall(u_int64_t x, u_int64_t y, int64_t dx, int64_t dy, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void PlaceRectangularRoom(u_int64_t x, u_int64_t y, int64_t dx, int64_t dy, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void PlaceCircularRoom(u_int64_t x, u_int64_t y, u_int64_t r, Texture texture) { /* {{{ */
} /* }}} */

PUBLIC void Render(u_int64_t width, u_int64_t length) { /* {{{ */
} /* }}} */

/* FUNCTIONS FOR RAYCASTLIB {{{ */
/**
 * The raycastlib library requires some code to be
 * written by it's user, in this case this module, to
 * act as a sort of callback function. These should
 * only be declared within this module, but cannot be
 * declared static as this conflicts with how the
 * raycastlib defines them, as such these should be
 * wrapped in this #ifdef...#endif directives.
 */
#ifdef RENDERING_C

/**
 * This function is used internally by the backend
 * raycastlib library and it called for every pixel
 * it renders, here we use it to transfer the
 * raycastlib pixel struct data to a rendering pixel
 * struct variable and using that pixel struct within
 * this module.
 */
void RenderPixel(RCL_PixelInfo* pixel) { /* {{{ */
} /* }}} */

#endif
/* }}} */

