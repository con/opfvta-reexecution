import os
import re

def open_and_read(in_file):
    with open(in_file, "r") as in_file:
        lines = in_file.readlines()
    return lines

def include_sub_files(in_file, my_text="", exclude_comments=True):
    lines = open_and_read(in_file)
    for line in lines:
        m = re.match("\\\\input{(?P<sub_file>.+)}",line)
        if m:
            sub_file = m.groupdict()['sub_file']
            my_text = include_sub_files(sub_file,
                my_text=my_text,
                exclude_comments=exclude_comments,
                )
        else:
            if exclude_comments:
                if line.startswith("%"):
                    continue
            my_text += line

    return my_text

out_text = include_sub_files('article-frontiers.tex')

with open("article-frontiers-onefile.tex", "w") as out_file:
    out_file.write(out_text)
    out_file.close()
