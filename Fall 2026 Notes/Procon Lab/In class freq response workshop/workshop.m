
clc; clear; close all;

s = tf('s');
P = 1/(s*(s+1));

%% 1. Uncompensated Bode plot
figure;
margin(P);
grid on;

% Calculate margins and crossover frequencies
[Gm, Pm, Wcg, Wcp] = margin(P);

fprintf('Problem 1: Uncompensated System\n');
fprintf('Gain crossover frequency: %.4f rad/s\n', Wcp);
fprintf('Phase margin: %.2f degrees\n', Pm);


%% Problem 3: Lead Compensator
C = (s+2)/(s+10);

% Find Kc such that PM = 50 degrees
f = @(Kc) phaseMargin(Kc*C*P) - 50;
Kc = fzero(f, [60, 80]);

L = Kc*C*P;

figure;
margin(L);
grid on;

[Gm, Pm, Wcg, Wcp] = margin(L);

fprintf('\nProblem 3: Lead Compensator\n');
fprintf('Kc = %.4f\n', Kc);
fprintf('Phase margin = %.2f degrees\n', Pm);
fprintf('Gain crossover = %.4f rad/s\n', Wcp);

function PM = phaseMargin(L)
    [~, PM, ~, ~] = margin(L);
end


%% Problem 6: Step Response Comparison
% Plant and proportional controller
P = 1/(s*(s+1));
C_P = 1;

% Lead-lag controller
C_lead = 68*(s+2)/(s+10);
ratio = 8; %ratio = z/p
z = 0.1;
p = z/ratio;
C_lag = (s+z)/(s+p);
C_LL = C_lead*C_lag;

% Closed-loop transfer functions
T_P = feedback(C_P*P, 1);
T_LL = feedback(C_LL*P, 1);

% Step responses
figure;
step(T_P, T_LL);
grid on;
legend('P Control', 'Lead-Lag Control');
title('Closed-Loop Step Response Comparison');



