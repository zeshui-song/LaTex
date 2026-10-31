
clear; clc; close all;

% Given
r1 = 500;     % mm
r2 = 200;     % mm
L  = 1000;    % mm

F   = 5000;   % N
E1  = 210e3;  % MPa
E2  = 210e3;  % MPa
nu1 = 0.25;
nu2 = 0.25;

% Find contact half-width
a = sqrt((4*F*r1*r2)/(pi*L*(r1+r2)) * ...
    ((1-nu1^2)/E1 + (1-nu2^2)/E2));

% Find contact area and maximum pressure
Ac = 2*a*L;
p0 = (2*F)/(pi*a*L);

fprintf('a = %.6f mm\n', a);
fprintf('Ac = %.6f mm^2\n', Ac);
fprintf('p0 = %.4f MPa\n', p0);
