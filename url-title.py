#!env python3
# https://github.com/impredicative/urltitle
# pip install urltitle
from urltitle import URLTitleReader
import sys

try: url = sys.argv[1]
except IndexError: print("Error: URL argument is required", file=sys.stderr); sys.exit(100)

reader = URLTitleReader(verify_ssl=True)

# Titles for HTML content
title = reader.title(url)
print(title)
