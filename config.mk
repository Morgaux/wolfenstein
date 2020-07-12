# vim: set foldmethod=marker:
# This must be the fist non-comment line to enforce POSIX compliance.
.POSIX:

#
# Configuration for Wolfenstein 3D makefiles
#

# BUILD FILES {{{

# These are libraries written by Miloslav Ciz (tasyfish.cz), I am using them as
# the rendering backends and pull them in from the git repos, fresh.
DRUMMY_FISH_LIBS := raycastlib small3dlib

# This defines the various components of this Wolfenstein 3D project. The
# ${MODULES} variable defines the components of wolfenstein3D that are compiled
# separately and linked to form wolfenstein3D. These components are provided in
# ${MODULES} as the plain name of the module with no extensions. The source code
# files for these ${MODULES} contain the functions and data structures needed,
# but without a 'main' function. These are compiled to the ${OBJ} files as
# defined below. The ${MAINS} variable holds the special modules that contain
# only the 'main' function. These are also compiled to the ${OBJ} files,
# however, only the main module defined in the ${BIN} target is built and used
# as the 'main' function for the resulting executable. This allows the
# wolfenstein3D target (the default ${BIN} target) to be swapped out
# (effectively changing the 'main' function used for that build), for example a
# unit test C source file may define predicates for the module in question and
# when built with that main as the ${BIN} target.
#
# Note: The config.h file is a user configured header file that may only be
# included in the source file of a ${MAINS} module, this is to prevent conflicts
# among modules and allows the user level configuration to be a global interface
# for the 'main()' function to manage and allow each module to have it's own
# independent configuration.
MODULES := rendering utilities
MAINS   := wolfenstein3D

# These are the final targets that get build and installed. ${BIN} must be a
# single executable name that will get built by the linking of the ${OBJ} object
# files, see below. It may be overriden on the command line by passing in any of
# the ${MAINS} targets instead, in which case that target's source file is used
# instead of wolfenstein's source. This has the effect of having the same
# modules available but a different 'main()' function to be called, allowing the
# primary purpose of a build, e.g. for a release or for a test, to be defined
# while maintaining the same build system. The ${MAN} targets are any and all
# man pages for the respective ${MAINS}, as only ${MAINS} are created as final
# executables, only these can have a section 1 manpage. There is currently no
# support for other manual sections for the individual modules.
#
# Note: The ${BIN} target is also used for installation and uninstallation, be
# careful to only use the targets in 'installation.mk' with ${BIN} set to
# wolfenstein3D, unless you know __exactly__ what you are doing.
BIN ?= wolfenstein3D
MAN := wolfenstein3D.1

# These variables define the way that the modules and specialised libraries work
# and interact. The ${LIB} variable defines a list of local and/or system
# directories to include in the compiler's header search path. This has a
# twofold purpose, first to define the '-L<DIR>' compiler flags, see the
# COMPILATION section below, and second to provide a cue for any third party
# libraries to be installed, pulled, updated, or created. This secondary use is
# primarily for the ${DRUMMY_FISH_LIBS}, raycastlib.h and small3dlib.h, which
# are used in the rendering module as the rendering backend, these are pulled
# from the upstream Gitlab repositories and so are not included in this project
# directly, but rather acquired via 'git clone'. It is the 'git clone' action
# that is triggered by those respective libraries.
LIB := ${DRUMMY_FISH_LIBS}

# These define the C source and header files in relation to each other, and
# their resultant object files.
SRC := ${BIN:%=%.c} ${MODULES:%=%.c}
HDR := ${SRC:.c=.h}
OBJ := ${SRC:.c=.o}

# }}}

# DISTRIBUTION AND VERSION CONTROL {{{

# These control the specific version and build type for a build. These are also
# used when creating a distribution tar ball or during installation to version
# stamp the installation files. ${FLAVOUR} should be either 'DEBUG', 'CURRENT',
# or 'RELEASE'. Note that ${FLAVOUR} should be overriden on the command line and
# default to 'DEBUG' here in the config.mk file.
FLAVOUR ?= DEBUG
MAJOR_V := 0
MINOR_V := 1
POINT_V := 1
VERSION := ${MAJOR_V}.${MINOR_V}.${POINT_V}
BUILD_V := ${VERSION}-${FLAVOUR}

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
TAR_FLAGS  ?= -v
GZIP_FLAGS ?= -v -9

# These control which files are included in a release, in what order, and what
# the release tar ball is called.
DIST_FILES := ${REPO_FILES} ${MAKE_FILES} ${SRC}
DIST_DIR   := ${BIN}-${BUILD_V}
DIST_TGZ   := ${DIST_DIR}.tar.gz

