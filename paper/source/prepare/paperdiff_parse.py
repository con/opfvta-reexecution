import csv
import re

# This should be dynamically/empirically determined, perhaps with a blank page of a colour which is certain to not appear in the document.
# For now we rely on the fact that we explicitly rasterize at 300dpi in the diff generation script (this could be different);
# and that we know this is outputted to a4 paper (this could also be different).
pixels_total = 8699840

parser = "^page (?P<page>[0-9]+) has (?P<pixels>[0-9]+) pixels that differ$"

parsed_list = [
    ["Page", "Pixels Differ [N]", "Differing Pixels Proportion"],
    ]
with open("../data/paperdiff.log") as f:
    for line in f:
        print(line)
        try:
            m = re.match(parser, line).groupdict()
        except AttributeError:
            continue
        pixels_differ_proportion = int(m["pixels"]) / pixels_total
        pixels_differ_proportion = float("{:.5f}".format(pixels_differ_proportion))
        #pixels_differ_percent = pixels_differ_proportion * 100
        # Adding 1 to the page number to obtain the same numbering as in the document itself.
        parsed_list.append([int(m["page"])+1, m["pixels"], pixels_differ_proportion])

with open("../data/paperdiff.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(parsed_list)
