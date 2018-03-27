#!env python3

import sys
import pyperclip

string_to_copy = ''.join(sys.stdin.readlines())
pyperclip.copy(string_to_copy)