# }}}

# COMPILATION {{{

# These define compiler options to be passed to the complier during the build
# process. These may be given on their own or with the specific value. These
# values are appended to the ${DEFINES} variable so any additions my be given on
# the commandline invocation of make.
DEFINES += ${FLAVOUR}                                                          \
           VERSION=\"${VERSION}\"                                              \
           _POSIX_C_SOURCE=200809L                                             \
           _DEFAULT_SOURCE                                                     \
           _BSD_SOURCE

# These define the types of warnings to provide during compilation and are
# passed to the compiler as -W options. By default most verbose warnings are
# enabled.
WARNINGS += all                                                                \
            extra                                                              \
            no-unused-function                                                 \
            no-unused-parameter                                                \
            no-unused-variable                                                 \
            implicit-fallthrough=4

# Adding 'error' to ${WARNINGS} will result in all warnings being treated as
# errors and halting the compilation process. This is desirable but not always
# possible, if this behaviour is desired, pass WARNINGS=error on the commandline
# invocation of make or uncomment this line.
#WARNINGS += error

# This defines the level and type of optimisation to use during compilation. The
# available options are '0', '1', '2', '3', 's', 'g', or 'fast'. The numbers
# result in increasingly higher optimisation and 0 being the default. Whereas
# 's' optimises for the size of the finished executable, this is only really
# recommended on embedded or vintage systems where RAM is extremely limited, as
# this may come with performance draw backs compared to a higher optimisation
# level. Using 'g' optimises the debugging experience, this may be useful during
# development but shouldn't really be used for distributed builds. Finally
# 'fast' optimises for speed disregarding safety or compliance, don't use this.
# Since this project aims to be a game with graphics rendering, it is
# recommended that the optimisation level used is '3'.
OPTIMISATION_LEVEL ?= 3

# These define the compilation language and language standard. Both of these are
# required options but my be overwritten in the command invocation. Note that
# this entire project is written assuming that these are set to 'c' and 'c99'.
LANGUAGE ?= c
STANDARD ?= c99

# This defines any dirs to search for included header files. By default the
# ${LIB} dirs are included in the search path, this is mainly so that the
# raycastlib and small3dlib libraries can be simply included as "normal" system
# headerfiles.
INCLUDES := ${LIB}

# These are the generic compiler options to control the compilation of ${BIN}
# and ${OBJ}. Note that these are added to any existing value of ${CFLAGS} so
# these may be configured further by passing value to the make invocation on the
# commandline.
CFLAGS += -g -pedantic                \
          ${DEFINES:%=-D%}            \
          ${WARNINGS:%=-W%}           \
          ${OPTIMISATION_LEVEL:%=-O%} \
          -x ${LANGUAGE}              \
          -std=${STANDARD}            \
          ${INCLUDES:%=-I%}

LDFLAGS += 

# This defines the C language compiler.
CC := c99

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
COPYRIGHT += ${LICENSE} (C) $$(date +%Y) ${AUTHOR} (${CONTACT})

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
PREFIX    ?= /usr/local
MANPREFIX ?= ${PREFIX}/share/man

# These directories are the full paths used for installation, ${DESTDIR} is not
# defined by default but may be provided on the command line in create a local
# installation, for example in a user's home directory or in a chroot
# environment.
BIN_DIR := ${DESTDIR}${PREFIX}/bin
MAN_DIR := ${DESTDIR}${MANPREFIX}/man1

# }}}

# MACRO COMMANDS {{{

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

# This is a command macro to substitute placeholder in generated files. This
# allows for the '<' and '>' shell output redirectors to effectively preform
# these substitutions effectively.
SUBSTITUTE := sed 's/__RELEASE__/${RELEASE}/g; \
                   s/__VERSION__/${VERSION}/g; \
                   s/__BIN__/${BIN}/g' | tee

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
# it. This is especially useful for automated test cases. It also allows the
# addition of other targets to the clean command, e.g. '${CLEAN} foo.h' will
# append the 'foo.h' header file to the ${TRASH} list for this call of ${CLEAN}.
CLEAN := ${DELETE} ${TRASH}

# This macro clears the current line of output, it allows for test cases or
# other processes that take a while to print a loading message and then clear it
# for the completion message.
CLEAR_LINE := printf '\33[2K\r'

# These macros encapsulate printing formatting for outputting simple formatted
# text from a target.
PRINTF := printf   '%s\n'
INDENT := printf '\t%s\n'

