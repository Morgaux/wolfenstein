#
# Main makefile for my Wolfenstein 3D clone
#

# This is the main configuration file, it must be included first as it defines
# all needed targets, variables, macros, and make(1) settings.
include config.mk

# This is an optional file that defines some formatting eye candy to allow
# colouring the output of certain commands. At time of writing this is
# accomplished using 'tput' and is created to fail gracefully.
include colors.mk

# This file defines the default skeletons of new sources when new modules or
# tests are being added.
include source.mk

# This file defines all compilation related targets, it depends internally on
# the config.mk file but doesn't included it so it may be used as part of a
# parallel build system in the future, e.g. for unit testing.
include build.mk

# This file provides a method of asserting the existence of external tools and
# allowing useful and user friendly error messages, e.g. for git(1).
include dependencies.mk 

# This file provides the information needed to generate to relevant
# documentation files for Wolfenstein3D.
include documentation.mk

# This file defines the implementations of the installation actions, these are
# provided as install_FOO or uninstall_BAR phony targets and as such the
# implementations are separated from the installation logic.
include installation.mk

# This file defines all test cases and testing structures to run automation
# tests on all components of this repository, including the makefile system
# itself, save of course for the tests.mk file itself. To test any given
# component, run:
# 	make test_FOO
# or, to run the full test suit, run:
# 	make test
# or, for a list of all testable components and their invocations, run:
# 	make test_help
include tests.mk

