from pathlib import Path
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Define path
csv_path = (
    Path(r"C:\Users\zsong\Desktop\LaTex\Fall 2026 Notes\Probability\HW\HW1 Pt2")
    / "coin_toss_results.csv"
)

# Load data
df = pd.read_csv(csv_path)
toss_counts = df["tosses_to_first_head_X"]

# Define range of x (at least up to 8 or your maximum trial outcome)
max_x = max(int(toss_counts.max()), 8)
x_vals = np.arange(1, max_x + 1)

# Calculate experimental relative frequency h(x)
total_trials = len(df)
freq_series = toss_counts.value_counts()
rel_freq = np.array([freq_series.get(x, 0) / total_trials for x in x_vals])

# Calculate theoretical PMF f(x) = (1/2)^x
pmf = (0.5) ** x_vals

# Plotting
bar_width = 0.35
indices = np.arange(len(x_vals))

plt.figure(figsize=(9, 5))

# Experimental relative frequency bars: Solid fill
plt.bar(
    indices - bar_width / 2,
    rel_freq,
    width=bar_width,
    label=f"Relative Frequency $h(x)$ ($n={total_trials}$)",
    color="steelblue",
    edgecolor="black",
    linewidth=1.2,
)

# Theoretical PMF bars: Hollow outline (no fill, distinct colored border)
plt.bar(
    indices + bar_width / 2,
    pmf,
    width=bar_width,
    label=r"Theoretical PMF $f(x) = (1/2)^x$",
    fill=False,
    edgecolor="crimson",
    linewidth=1.8,
    linestyle="--",
)

# Formatting
plt.xticks(indices, x_vals)
plt.xlabel("Number of Flips to First Head ($x$)", fontsize=11)
plt.ylabel("Relative Frequency / Probability", fontsize=11)
plt.title(
    "Comparison of Experimental Relative Frequency vs. Theoretical p.m.f. (1.1-10)",
    fontsize=12,
)
plt.ylim(0, max(rel_freq.max(), pmf.max()) + 0.1)
plt.grid(axis="y", linestyle=":", alpha=0.6)
plt.legend(frameon=True)
plt.tight_layout()

# Save a high-res figure in the same folder for LaTeX inclusion
save_fig_path = csv_path.parent / "histogram_pmf_comparison.png"
plt.savefig(save_fig_path, dpi=300)
print(f"Plot saved to: {save_fig_path}")

plt.show()