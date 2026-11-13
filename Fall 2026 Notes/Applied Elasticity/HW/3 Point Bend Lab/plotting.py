
import os
import numpy as np
import matplotlib.pyplot as plt

# Output folder
output_dir = r"C:\Users\zsong\Desktop\LaTex\Fall 2026 Notes\Applied Elasticity\HW\3 Point Bend Lab\Data"
os.makedirs(output_dir, exist_ok=True)

# Applied loads (N)
load = np.array([0, 500, 1000, 1500, 2000, 2500, 3000])

# Experimental measurements
exx = np.array([
    -1.23e-17, 0.000464049, 0.001028337,
    0.001471568, 0.001959212, 0.002462597, 0.002905788
]) * 1e6

V = np.array([
    0, -0.1764441, -0.3222928, -0.4613629,
    -0.60002, -0.7374526, -0.875343
])

eyy = np.array([
    3.63e-18, -0.0018905, -0.0016132,
    -0.0014176, -0.0013831, -0.0011845, -0.0010589
]) * 1e6

exy = np.array([
    -2.14e-18, 4.6468e-6, -2.618e-5,
    -6.315e-5, -9.645e-5, -0.0001557, -0.0001699
]) * 1e6

# Final measurements after unloading to 0 N
unloaded = {
    "exx": 0.00011782 * 1e6,
    "V": -0.0333974,
    "eyy": 0.00015041 * 1e6,
    "exy": 1.9705e-5 * 1e6
}


def plot_data(y, unloaded_y, title, ylabel, filename, show_fit=True):
    fig, ax = plt.subplots(figsize=(8, 5))

    # Loading measurements
    ax.scatter(load, y, label="Loading measurements", zorder=3)

    # Linear best fit (optional)
    if show_fit:
        slope, intercept = np.polyfit(load, y, 1)
        fit = slope * load + intercept

        ss_res = np.sum((y - fit)**2)
        ss_tot = np.sum((y - np.mean(y))**2)
        r2 = 1 - ss_res / ss_tot

        ax.plot(
            load, fit, "--",
            label=f"Linear fit ($R^2$ = {r2:.3f})"
        )

    # Final unloaded measurement
    ax.scatter(
        0, unloaded_y,
        marker="D", s=65,
        label="After unloading", zorder=4
    )

    ax.set_title(title)
    ax.set_xlabel("Applied Load (N)")
    ax.set_ylabel(ylabel)
    ax.grid(True, alpha=0.35)
    ax.legend()

    fig.tight_layout()
    fig.savefig(
        os.path.join(output_dir, filename),
        dpi=300, bbox_inches="tight"
    )
    plt.show()
    plt.close(fig)


plot_data(
    exx, unloaded["exx"],
    r"Axial Strain $\varepsilon_{xx}$ vs. Applied Load",
    r"Axial Strain $\varepsilon_{xx}$ ($\mu\varepsilon$)",
    "axial_strain.png"
)

plot_data(
    V, unloaded["V"],
    r"Transverse Deflection $V$ vs. Applied Load",
    r"Transverse Displacement $V$ (mm)",
    "transverse_deflection.png"
)


plot_data(
    eyy, unloaded["eyy"],
    r"Transverse Strain $\varepsilon_{yy}$ vs. Applied Load",
    r"Transverse Strain $\varepsilon_{yy}$ ($\mu\varepsilon$)",
    "transverse_strain.png",
    show_fit=False
)


plot_data(
    exy, unloaded["exy"],
    r"Mid-Beam Shear Strain $\varepsilon_{xy}$ vs. Applied Load",
    r"Shear Strain $\varepsilon_{xy}$ ($\mu\varepsilon$)",
    "shear_strain.png"
)
