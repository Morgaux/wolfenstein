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

PUBLIC Frame Render(u_int64_t width, u_int64_t length) { /* {{{ */
	Frame frame;

	return frame;
} /* }}} */

