import numpy as np
import matplotlib.pyplot as plt

## Part A

# Given values (SI units)
h = 0.200       # m
t = 0.076       # m
L = 1.0         # m
p = 10000       # N/m

# Coordinates
x = np.linspace(0, L, 200)
y = np.linspace(-h, h, 200)
x_Q = 3 * L / 4
y_Q = h / 2

# Internal shear and bending moment
V = -p * x
M = p * x**2 / 2

# Stress equations (Pa)
def sigma(x, y):
    return - 3 * p * x**2 * y / (4 * t * h**3)

def tau(x, y):
    return -3 * p * x * (h**2 - y**2) / (4 * t * h**3)

# Figure 1: Shear force and bending moment
fig, ax = plt.subplots(1, 2, figsize=(11, 4))

ax[0].plot(x, V / 1000)
ax[0].set_title("Shear Force V(x)")
ax[0].set_xlabel("x (m)")
ax[0].set_ylabel("V (kN)")

ax[1].plot(x, M / 1000)
ax[1].set_title("Bending Moment M(x)")
ax[1].set_xlabel("x (m)")
ax[1].set_ylabel("M (kN m)")

for a in ax:
    a.grid(True)

fig.tight_layout()

# Figure 2: Stress distributions
fig, ax = plt.subplots(2, 2, figsize=(11, 8))

ax[0, 0].plot(y, sigma(x_Q, y) / 1e6)
ax[0, 0].set_title("Normal Stress at x = 3L/4")
ax[0, 0].set_xlabel("y (m)")
ax[0, 0].set_ylabel("Sigma x (MPa)")

ax[0, 1].plot(y, tau(x_Q, y) / 1e6)
ax[0, 1].set_title("Shear Stress at x = 3L/4")
ax[0, 1].set_xlabel("y (m)")
ax[0, 1].set_ylabel("Tau xy (MPa)")

ax[1, 0].plot(x, sigma(x, -h) / 1e6)
ax[1, 0].set_title("Normal Stress Along Top Surface (y = -h)")
ax[1, 0].set_xlabel("x (m)")
ax[1, 0].set_ylabel("Sigma x (MPa)")

ax[1, 1].plot(x, tau(x, 0) / 1e6)
ax[1, 1].set_title("Shear Stress Along Centerline (y = 0)")
ax[1, 1].set_xlabel("x (m)")
ax[1, 1].set_ylabel("Tau xy (MPa)")

for a in ax.flat:
    a.grid(True)

fig.tight_layout()
plt.show()

# Stresses at point Q
print(f"Point Q: x = {x_Q:.3f} m, y = {y_Q:.3f} m")
print(f"Sigma x at Q = {sigma(x_Q, y_Q)/1e6:.4f} MPa")
print(f"Tau xy at Q = {tau(x_Q, y_Q)/1e6:.4f} MPa")

## Part C

# Elasticity stress equations (Pa)
def sigma_el(x, y):
    return -3*p*y/(10*t*h) + p*y**3/(2*t*h**3) - 3*p*x**2*y/(4*t*h**3)

def tau_el(x, y):
    return -3*p*x/(4*t*h) + 3*p*x*y**2/(4*t*h**3)

def sigma_y_el(x, y):
    return -p/(2*t) + 3*p*y/(4*t*h) - p*y**3/(4*t*h**3)

# Figure 3: MechMat vs Elasticity
fig, ax = plt.subplots(2, 2, figsize=(11, 8))

ax[0, 0].plot(y, sigma(x_Q, y)/1e6, label="MechMat")
ax[0, 0].plot(y, sigma_el(x_Q, y)/1e6, '--', label="Elasticity")
ax[0, 0].set_title("Normal Stress at x = 3L/4")
ax[0, 0].set_xlabel("y (m)")
ax[0, 0].set_ylabel("Sigma x (MPa)")

ax[0, 1].plot(y, tau(x_Q, y)/1e6, label="MechMat")
ax[0, 1].plot(y, tau_el(x_Q, y)/1e6, '--', label="Elasticity")
ax[0, 1].set_title("Shear Stress at x = 3L/4")
ax[0, 1].set_xlabel("y (m)")
ax[0, 1].set_ylabel("Tau xy (MPa)")

