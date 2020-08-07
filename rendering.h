/**
 * rendering.h header for rendering.c source module of wolfenstein3D
 *
 * @AUTHOR:      Morgaux Meyer
 * @DESCRIPTION: [update manually]
 */

/* PREVENT REEVALUATION {{{ */
#ifndef RENDERING_H
#define RENDERING_H

/* DETERMINE SCOPE OF SYMBOLS {{{ */
/**
 * The way we control the access level of a function
 * or variable in C is via the use of the static and
 * extern keywords. However, contrary to the use of
 * the private and public keywords, the declaration
 * of a function in C must vary for use in the same
 * source as the declaration and use in an externally
 * linked object file. To allow a single function
 * declaration to function for both internal and
 * external use, here the public and private symbols
 * are defined depending on whether this header is
 * included in the module of the same name (this is
 * determined via the '#ifdef' preprocessor, as all
 * modules define a symbol of their name).
 *
 * Here, if the source file including this header is
 * part of the same module, then the private symbol
 * defined as the static key word, allowing functions
 * declared as 'private void foo();' to be expanded
 * as 'static void foo();'. However, if the file is
 * not part of the same module, public is defined as
 * the extern keyword, which allows for the functions
 * available to the other module to be accessed. In
 * each case the other symbol is defined as NO_OP, a
 * non-action which is defined in defines.h and this
 * allows a public function to skip using the  extern
 * keyword when used within the same module.
 *
 * NOTE: private functions should be hidden from the
 * other modules to prevent any conflicts with other
 * functions in that module. They should instead be
 * wrapped in another #ifdef block below.
 */
#undef public
#undef private

#define private static

#ifdef RENDERING_C
#define public
#else
#define public extern
#endif
/* }}} */

/* PUBLICS {{{ */
/**
 * All data structures and function definitions that
 * need to be available to other functions should be
 * provided here with the public keyword.
 */

public typedef struct { /* RENDER CONFIG {{{ */
	int      cameraPosX;
	int      cameraPosY;
	int      cameraResX;
	int      cameraResY;
	int      cameraStartHeight;
	int      cameraStartDirection;
	uint16_t cameraViewDistance; /* raycastlib uses uint16_t here */
	int      mapWidth;
	int      mapHeight;
	int      frameWidth;
	int      frameHeight;
} RenderConfig; /* }}} */

public typedef struct { /* PIXEL {{{ */
	uint8_t r;     /* r component of the RGB colour code                  */
	uint8_t g;     /* g component of the RGB colour code                  */
	uint8_t b;     /* b component of the RGB colour code                  */
	char    ascii; /* ASCII fallback to use if colours cannot be rendered */
} Pixel; /* }}} */

public typedef struct { /* SQUARE {{{ */
	int height; /* vertical size off floor, negative if off ceiling */
	Pixel*  pixels; /* array of the Pixels this square has vertically   */
} Square; /* }}} */

public typedef struct { /* TEXTURE {{{ */
	int     width;  /* horizontal size of the Texture  */
	int     height; /* vertical size of the Texture    */
	Pixel * pixels; /* array of Pixels in this Texture */
} Texture; /* }}} */

public int ConfigureRendering(RenderConfig);

public Square GetSquare(int, int);

public void SetSquare(int, int, Square);

public void PlaceWall(int, int, int, int, Texture);

public void PlaceRectangularRoom(int, int, int, int, Texture);

public void PlaceCircularRoom(int, int, int, Texture);

public void Render(int, int);

public void Turn(int);

public void Walk(int);

public void Strafe(int);

/* }}} */

/* PRIVATES {{{ */
/**
 * All data structures and function definitions that
 * need to be limited to the current module should be
 * provided within the #ifdef...#endif block below,
 * with the private keyword.
 */
#ifdef RENDERING_C

private struct Map { /* {{{ */
	int      width;  /* size of the x axis           */
	int      length; /* size of the y axis           */
	Square * grid;   /* array of Squares in this Map */
} map = {
	.width  = 0,
	.length = 0,
	.grid   = NULL
}; /* }}} */

private struct Frame { /* {{{ */
	int     width;  /* horizontal size of the Frame  */
	int     height; /* vertical size of the Frame    */
	Pixel * pixels; /* array of Pixels in this Frame */
} frame = {
	.width  = 0,
	.height = 0,
	.pixels = NULL
}; /* }}} */

typedef enum { /* initState {{{ */
	uninitialised,
	initialised,
	recreate
} initState; /* }}} */

private initState mapCreatedSuccess = uninitialised;

private initState frameCreatedSuccess = uninitialised;

private RCL_Camera camera;

private RCL_RayConstraints constraints;

private initState CreateMap(int, int);

private initState CreateFrame(int, int);

private Pixel GetPixel(int, int);

private void SetPixel(int, int, Pixel);

#endif
/* }}} */

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
void RenderPixel(RCL_PixelInfo *);

/**
 * This function is passed to the raycastlib
 * rendering functions, e.g. RCL_renderSimple(). It
 * allows the library to see the Squares in our map
 * without hampering our implementation of the map.
 */
RCL_Unit QueryPixelHeight(int, int);

#endif
/* }}} */

#endif /* RENDERING_H */
/* }}} */

