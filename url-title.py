#!env python3
# pip install urltitle

from urltitle import URLTitleReader

reader = URLTitleReader(verify_ssl=True)

# Titles for HTML content
title = reader.title('https://www.cnn.com/2019/02/11/health/insect-decline-study-intl/index.html')
print(title)
