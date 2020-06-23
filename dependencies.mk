#
# Programmatically check for programs the build depends on
#

DEPENDENCIES := git sed tar gzip
_DEP_CHECKS_ := ${DEPENDENCIES:%=depends_on_%}

# do nothing if invoked
${DEPENDENCIES}: ;

${_DEP_CHECKS_}: depends_on_% : %
	@if [ ! -x "$$(command -v $<)" ] ;          \
	then                                         \
		echo "${RED}ERROR:${RESET}"          \
		     "${BOLD}${BIN}${RESET}"         \
		     "depends on"                    \
		     "${YELLOW}${BOLD}$<${RESET}" ; \
		exit 1 ;                             \
	fi

.PHONY: ${DEPENDENCIES} ${_DEP_CHECKS_}

