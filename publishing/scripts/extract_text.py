from pdfminer.high_level import extract_text
import re

#text = extract_text('article.pdf')
with open('article-frontiers-onefile-filtered.pdf','rb') as f:
	text = extract_text(f)
	#print(text)
	text_lines = text.split("\n")
	with open("textonly.txt", "a") as f:
		for line in text_lines:
			if not re.match("^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", line) and not re.match("^Page [0-9]+ of [0-9]+", line):
				print(line)
				f.write(f"{line}\n")
		#print(text, file=f)
	#line_text = text.split("\n")
	#for i in line_text:
	#	if re.search('[a-zA-Z]', i):
	#		print(i)
