clc; clear; close all;

%% Part 1: motor speed controller design

%% Bode plot of open loop motor system:
s = tf('s');


%given parameters
R = 8.4; % ohms
L = 0.00116 % H
km = 0.042; % N*m/A
kb = 0.042; % V*s/rad
B = 0; %assume no viscous damping

%calculate inertia
Jm = 4.65e-6; % kg*m^2 motor inertia

md = 0.053; %kg disc mass
rd = 0.0248; %m disc radius

Jd = 0.5*md*rd^2; % disc inertia

J = Jm + Jd; % total inertia

%motor transfer function
P = km/ ( J*L*s^2 + (J*R+B*L)*s + (B*R + km*kb) )
figure;
bode(P);
margin(P);

%% Calculate bandwidth
fb = bandwidth(P);
fprintf('Bandwidth of the open loop motor system: %.4f rad/s\n', fb);

%% Calculate crossover frequency
[Gm, Pm, Wcg, Wcp] = margin(P);
fprintf('Gain crossover frequency: %.4f rad/s\n', Wcp);

%% Calculating the damping:
%characteristic eqn  of open loop:   2.43e-08 s^2 + 0.000176 s + 0.001764

% compare with standard form: s^2 + 2*zeta*wn*s + wn^2
wn = sqrt(0.001764/ (2.43e-08));
zeta = (0.000176/ (2.43e-08))/(2*wn)

%% Time constants
poles = pole(P);
fprintf('Pole 1: %.4f\n', poles(1));
fprintf('Pole 2: %.4f\n', poles(2));
tau1 = -1/poles(1)
tau2 = -1/poles(2)
%% Step response of the open loop system
figure;
[y, t] = step(P);
y_final = y(end);
y_tau = 0.6321 * y_final;
% Find the time index closest to 63.2% of y_final
[~, idx] = min(abs(y - y_tau));
t_tau = t(idx);

figure;
plot(t, y, 'b-', 'LineWidth', 1.5);
hold on;
grid on;

% Add horizontal and vertical marker lines for tau
plot([0, t_tau, t_tau], [y_tau, y_tau, 0], 'r--', 'LineWidth', 1.2);
plot(t_tau, y_tau, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
fprintf('Time constant (tau): %.4f seconds\n', t_tau);

%% Find the gain Kp such that the closed loop system is critically damped
figure;
rlocus(P); %Kp when critically damped is when both poles are equal

Kp = 7.54;

%% Closed loop steady state error
C = Kp;
L = C*P;
%error transfer function
E = 1/(1+L);
%steady state error for step input
ess = evalfr(E, 0);
fprintf('Steady state error for step input: %.4f\n', ess);
%steady state error for ramp input
ess_ramp = evalfr(E*1/s, 0);
fprintf('Steady state error for ramp input: %.4f\n', ess_ramp);

%% Closed loop phase margin
[Gm, Pm, Wcg, Wcp] = margin(L);
fprintf('Closed loop phase margin: %.2f degrees\n', Pm);

%% Part 2: motor position controller design
P_p = P/s; %position transfer function
L_p = C*P_p;
%open loop bode plot
figure;
bode(P_p);
margin(P_p);
%open loop nyquist plot
figure;
nyquist(P_p);
xlim([-6 6]);
ylim([-6 6]);

%% Gain needed for PM=60 deg
current = evalfr(P_p, i*13.9)

