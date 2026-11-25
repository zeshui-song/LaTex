
clear; clc; close all;

% Given
r1       = 500;     % mm
r1_prime = Inf;     % mm
r2       = 200;     % mm
r2_prime = Inf;     % mm

F        = 5000;    % N
E        = 210e3;   % MPa
nu       = 0.25;
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
ca = 1.486;
cb = 0.717;

% Find maximum pressure
a = ca * ((F*m)/n)^(1/3);
b = cb * ((F*m)/n)^(1/3);
p0 = (1.5*F)/(pi*a*b);

% Contact area
Ac = pi*a*b;

fprintf('a = %.6f mm\n', a);
fprintf('b = %.6f mm\n', b);
fprintf('p0 = %.4f MPa\n', p0);
fprintf('Ac = %.4f mm^2\n', Ac);
