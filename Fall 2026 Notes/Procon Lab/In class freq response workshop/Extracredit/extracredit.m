clc; clear; close all;
%% Problem 8
s = tf('s');
P = 10/((s+1)*(s+4));

% Bode plot and stability margins
figure;
margin(P);
grid on;

[Gm, Pm, Wcg, Wcp] = margin(P);

fprintf('Uncompensated specs:\n');
fprintf('Gain crossover frequency: %.4f rad/s\n', Wcp);
fprintf('Phase margin: %.2f degrees\n', Pm);

% Closed-loop step response
T = feedback(P, 1);

figure;
step(T);
grid on;
title('Uncompensated Step Response');

% Step response specs
stepinfo(T)

% Steady-state error for unit step
ess = 1 - dcgain(T);
fprintf('Steady-state error: %.4f\n', ess);

%% Designing a Lead Compensator
K_c = 20; 
C = K_c*(s+2)/(s+8);
L = C*P;

figure;
margin(L);
grid on;

[Gm, Pm, Wcg, Wcp] = margin(L);
fprintf('\n');
fprintf('Lead Compensated specs:\n');
fprintf('Gain crossover: %.2f rad/s\n', Wcp);
fprintf('Phase margin: %.2f degrees\n', Pm);


%% Lag Compensation
C_lag = (s+0.792)/(s+0.1);
C_LL = C*C_lag;

L_LL = C_LL*P;
T_LL = feedback(L_LL, 1);

% Bode plot
figure;
margin(L_LL);
grid on;

[Gm, Pm, Wcg, Wcp] = margin(L_LL);

fprintf('\n');
fprintf('Lead-Lag Compensated specs:\n');
fprintf('Gain crossover: %.4f rad/s\n', Wcp);
fprintf('Phase margin: %.2f degrees\n', Pm);

% Step response comparison
T_P = feedback(P, 1);

figure;
step(T_P, T_LL);
grid on;
legend('Uncompensated', 'Lead-Lag Compensated');
title('Closed-Loop Step Response Comparison');

% Step response specifications
stepinfo(T_LL)

% Steady-state error
ess = 1 - dcgain(T_LL);
fprintf('Steady-state error: %.4f\n', ess);
