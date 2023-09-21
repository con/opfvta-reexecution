import csv
import os
import re

DATADIR='../data'
PARSER = '^page (?P<page>[0-9]+) has (?P<pixels>[0-9]+) pixels that differ$'
PARSED_LIST = [
    ['Page', 'Pixels Differ [N]', 'Differing Pixels Proportion', 'Date', 'Environment'],
    ]


# This should be dynamically/empirically determined, perhaps with a blank page of a colour which is certain to not appear in the document.
# For now we rely on the fact that we explicitly rasterize at 300dpi in the diff generation script (this could be different);
# and that we know this is outputted to a4 paper (this could also be different).
pixels_total = 8699840

for i in os.listdir(DATADIR):
    try:
        execution_metadata = re.match('^paperdiff_(?P<environment>.+)_(?P<date>.+)\.log$', i).groupdict()
    except AttributeError:
        continue
    print(f'Processing paperdiff log file `{i}`...')
    with open(os.path.join(DATADIR,i)) as f:
        for line in f:
            try:
                m = re.match(PARSER, line).groupdict()
            except AttributeError:
                continue
            pixels_differ_proportion = int(m['pixels']) / pixels_total
            pixels_differ_proportion = float('{:.6f}'.format(pixels_differ_proportion))
            #pixels_differ_percent = pixels_differ_proportion * 100
            # Adding 1 to the page number to obtain the same numbering as in the document itself.
            PARSED_LIST.append([
                int(m['page'])+1,
                m['pixels'],
                pixels_differ_proportion,
                execution_metadata['date'],
                execution_metadata['environment'],
                ])

with open('../data/paperdiff.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(PARSED_LIST)
