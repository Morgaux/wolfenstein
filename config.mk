# vim: set foldmethod=marker:
# This must be the fist non-comment line
.POSIX:

#
# Configuration for Wolfenstein 3D makefiles
#

# MAKE CONFIGURATION {{{

# These configurations are for make(1) and the makefiles that include this file.

# This is the default target, show the configuration for the build and build the
# target but don't install or clean.
all: config ${BIN}

# The .SILENT target makes the output of the make build process less verbose,
# only showing messages explicitly printed with echo statements or output from
# the complier for example. Uncomment the below lines to enable this behaviour
# if desired.
#.SILENT:

# This specifies the location of the shell to use, this should be something
# portable so that the build works without issues on all systems. Using /bin/sh
# has the added benefit of forcing you to use the POSIX Bourne Shell a all times
# and catches Bash-isms early, allowing more portable code in the build system
# to occur naturally.
SHELL := /bin/sh

# This target specifies that the 'all' target should be built even if an 'all'
# file exists, specify any other custom targets in the config.mk file here and
# any genuine build targets in the main Makefile.
.PHONY: all

# This macro allows a simple and programmatic way of ignoring errors on a
# command that may fail.
SWALLOW_ERR := 2>/dev/null || true

# These macros allow for cleaning stdin input for redirection to a file, STRIP
# is a text processor command wrapper that strips repeating whitespace, CREATE
# and TO write STRIP'd stdin to a file and to stdout, CREATE overwrites the
# existing file and TO appends to it.
STRIP  := grep -Ev '^$$' | sed 's/\s\s*/ /g'
CREATE := ${STRIP} | tee
TO     := ${CREATE} -a

# }}}

# BUILD FILES {{{

# These are libraries written by Miloslav Ciz (tasyfish.cz), I am using them as
# the rendering backends and pull them in from the git repos, fresh.
DRUMMY_FISH_LIBS := raycastlib small3dlib

# These files define which files are built or installed and the destination
# executable. ${BIN} should be a single item, the name of the final executable
# to build / install. ${LIB} should define a list of directories that contain
# dependencies of the final build, these are added to the C compilers list of
# include dirs via the '-I' flag and should be added to with this in mind.
# ${OBJ} is dynamically populated with a .o file for every given .c file ing
# ${SRC}, however, any additional .o files may be added to this variable to be
# included in the build. Finally, ${SRC} contains a list of the primary .c files
# needed for the build, by default it is populated with the ${BIN} name with a
# .c extension, any additional c source files should be given manually.
BIN = wolfenstein3D
LIB = ${DRUMMY_FISH_LIBS}
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
CFLAGS  := -std=c99 -pedantic -Wall -O3 ${DEFINES:%=-D%} ${LIB:%=-I%}
LDFALGS := 

# This defines the C language compiler.
CC := cc

# }}}

# DOCUMENTATION {{{

# These are manpage formatting macros, provided as an abstraction over writing
# these inline.
MAN_COMMENT      := .\\\\\"
MAN_PARAGRAPH    := .PP
MAN_TITLE        := .TH
MAN_SECTION      := .SH
MAN_OPTION       := .TP
MAN_BOLD         := .B
MAN_BOLD_WORD    := \\\\fB
MAN_ITALICS      := .I
MAN_ITALICS_WORD := \\\\fI
MAN_REGULAR      := .R
MAN_REGULAR_WORD := \\\\fR
MAN_START_CODE   := .nf
MAN_END_CODE     := .fi
MAN_START_INDENT := .RS
MAN_END_INDENT   := .RE

# These variables are used to configure various values for documentation files.
AUTHOR    := Morgaux Meyer
CONTACT   := 3158796-morgaux@users.noreply.gitlab.com
LICENSE   := MIT
DATE      := $$(date '+%d %b %Y')
COPYRIGHT := ${LICENSE} (C) $$(date +%Y) ${AUTHOR} (${CONTACT})

# These variables are directly used to generate the manpage. SHORT_DESCRIPTION
# should be a brief sentence describing the project, OPTIONS should list any
# options and their syntax for the project, OPT_DESCRIPTION should provide a
# details breakdown of the OPTIONS and their uses and meanings, SYNOPSIS should
# provide the usage and option syntax, DESCRIPTION should explain the rest of
# the details and caveats, EXAMPLES should provide use cases, SEE_ALSO should
# list any related manpages (though they may not be available on the user's
# system), and BUGS should list any bugs, TODOs, or missing features.
SHORT_DESCRIPTION := A simple Wolfenstien3D clone
OPTIONS           := 
OPT_DESCRIPTION   := ${BIN} takes no options at this time.
SYNOPSIS          := ${MAN_BOLD_WORD}${BIN} ${OPTIONS}
DESCRIPTION       := ${BIN} is a pet project to explore Raycasting and other   \
                     rudimentary aspects of early game graphics. It is mostly  \
                     written in C using the excellent raycastlib and           \
                     small3dlib by Miloslav Ciz (tasyfish.cz).
EXAMPLES          := ./${BIN} ${OPTIONS}
SEE_ALSO          := raycastlib.h small3dlib.h
BUGS              := NONE (for now...)

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

