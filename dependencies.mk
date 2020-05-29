#
# Programmatically check for programs the build depends on
#

# DEPENDENCY DETECTION {{{

# This variable defines any external programs that should be checked for, to add
# this as a check, add 'depends_on_FOO' as a dependency for the target in
# question, where FOO is defined in ${DEPENDENCIES}. This will trigger the check
# target for that tool which will provide a clear error message and halt the
# build progress. These may be added to on the commandline.
DEPENDENCIES += git sed tar gzip grep tee timeout

# This target is run for every call of 'depends_on_FOO' for 'FOO's in
# ${DEPENDENCIES}, passing 'FOO' as $<. This allow a shell to check for 'FOO' in
# the current system $PATH. If missing or not found to be executable, a message
# is shown.
${DEPENDENCIES:%=depends_on_%}:
	@if [ ! -x "$$(command -v "${@:depends_on_%=%}")" ]                  ; \
	then                                                                   \
		${PRINTF} "${RED}ERROR:${RESET}"                               \
		          "${BOLD}${WOLF_3D}${RESET} depends on"               \
		          "${YELLOW}${@:depends_on_%=%}${RESET}"             ; \
		exit 1                                                       ; \
	fi

check_dependencies: ${DEPENDENCIES:%=depends_on_%}

.PHONY: check_dependencies ${DEPENDENCIES} ${DEPENDENCIES:%=depends_on_%}

# }}}

