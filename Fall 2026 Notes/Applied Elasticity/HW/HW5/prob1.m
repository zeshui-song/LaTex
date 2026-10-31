
clear; clc; close all;

% Given
r1       = 18;      % in
r1_prime = Inf;     % in
r2       = 9;       % in
r2_prime = Inf;     % in

F        = 1100;    % lbf
E        = 19000e3; % psi
nu       = 0.3;
theta    = pi/2;    % rad

% Find alpha
m = 4 / (1/r1 + 1/r1_prime + 1/r2 + 1/r2_prime);
n = (4 * E) / (3 * (1 - nu^2));

A = 2 / m;
B = 0.5 * sqrt( ...
    (1/r1 - 1/r1_prime)^2 + ...
    (1/r2 - 1/r2_prime)^2 + ...
    2*(1/r1 - 1/r1_prime)*(1/r2 - 1/r2_prime)*cos(2*theta));

alpha = acos(B/A);
fprintf('alpha = %.4f deg\n', rad2deg(alpha));

% Enter coefficients from Table 3.3
 ca = 1.284;
 cb = 0.802;

% Find maximum pressure
 a = ca * ((F*m)/n)^(1/3);
 b = cb * ((F*m)/n)^(1/3);
 p0 = (1.5*F)/(pi*a*b);

 fprintf('a = %.6f in\n', a);
 fprintf('b = %.6f in\n', b);
 fprintf('p0 = %.4f ksi\n', p0/1000);
