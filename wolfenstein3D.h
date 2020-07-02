/**
 * Header file for wolfenstein3D.c
 */

/* GLOBAL VARS {{{ */

/**
 * Define screen size accounting for terminating NULL and \n characters.
 */
char screen[(SCREEN_W + 1) * SCREEN_H + 1];

/* }}} */

/* FUNCTION DECLARATIONS {{{ */

RCL_Unit heightAt(int16_t x, int16_t y);
void pixelFunc(RCL_PixelInfo *p);
int main(int argc, char ** argv);

/* }}} */

