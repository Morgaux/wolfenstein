#
# This file manages the installation of my Wolfenstein clone components
#

# MANPAGE INSTALLATION {{{

# The 'install_man' phony target is used to install the ${MAN} page to the
# system's manpage database. To ensure a clean installation, the old manpage is
# first uninstalled from the system. Note that this action may require root
# privileges.
install_man: ${MAN} uninstall_man
	@${PRINTF} "${YELLOW}Installing ${MAN_DIR}/$< manpage...${RESET}"
	mkdir -p ${MAN_DIR}
	cp -f $< ${MAN_DIR}/$<
	chmod 644 ${MAN_DIR}/$<

# The 'uninstall_man' phony target is used to uninstall the ${MAN} page by
# removing it from the installed directories. Note that this action may require
# root privileges.
uninstall_man:
	@${PRINTF} "${YELLOW}Uninstalling ${MAN} manpage...${RESET}"
	rm -f ${MAN_DIR}/${MAN}

# }}}

# BINARY INSTALLATION {{{

# The 'install_bin' phony target is used to install the ${WOLF_3D} executable to
# the defined system path and make it executable, upon completion the user
# should be able to run the ${WOLF_3D} from their shell by invoking it as
# defined in the ${MAN} manpage and not just locally. Note that this action may
# require root privileges.
install_bin: ${WOLF_3D} uninstall_bin
	@${PRINTF} "${YELLOW}Installing ${BIN_DIR}/${WOLF_3D}...${RESET}"
	mkdir -p ${BIN_DIR}
	cp -f ${WOLF_3D} ${BIN_DIR}/.
	chmod 755 ${BIN_DIR}/${WOLF_3D}

# The 'uninstall_bin' phony target is used to uninstall the ${BIN} executable
# installed by the 'install_bin' target. Note that this action may require root
# privileges.
uninstall_bin:
	@${PRINTF} "${YELLOW}Uninstalling ${BIN_DIR}/${WOLF_3D}...${RESET}"
	rm -f ${BIN_DIR}/${WOLF_3D}

# }}}

.PHONY: install_man install_bin uninstall_man uninstall_bin

