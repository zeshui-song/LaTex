
clc; clear; close all;

s = tf('s');
P = 1/((s+1)*(0.2*s+1)*(0.1*s+1));

C1 = 2.5*(0.1 + 1/s);
C2 = 2.5*(1 + 1/s);
C3 = 2.5*(1 + 1/(10*s));

L1 = P*C1;
L2 = P*C2;
L3 = P*C3;

% Gain and phase margins
[Gm1, Pm1, Wcg1, Wcp1] = margin(L1);
[Gm2, Pm2, Wcg2, Wcp2] = margin(L2);
[Gm3, Pm3, Wcg3, Wcp3] = margin(L3);

fprintf('C1: GM = %.2f dB, PM = %.2f deg\n', 20*log10(Gm1), Pm1);
fprintf('C2: GM = %.2f dB, PM = %.2f deg\n', 20*log10(Gm2), Pm2);
fprintf('C3: GM = %.2f dB, PM = %.2f deg\n', 20*log10(Gm3), Pm3);

% Bode plots
figure(1);
bode(L1,L2,L3);
grid on;
legend('C1','C2','C3');

%% Closed-loop step responses (Exercise 1b)
figure(2);
hold on;
step(feedback(L1,1));
step(feedback(L2,1));
step(feedback(L3,1));
grid on;
legend('C1','C2','C3');

%% Nyquist plots
figure(3);
nyquist(L1,L2,L3);
xlim([-2 2]);
ylim([-2 2]);
legend('C1','C2','C3');
hold on;

theta = linspace(0, 2*pi, 100);
x = cos(theta);
y = sin(theta);

plot(x, y, 'k--', 'LineWidth', 1.5);