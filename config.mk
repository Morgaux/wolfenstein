#
# Configuration for Wolfenstein 3D makefiles
#

# BUILD FILES {{{

# These files define which files are built or installed and the destination
# executable. ${BIN} should be a single item, the name of the final executable
# to build / install. ${LIB} should define a list of directories that contain
# dependencies of the final build, these are removed during the 'clean' target
# so the should either be pulled in from a remote source or a subdir of the
# 'src' directory. ${OBJ} is dynamically populated with a .o file for every
# given .c file ing ${SRC}, however, any additional .o files may be added to
# this variable to be included in the build. Finally, ${SRC} contains a list of
# the primary .c files needed for the build, by default it is populated with the
# ${BIN} name with a .c extension, any additional c source files should be given
# manually.
BIN = wolfenstein3D
LIB = raycastlib small3dlib
SRC = ${BIN:%=%.c}
OBJ = ${SRC:.c=.o}

# }}}

# DISTRIBUTION AND VERSION CONTROL {{{

# These control the specific version and build type for a build. These are also
# used when creating a distribution tar ball or during installation to version
# stamp the installation files. ${RELEASE} should be either 'DEBUG', 'CURRENT',
# or 'RELEASE'
RELEASE := DEBUG
MAJOR_V := 0
MINOR_V := 1
POINT_V := 0
VERSION := ${MAJOR_V}.${MINOR_V}.${POINT_V}

# These control which files are included in a release, in what order, and what
# the release tar ball is called.
REPO_FILES := README.md LICENSE img
MAKE_FILES := Makefile config.mk colors.mk
DIST_FILES := ${REPO_FILES} ${MAKE_FILES} ${SRC} ${LIB}
DIST_DIR   := ${BIN}-${VERSION}-${RELEASE}

# }}}

# COMPILATION {{{

# These define compiler options to be passed to the complier during the build
# process.
DEFINES := ${RELEASE} VERSION=\"${VERSION}\" 
CFLAGS  := -std=c99 -pedantic -Wall -O3 ${DEFINES:%=-D%}
LDFALGS := 

# This defines the C language compiler.
CC := cc

# }}}

# INSTALL DIRS {{{

# These directories define installation root locations used by the installation
# and uninstallation targets.
PREFIX    := /usr/local
MANPREFIX := ${PREFIX}/share/man

# These directories are the full paths used for installation, ${DESTDIR} is not
# defined by default but may be provided on the command line in create a local
# installation, for example in a user's home directory or in a chroot
# environment.
BIN_DIR := ${DESTDIR}${PREFIX}/bin
MAN_DIR := ${DESTDIR}${MANPREFIX}/man1

# }}}

# MACRO COMMANDS {{{

# This is a command macro to substitute placeholder in generated files. This
# allows for the '<' and '>' shell output redirectors to effectively preform
# these substitutions effectively.
SUBSTITUTE := sed 's/__RELEASE__/${RELEASE}/g; \
                   s/__VERSION__/${VERSION}/g; \
                   s/__BIN__/${BIN}/g'

# }}}