ax[1, 0].plot(x, sigma(x, -h)/1e6, label="MechMat")
ax[1, 0].plot(x, sigma_el(x, -h)/1e6, '--', label="Elasticity")
ax[1, 0].set_title("Normal Stress Along Top Surface (y = -h)")
ax[1, 0].set_xlabel("x (m)")
ax[1, 0].set_ylabel("Sigma x (MPa)")

ax[1, 1].plot(x, tau(x, 0)/1e6, label="MechMat")
ax[1, 1].plot(x, tau_el(x, 0)/1e6, '--', label="Elasticity")
ax[1, 1].set_title("Shear Stress Along Centerline (y = 0)")
ax[1, 1].set_xlabel("x (m)")
ax[1, 1].set_ylabel("Tau xy (MPa)")

for a in ax.flat:
    a.grid(True)
    a.legend()

fig.tight_layout()
plt.show()

# Stress comparison at point Q
print("\nPart C: Stress Comparison at Q (MPa)")
print(f"MechMat:    Sigma x = {sigma(x_Q, y_Q)/1e6:.4f}, Tau xy = {tau(x_Q, y_Q)/1e6:.4f}")
print(f"Elasticity: Sigma x = {sigma_el(x_Q, y_Q)/1e6:.4f}, Sigma y = {sigma_y_el(x_Q, y_Q)/1e6:.4f}, Tau xy = {tau_el(x_Q, y_Q)/1e6:.4f}")

## Part E

# Vary beam length, keeping h, t, p constant
lengths = [0.4, 0.6, 1.0, 2.0]

# Figure 4: Compare stress distributions at different lengths
fig, ax = plt.subplots(2, 2, figsize=(11, 8))

for i, length in enumerate(lengths):
    x_new = np.linspace(0, length, 200)

    ax.flat[i].plot(x_new, sigma(x_new, -h)/1e6, label="MechMat")
    ax.flat[i].plot(x_new, sigma_el(x_new, -h)/1e6, '--', label="Elasticity")

    ax.flat[i].set_title(f"L = {length} m, L/(2h) = {length/(2*h):.2f}")
    ax.flat[i].set_xlabel("x (m)")
    ax.flat[i].set_ylabel("Sigma x (MPa)")
    ax.flat[i].grid(True)
    ax.flat[i].legend()

fig.tight_layout()
plt.show()

# Calculate maximum percent difference for varying lengths
length_range = np.linspace(0.2, 3.0, 300)
percent_diff = []

for length in length_range:
    x_new = np.linspace(0, length, 200)
    X, Y = np.meshgrid(x_new, y)

    stress_mm = sigma(X, Y)
    stress_el = sigma_el(X, Y)

    # Maximum absolute difference between the models
    max_difference = np.max(np.abs(stress_el - stress_mm))

    # Maximum absolute MechMat axial stress
    max_stress_mm = np.max(np.abs(stress_mm))

    # Percent difference
    percent = max_difference / max_stress_mm * 100
    percent_diff.append(percent)

percent_diff = np.array(percent_diff)
ratio = length_range / (2*h)

# Figure 5: Percent difference vs length-to-depth ratio
plt.figure(figsize=(8, 5))

plt.plot(ratio, percent_diff, label="Maximum Percent Difference")
plt.axhline(10, color="red", linestyle="--", label="10% Threshold")

plt.xlabel("Length-to-Depth Ratio L/(2h)")
plt.ylabel("Percent Difference (%)")
plt.title("Effect of Beam Length on Stress Difference")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()

# Find 10% threshold by interpolation
threshold_ratio = np.interp(10, percent_diff[::-1], ratio[::-1])
threshold_length = threshold_ratio * 2*h

print(f"10% threshold at L/(2h) = {threshold_ratio:.3f}")
print(f"Corresponding beam length L = {threshold_length:.3f} m")
print(f"Difference exceeds 10% for L/(2h) < {threshold_ratio:.3f}")