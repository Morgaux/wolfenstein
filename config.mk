# vim: set foldmethod=marker:
# This must be the fist non-comment line to enforce POSIX compliance.
.POSIX:

#
# Configuration for Wolfenstein 3D makefiles
#

# MAKE CONFIGURATION {{{

# These configurations are for make(1) and the makefiles that include this file.

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
.PHONY: all config clean

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
# ${OBJ} is dynamically populated with a .o file for every given .c file in
# ${SRC}, however, any additional .o files may be added to this variable to be
# included in the build. Finally, ${SRC} contains a list of the primary .c files
# needed for the build, by default it is populated with the ${BIN} name with a
# .c extension, any additional c source files should be given manually. For
# every .c file in ${SRC} a matching .h file is defined in ${HDR}, these are the
# header files for the respective sources that define and preprocessor logic
# that shouldn't contaminate the main C sources, as well as the function
# declarations for use if said sources and any tests that may apply.
BIN := wolfenstein3D
LIB := ${DRUMMY_FISH_LIBS}
SRC := ${BIN:%=%.c}
OBJ := ${SRC:.c=.o}
HDR := ${SRC:.c=.h}
MAN := ${BIN:%=%.1}

# }}}

# DISTRIBUTION AND VERSION CONTROL {{{

# These control the specific version and build type for a build. These are also
# used when creating a distribution tar ball or during installation to version
# stamp the installation files. ${FLAVOUR} should be either 'DEBUG', 'CURRENT',
# or 'RELEASE'
FLAVOUR := DEBUG
MAJOR_V := 0
MINOR_V := 1
POINT_V := 0
VERSION := ${MAJOR_V}.${MINOR_V}.${POINT_V}

# These define the important files in this repository, by their type and
# functionality.
REPO_FILES := README.md LICENSE img
MAKE_FILES := Makefile        \
              build.mk        \
              colors.mk       \
              config.mk       \
              dependencies.mk \
              installation.mk

# These flags control the compression and bundling tools.
TAR_FLAGS  := -l -R --verbose --totals --quoting-style=literal
GZIP_FLAGS := --verbose --best

# These control which files are included in a release, in what order, and what
# the release tar ball is called.
DIST_FILES := ${REPO_FILES} ${MAKE_FILES} ${SRC}
DIST_DIR   := ${BIN}-${VERSION}-${FLAVOUR}
DIST_TGZ   := ${DIST_DIR}.tar.gz

# }}}

# COMPILATION {{{

# These define compiler options to be passed to the complier during the build
# process.
DEFINES := ${FLAVOUR} VERSION=\"${VERSION}\" 
CFLAGS  := -std=c99 -pedantic -Wall -O3 ${DEFINES:%=-D%} ${LIB:%=-I%}
LDFALGS := 

# This defines the C language compiler.
CC := cc

# }}}

# DOCUMENTATION {{{

# These are manpage formatting macros, provided as an abstraction over writing
# these inline. The added benefit is that the correct number of escape slashes
# needed can be adjusted in one place if the Makefile rule is updated.
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
SHORT_DESCRIPTION := A simple wolfenstein3D clone
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

# INSTALLATION {{{

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

# This lists all files that are generated by the build process but need to be
# removed to avoid clutter, these are cleaned by the 'clean' target.
TRASH := ${BIN} \
         ${MAN} \
         ${OBJ} \
         ${DRUMMY_FISH_LIBS} \
         ${DIST_DIR} \
         ${DIST_TGZ}

# This is a macro to delete a file or directory as part of a rule. Note that
# this is permanent and cannot be undone, especially dangerous as root.
DELETE := rm -rf

# This macro defines the main command to run during the 'clean' rule, additional
# commands may be used, such as for logging, but this macro allows for cleaning
# in the implementation body of a rule that may create more cruft than usual or
# may require a clean workspace for a command that follows another that dirties
# it. This is especially useful for automated test cases.
CLEAN := ${DELETE} ${TRASH}

# }}}

# DEFAULT TARGETS {{{
# Note: this section must be after any configuration as it may require macros
# and variables to be loaded.

# This is the default target, show the configuration for the build and build the
# target but don't install or clean.
all: config ${BIN}

# This is the 'config' target, it is used to display configuration information
# before a build begins or on its own for debugging purposes.
config:
	@echo "${YELLOW}${BIN} build configuration:${RESET}"
	@echo "\t${GREEN}VERSION${RESET} = ${BOLD}${VERSION}-${FLAVOUR}${RESET}"
	@echo "\t${GREEN}BIN${RESET}     = ${BOLD}${BIN}${RESET}"
	@echo "\t${GREEN}LIB${RESET}     = ${BOLD}${LIB}${RESET}"
	@echo "\t${GREEN}SRC${RESET}     = ${BOLD}${SRC}${RESET}"
	@echo "\t${GREEN}OBJ${RESET}     = ${BOLD}${OBJ}${RESET}"
	@echo "\t${GREEN}BIN_DIR${RESET} = ${BOLD}${BIN_DIR}${RESET}"
	@echo "\t${GREEN}MAN_DIR${RESET} = ${BOLD}${MAN_DIR}${RESET}"
	@if [ -n "${DESTDIR}" ] ;                                              \
	then                                                                   \
		echo "\t${GREEN}DESTDIR${RESET} = ${BOLD}${DESTDIR}${RESET}" ; \
	fi # only show ${DESTDIR} if it is set, i.e. by a user or test script

# This target defines how to clean up an unneeded files generated during a
# build, it is useful for running manually during development and before an
# install as it forces all the dependencies to be rebuild fresh, preventing any
# old version from leaking into an install build.
clean:
	@echo "${YELLOW}Cleaning build files...${RESET}"
	${CLEAN}

# The 'install' phony target acts as a master trigger for the installation
# actions, it allow for the order and prerequisites for a full install to be
# configured in a single place.
install: config install_man install_bin
	@echo "${GREEN}Installation complete.${RESET}"

# The 'uninstall' phony target acts as the complementary action to the 'install'
# action. It defines any prerequisites and dependencies needed to uninstall the
# files created by the 'install' action.
uninstall: clean uninstall_man uninstall_bin
	@echo "${GREEN}Uninstallation complete.${RESET}"

.PHONY: all clean config install uninstall

# }}}

