#
# This file manages the installation of my Wolfenstein clone components
#

# MANPAGE INSTALLATION {{{

# The 'install_man' phony target is used to install the ${MAN} page to the
# system's manpage database. To ensure a clean installation, the old manpage is
# first uninstalled from the system. Note that this action may require root
# privileges.
install_man: ${MAN} uninstall_man depends_on_sed
	@${PRINTF} "${YELLOW}Installing ${MAN} manpage...${RESET}"
	mkdir -p ${MAN_DIR}
	cat ${MAN} | ${SUBSTITUTE}  > ${MAN_DIR}/${MAN}
	chmod 644 ${MAN_DIR}/${MAN}

# The 'uninstall_man' phony target is used to uninstall the ${MAN} page by
# removing it from the installed directories. Note that this action may require
# root privileges.
uninstall_man:
	@${PRINTF} "${YELLOW}Uninstalling ${MAN} manpage from ${MAN_DIR}...${RESET}"
	rm -f ${MAN_DIR}/${MAN}

# }}}

# BINARY INSTALLATION {{{

# The 'install_bin' phony target is used to install the ${BIN} executable to the
# defined system path and make it executable, upon completion the user should be
# able to run the ${BIN} from their shell by invoking it as defined in the
# ${MAN} page and not just locally. Note that this action may require root
# privileges.
install_bin: ${BIN} uninstall_bin
	@${PRINTF} "${YELLOW}Installing ${BIN}...${RESET}"
	mkdir -p ${BIN_DIR}
	cp -f ${BIN} ${BIN_DIR}/.
	chmod 755 ${BIN_DIR}/${BIN}

# The 'uninstall_bin' phony target is used to uninstall the ${BIN} executable
# installed by the 'install_bin' target. Note that this action may require root
# privileges.
uninstall_bin:
	@${PRINTF} "${YELLOW}Uninstalling ${BIN} from ${BIN_DIR}...${RESET}"
	rm -f ${BIN_DIR}/${BIN}

# }}}

.PHONY: install_man install_bin uninstall_man uninstall_bin

