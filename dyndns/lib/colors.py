
#https://stackoverflow.com/questions/37340049/how-do-i-print-colored-output-to-the-terminal-in-python

#https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

RED   = "\033[1;31m"
BLUE  = "\033[1;34m"
YELLOW = "\033[1;33m"
CYAN   = "\033[1;36m"
GREEN  = "\033[0;32m"
RESET  = "\033[0;0m"
BOLD    = "\033[;1m"
REVERSE = "\033[;7m"

# import sys
# from colors import *
# 
# sys.stdout.write(RED)
# print "All following prints rendered in red, until changed"
# 
# sys.stdout.write(REVERSE + CYAN)
# print "From now on change to cyan, in reverse mode"
# print "NOTE: 'CYAN + REVERSE' wouldn't work"
# 
# sys.stdout.write(RESET)
# print "'REVERSE' and similar modes need be reset explicitly"
# print "For color alone this is not needed; just change to new color"
# print "All normal prints after 'RESET' above."


