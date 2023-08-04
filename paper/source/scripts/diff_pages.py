import os
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
sns.set_theme(style='whitegrid')

filename = os.path.splitext(os.path.basename(__file__))[0]

df = pd.read_csv('../data/paperdiff.csv',
	index_col=1,
	parse_dates=True,
	)


def colors_from_values(df, column, palette_name):
    values = df[column]
    # normalization
    normalized = (values - min(values)) / (max(values) - min(values))
    # convert to indices
    indices = np.round(normalized * (len(values) - 1)).astype(np.int32)
    # index-based colors
    palette = sns.color_palette(palette_name, len(values))
    return np.array(palette).take(indices, axis=0)

sns.barplot(data=df,
	x='Page',
	y='Differing Pixels Proportion',
	palette=colors_from_values(df,
			    'Differing Pixels Proportion',
			    'flare',
			    ),
	)
plt.yscale('log')

plt.savefig(os.path.join('..','figs',f'{filename}.pdf'))
