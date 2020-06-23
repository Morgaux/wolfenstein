/**
 * Main source file for my Wolfenstein 3D clone
 */

#include <stdio.h>

#include "config.h"

int main(int argc, char ** argv) {
	printf("VERSION=%s\n", VERSION);
#ifdef DEBUG
	printf("DEBUG=%d\n", DEBUG);
#endif
	return 0;
}

