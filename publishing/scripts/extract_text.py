from pdfminer.high_level import extract_text

text = extract_text('article.pdf')
with open('article.pdf','rb') as f:
    text = extract_text(f)
    print(text)
