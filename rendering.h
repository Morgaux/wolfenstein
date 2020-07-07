/**
 * Header file for rendering.c
 */

#ifndef RENDERING_H
#define RENDERING_H

/* GLOBAL VARS {{{ */

/**
 * Externally defined variables defined in other modules.
 */
extern char screen[];
extern int map[];

/**
 * Define the camera to control the view of the space.
 */
static RCL_Camera camera;

/**
 * This struct tell the library more details about how it should cast
 * each of the rays.
 */
static RCL_RayConstraints constraints;

/* }}} */

/* FUNCTION DEFINITIONS {{{ */

/**
 * Static functions, these are private to this module.
 */
static RCL_Unit heightAt(int16_t x, int16_t y);
static void draw();

/**
 * Global functions, these are non static and accessible to other modules.
 */
void pixelFunc(RCL_PixelInfo *p);
void turn(int angle);
void walk(int distance);
void strafe(int distance);
int initialize_rendering();

/* }}} */

#endif

