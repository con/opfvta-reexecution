from pdfminer.high_level import extract_text
import re

text = extract_text('article.pdf')
with open('article.pdf','rb') as f:
	text = extract_text(f)
	print(text)
	#line_text = text.split("\n")
	#for i in line_text:
	#	if re.search('[a-zA-Z]', i):
	#		print(i)
