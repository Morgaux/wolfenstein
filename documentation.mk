#
# This file defines the creation and formatting of wolfenstein3D
#

# DOCUMENTATION CREATION MACROS {{{
# These macros define the formatting commands of the documentation file.

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

# }}}

# DOCUMENTATION CREATION TARGETS {{{

# This target generates a troff manpage for installation of a manpage for
# wolfenstein3D. This follows the standard Unix documentation conventions.
${WOLF_3D:%=%.1}:
	@echo "${YELLOW}Generating $@ manpage...${RESET}"
	@{                                                                     \
		echo "${MAN_COMMENT} Manpage for ${WOLF_3D}"                 ; \
		echo "${MAN_COMMENT} Contact ${CONTACT}"                       \
		     "to correct any errors or typos."                       ; \
		echo "${MAN_TITLE} man 1"                                      \
		     "\"${DATE}\""                                             \
		     "\"${BUILD_V}\""                                          \
		     "\"${WOLF_3D} man page\""                               ; \
		echo "${MAN_SECTION} NAME"                                   ; \
		echo "${WOLF_3D} \- A simple clone of Wolfenstien 3D by id     \
		      software."               ; \
		echo "${MAN_SECTION} SYNOPSIS"                               ; \
		echo "${MAN_BOLD_WORD}${WOLF_3D}"                            ; \
		echo "${MAN_SECTION} DESCRIPTION"                            ; \
		echo "${WOLF_3D} is a pet project to explore Raytracing and    \
		      other rudimentary aspects of early game graphics. It is  \
		      mostly written in C using the excellent raycastlib and   \
		      small3dlib by Miloslav Ciz (tasyfish.cz)."             ; \
		echo "${MAN_SECTION} OPTIONS"                                ; \
		echo "${WOLF_3D} takes no options at this time."             ; \
		echo "${MAN_SECTION} SEE ALSO"                               ; \
		echo "raycastlib.h small3dlib.h"                             ; \
		echo "${MAN_SECTION} BUGS"                                   ; \
		echo "NONE (for now...)"                                     ; \
		echo "${MAN_SECTION} AUTHOR"                                 ; \
		echo "${AUTHOR}"                                             ; \
	} | ${CREATE} $@

# }}}

