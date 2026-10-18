
% Lab 3: Frequency Response Pre-lab
% DC Motor First-Order Model

K = 23.809;
tau = 0.0997;

sys = tf(K, [tau, 1]);

% Step Response
figure;
step(sys);
grid on;
title('DC Motor Step Response');

% Frequency Response
figure;
bode(sys);
grid on;
title('DC Motor Bode Plot - Zeshui Song');
