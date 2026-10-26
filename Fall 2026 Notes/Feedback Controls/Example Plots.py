
import numpy as np
import matplotlib.pyplot as plt

K = 2
tau_values = [0.5, 1, 2]
t = np.linspace(-0.5, 6, 1000)

u = (t >= 0).astype(float)

def response(t, tau):
    return K * (1 - np.exp(-np.maximum(t, 0) / tau)) * (t >= 0)

fig, ax = plt.subplots(
    2, 1, figsize=(9, 5.5), sharex=True,
    gridspec_kw={'height_ratios': [1, 2]}
)

# Unit step input
ax[0].step(t, u, where='post', color='black', linewidth=2)
ax[0].set_ylabel(r'$u(t)$')
ax[0].set_ylim(-0.1, 1.2)
ax[0].set_title('Unit Step Input')
ax[0].grid(True, alpha=0.2)

# First-order outputs
styles = ['-', '--', '-.']

for tau, style in zip(tau_values, styles):
    ax[1].plot(
        t, response(t, tau),
        linestyle=style, linewidth=2,
        label=fr'$\tau={tau}$ s'
    )

# Steady-state gain
ax[1].axhline(K, color='gray', linestyle=':', linewidth=1.5)
ax[1].text(5.9, K + 0.06, r'$K=2$', ha='right')

# Reference tau = 1 s
for n in range(1, 5):
    ax[1].text(n, -0.12, fr'${n}\tau$',
               ha='center', fontsize=10)

ax[1].set_title('First-Order System Response')
ax[1].set_xlabel('Time (s)')
ax[1].set_ylabel(r'$y(t)$')
ax[1].set_xlim(-0.5, 6)
ax[1].set_ylim(-0.2, 2.3)
ax[1].legend(loc='lower right')
ax[1].grid(True, alpha=0.2)

plt.tight_layout()
plt.savefig(r'C:\Users\zsong\Desktop\LaTex\Fall 2026 Notes\Feedback Controls\first_order_response.png', dpi=300, bbox_inches='tight')
plt.show()


