clear; clc; close all;

% Fixed parameters (example values)
rho = 1.225;            % Air density (kg/m^3)
Q = 0.02;              % Volumetric flow rate (m^3/s), about an average hair dryer
p0 = 0.15*1000*9.81;    % Inlet gauge pressure (Pa), 15 cm H2O
Rin = 0.04;            % Hose inlet radius (m)

% Buckingham Pi groups
Pi2 = p0*Rin^4/(rho*Q^2);

Pi3 = linspace(0.125, 0.25, 80);   % R1/Rin
Pi4 = linspace(1.27, 2.2225, 80);   % Rout/Rin
Pi5 = linspace(0.025, 0.25, 40);   % h/Rin

% Generate all geometries
[A,B,C] = ndgrid(Pi3,Pi4,Pi5);

% Dimensionless lifting force (Pi1)
Pi1 = -pi*Pi2.*A.^2 ...
    - (A.^2 + 1./A.^2)/(2*pi) ...
    + 1./(4*pi*C.^2).* ...
    (log(B./A) - (B.^2-A.^2)./(2*B.^2));

% Exclude invalid geometries, Rout > R1 which is the same as Pi4 > Pi3
Pi1(B <= A) = -Inf;


% Find maximum dimensionless lifting force
[Pi1max,idx] = max(Pi1(:));

% Convert linear index to indices in the 3D grid
[i,j,k] = ind2sub(size(Pi1),idx);

% Recover dimensionless parameters at the maximum
Pi3_opt = Pi3(i);    % R1/Rin
Pi4_opt = Pi4(j);    % Rout/Rin
Pi5_opt = Pi5(k);    % h/Rin

% Convert back to physical dimensions (m)
R1_opt = Pi3_opt*Rin;
Rout_opt = Pi4_opt*Rin;
h_opt = Pi5_opt*Rin;

% Display optimal geometry and lifting force
fprintf('Optimal R1 = %.2f mm\n', R1_opt*1000);
fprintf('Optimal Rout = %.2f mm\n', Rout_opt*1000);
fprintf('Optimal h = %.2f mm\n', h_opt*1000);
fprintf('Maximum lift = %.5f N\n', ...
    Pi1max*rho*Q^2/Rin^2);

% Contour plot at optimal gap height
figure;
contourf(Pi3,Pi4,Pi1(:,:,k)',25);
colorbar;
hold on;
plot(Pi3(i),Pi4(j),'rp','MarkerSize',12,'MarkerFaceColor','r');
xlabel('\Pi_3 = R_1/R_{in}');
ylabel('\Pi_4 = R_{out}/R_{in}');
title('Dimensionless Lifting Force at Optimal Gap Height');
grid on;
