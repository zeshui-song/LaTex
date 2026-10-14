import control as ct
import matplotlib.pyplot as plt
import numpy as np

# ============================================================
# Root Locus Demo
# ============================================================

s = ct.tf("s")

# Systems
G1 = 1 / (s**2 + 1)
G2 = (s + 1) / (s**2 + 1)
G3 = 1 / ((0.1 * s + 1) * (s**2 + 1))

systems = [
    (G1, r"$G(s)=\frac{1}{s^2+1}$"),
    (G2, r"$G(s)=\frac{s+1}{s^2+1}$"),
    (G3, r"$G(s)=\frac{1}{(0.1s+1)(s^2+1)}$"),
]

# Gain range
gains = np.logspace(-4, 4, 2000)

for G, title in systems:
    plt.figure(figsize=(7, 6))

    ct.root_locus_plot(G, gains=gains, grid=True)

    plt.title(title, fontsize=14)
    plt.xlabel(r"Real Axis")
    plt.ylabel(r"Imaginary Axis")

    plt.axvline(0, linewidth=1)
    plt.axhline(0, linewidth=1)

    # plt.tight_layout()

plt.show()
