#
# Color declarations for colourful output (if supported)
#

RESET   = $$([ -x "$$(command -v tput)" ] && tput sgr0        2>/dev/null)
BLACK   = $$([ -x "$$(command -v tput)" ] && tput setaf 0 0 0 2>/dev/null)
RED     = $$([ -x "$$(command -v tput)" ] && tput setaf 1 0 0 2>/dev/null)
GREEN   = $$([ -x "$$(command -v tput)" ] && tput setaf 2 0 0 2>/dev/null)
YELLOW  = $$([ -x "$$(command -v tput)" ] && tput setaf 3 0 0 2>/dev/null)
BLUE    = $$([ -x "$$(command -v tput)" ] && tput setaf 4 0 0 2>/dev/null)
MAGENTA = $$([ -x "$$(command -v tput)" ] && tput setaf 5 0 0 2>/dev/null)
CYAN    = $$([ -x "$$(command -v tput)" ] && tput setaf 6 0 0 2>/dev/null)
WHITE   = $$([ -x "$$(command -v tput)" ] && tput setaf 7 0 0 2>/dev/null)
BOLD    = $$([ -x "$$(command -v tput)" ] && tput bold        2>/dev/null)

