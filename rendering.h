/**
 * Header file for rendering.c
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
 * external use, here the PUBLIC and PRIVATE symbols
 * are defined depending on whether this header is
 * included in the module of the same name (this is
 * determined via the '#ifdef' preprocessor, as all
 * modules define a symbol of their name).
 *
 * Here, if the source file including this header is
 * part of the same module, then the PRIVATE symbol
 * defined as the static key word, allowing functions
 * declared as 'PRIVATE void foo();' to be expanded
 * as 'static void foo();'. However, if the file is
 * not part of the same module, PUBLIC is defined as
 * the extern keyword, which allows for the functions
 * available to the other module to be accessed. In
 * each case the other symbol is defined as NO_OP, a
 * non-action which is defined in defines.h and this
 * allows a PUBLIC function to skip using the  extern
 * keyword when used within the same module.
 *
 * NOTE: PRIVATE functions should be hidden from the
 * other modules to prevent any conflicts with other
 * functions in that module. They should instead be
 * wrapped in another #ifdef block below.
 */
#undef PUBLIC
#undef PRIVATE

#define PRIVATE static

#ifdef RENDERING_C
#define PUBLIC
#else
#define PUBLIC extern
#endif
/* }}} */

/* PUBLICS {{{ */
/**
 * All data structures and function definitions that
 * need to be available to other functions should be
 * provided here with the PUBLIC keyword.
 */

typedef struct {
	u_int8_t r; /* r component of the RGB colour code                  */
	u_int8_t g; /* g component of the RGB colour code                  */
	u_int8_t b; /* b component of the RGB colour code                  */
	char acsii; /* ASCII fallback to use if colours cannot be rendered */
} Pixel;

typedef struct {
	int64_t height; /* vertical size off floor, negative if off ceiling */
	Pixel* Pixels;  /* array of the Pixels this square has vertically   */
} Square;

typedef struct {
	u_int64_t width;  /* horizontal size of the Texture  */
	u_int64_t height; /* vertical size of the Texture    */
	Pixel* pixels;    /* array of Pixels in this Texture */
} Texture;

PUBLIC int64_t CreateMap(u_int64_t width, u_int64_t length);

PUBLIC int64_t CreateFrame(u_int64_t width, u_int64_t length);

PUBLIC Square GetSquare(u_int64_t x, u_int64_t y);

PUBLIC void SetSquare(u_int64_t x, u_int64_t y, Square square);

PUBLIC void PlaceWall(u_int64_t x, u_int64_t y, int64_t dx, int64_t dy, Texture texture);

PUBLIC void PlaceRectangularRoom(u_int64_t x, u_int64_t y, int64_t dx, int64_t dy, Texture texture);

PUBLIC void PlaceCircularRoom(u_int64_t x, u_int64_t y, u_int64_t r, Texture texture);

PUBLIC void Render(u_int64_t width, u_int64_t length);

/* }}} */

/* PRIVATES {{{ */
/**
 * All data structures and function definitions that
 * need to be limited to the current module should be
 * provided within the #ifdef...#endif block below,
 * with the PRIVATE keyword.
 */
#ifdef RENDERING_C

PRIVATE struct Map {
	u_int64_t width;  /* size of the x axis           */
	u_int64_t length; /* size of the y axis           */
	Square* grid;     /* array of Squares in this Map */
} map;

PRIVATE struct Frame {
	u_int64_t width;  /* horizontal size of the Frame  */
	u_int64_t height; /* vertical size of the Frame    */
	Pixel* pixels;    /* array of Pixels in this Frame */
} frame;

PRIVATE Pixel GetPixel(u_int64_t x, u_int64_t y);

PRIVATE void SetPixel(u_int64_t x, u_int64_t y, Pixel pixel);

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
void RenderPixel(RCL_PixelInfo* pixel);

#endif
/* }}} */

#endif
/* }}} */