# This macro simplifies the process of converting a filename, for example, to an
# upper case single word symbol to be defined in the C preprocessor.
TO_UPPER := tr '[:lower:].' '[:upper:]_'

# }}}

# DEFAULT TARGETS {{{
# Note: this section must be after any configuration as it may require macros
# and variables to be loaded.

# This is the default target, show the configuration for the build and build the
# target but don't install or clean. Note that the dependencies are checked here
# at the beginning to catch any missing tools as early as possible, also note
# that the dependacies are only check here unless directly called via the
# 'depends_on_FOO' target actions.
all: check_dependencies config ${BIN}

# This is the 'config' target, it is used to display configuration information
# before a build begins or on its own for debugging purposes.
config:
	@${PRINTF} "${YELLOW}${BIN} build configuration:${RESET}"
	@${INDENT} "${GREEN}VERSION${RESET} = ${BOLD}${BUILD_V}${RESET}"
	@${INDENT} "${GREEN}BIN${RESET}     = ${BOLD}${BIN}${RESET}"
	@${INDENT} "${GREEN}LIB${RESET}     = ${BOLD}${LIB}${RESET}"
	@${INDENT} "${GREEN}SRC${RESET}     = ${BOLD}${SRC}${RESET}"
	@${INDENT} "${GREEN}HDR${RESET}     = ${BOLD}${HDR}${RESET}"
	@${INDENT} "${GREEN}OBJ${RESET}     = ${BOLD}${OBJ}${RESET}"
	@# DESTDIR SECTION {{{
	@# This section only shows the 'DESTDIR' if it has been set explicitly.
	@# It is in this position the ${BIN_DIR} and ${MAN_DIR} paths are set as
	@# subdirectories of ${DESTDIR}, although it has no default value unless
	@# set by the user. In that case we want to display it before displaying
	@# the ${BIN_DIR} and ${MAN_DIR} paths.
	@if [ -n "${DESTDIR}" ]                                              ; \
	then                                                                   \
	${INDENT}  "${GREEN}DESTDIR${RESET} = ${BOLD}${DESTDIR}${RESET}"     ; \
	fi
	@# DESTDIR SECTION }}}
	@${INDENT} "${GREEN}BIN_DIR${RESET} = ${BOLD}${BIN_DIR}${RESET}"
	@${INDENT} "${GREEN}MAN_DIR${RESET} = ${BOLD}${MAN_DIR}${RESET}"

# This target defines how to clean up an unneeded files generated during a
# build, it is useful for running manually during development and before an
# install as it forces all the dependencies to be rebuild fresh, preventing any
# old version from leaking into an install build.
clean:
	@${PRINTF} "${YELLOW}Cleaning build files...${RESET}"
	@# This replaces a plain call of ${CLEAN} by appending the config.h file
	@# to the clean macro to remove any old definitions during development.
	@if [ "${FLAVOUR}" = "DEBUG" ]                                       ; \
	then                                                                   \
		echo "${CLEAN} config.h"                                     ; \
		${CLEAN} config.h                                            ; \
	else                                                                   \
		echo "${CLEAN}"                                              ; \
		${CLEAN}                                                     ; \
	fi

# This target allows a quick and easy way of testing a ${BIN} target by
# incorporating the building and execution into a single stage.
run: config ${BIN}
	@./${BIN}

# The 'install' phony target acts as a master trigger for the installation
# actions, it allow for the order and prerequisites for a full install to be
# configured in a single place.
install: all install_man install_bin
	@${PRINTF} "${GREEN}Installation complete.${RESET}"

# The 'uninstall' phony target acts as the complementary action to the 'install'
# action. It defines any prerequisites and dependencies needed to uninstall the
# files created by the 'install' action.
uninstall: clean uninstall_man uninstall_bin
	@${PRINTF} "${GREEN}Uninstallation complete.${RESET}"

# }}}

# MAKE CONFIGURATION {{{

# These configurations are for make(1) and the makefiles that include this file.

# The .SILENT target makes the output of the make build process less verbose,
# only showing messages explicitly printed with echo statements or output from
# the complier for example. Uncomment the below lines to enable this behaviour
# if desired.
#.SILENT:

# This specifies the location of the shell to use, this should be something
# portable so that the build works without issues on all systems. Using /bin/sh
# has the added benefit of forcing you to use the POSIX Bourne Shell at all
# times and catches Bash-isms early, allowing more portable code in the build
# system to occur naturally.
SHELL := /bin/sh

# This target specifies that the these target should be built even if a file
# with the same file name exists, these targets specify action that should be
# given by the user or as dependencies of other actions.
.PHONY: all clean config run install uninstall

# }}}

