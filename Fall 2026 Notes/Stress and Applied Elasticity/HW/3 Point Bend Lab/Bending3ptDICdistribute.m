
% Plot strain fields and extract data from 3-point bending experiment
clear all; close all; clc

folder = 'C:\Users\zsong\Desktop\LaTex\Fall 2026 Notes\Applied Elasticity\HW\3 Point Bend Lab\Data';

% Measurement coordinates (mm)
XLP = 47.7753;
YLP = 11.2307;
XMP = 0.2753;
YMP = -0.1555;

% Applied loads (N)
loads = [0; 500; 1000; 1500; 2000; 2500; 3000; 0];

%% Extract measurements from all 8 files

results = zeros(8,4);

for k = 0:7
    load(fullfile(folder, sprintf('spk-%08d_0.mat',k)));

    % Bottom surface below load point
    valid = ~isnan(exx) & exx ~= 0 & abs(X-XLP) < 1;
    Ybottom = min(Y(valid));

    dist = (X-XLP).^2 + (Y-Ybottom).^2;
    dist(exx == 0 | isnan(exx)) = Inf;
    [~,idx] = min(dist(:));

    exx_value = exx(idx);
    V_value = V(idx);

    % Transverse strain at load point
    dist = (X-XLP).^2 + (Y-YLP).^2;
    dist(eyy == 0 | isnan(eyy)) = Inf;
    [~,idx] = min(dist(:));

    eyy_value = eyy(idx);

    % Shear strain at midpoint
    dist = (X-XMP).^2 + (Y-YMP).^2;
    dist(exy == 0 | isnan(exy)) = Inf;
    [~,idx] = min(dist(:));

    exy_value = exy(idx);

    results(k+1,:) = [exx_value, V_value, eyy_value, exy_value];
end

% Display and save data table
T = table(loads, results(:,1), results(:,2), ...
          results(:,3), results(:,4), ...
          'VariableNames', {'Load_N','exx','V_mm','eyy','exy'});

disp(T)
writetable(T,fullfile(folder,'DIC_Extracted_Data.csv'));

%% Plot strain fields for selected load

plotIndex = 7;  % 0 to 7 (4 = 2000 N)
load(fullfile(folder, sprintf('spk-%08d_0.mat',plotIndex)));

[jmax,imax] = size(X);

% Filter 0 values to null
for i = 1:imax
    for j = 1:jmax
        if exx(j,i)==0  exx(j,i) = NaN; end
        if eyy(j,i)==0  eyy(j,i) = NaN; end
        if exy(j,i)==0  exy(j,i) = NaN; end
        if gamma(j,i)==0  gamma(j,i) = NaN; end
        if e1(j,i)==0  e1(j,i) = NaN; end
        if e2(j,i)==0  e2(j,i) = NaN; end
%       if u(j,i)==0  u(j,i) = NaN; end
%       if v(j,i)==0  v(j,i) = NaN; end
        if U(j,i)==0  U(j,i) = NaN; end
        if V(j,i)==0  V(j,i) = NaN; end
    end
end

% Contour plots of strains
figure; surf(X,Y,exx*1e6); shading interp, axis equal tight, colorbar,
view(2), title('e_x_x (microstrains)')

figure; surf(X,Y,eyy*1e6); shading interp, axis equal tight, colorbar,
view(2), title('e_y_y (microstrains)')

figure; surf(X,Y,exy*1e6); shading interp, axis equal tight, colorbar,
view(2), title('e_x_y (microstrains)')

figure; surf(X,Y,e1*1e6); shading interp, axis equal tight, colorbar,
view(2), title('Max Principal Strain (microstrains)')

figure; surf(X,Y,e2*1e6); shading interp, axis equal tight, colorbar,
view(2), title('Min Principal Strain (microstrains)')

figure; surf(X,Y,gamma*180/pi); shading interp, axis equal tight, colorbar,
view(2), title('Max Principal Strain Orientation (degrees)')

figure; surf(X,Y,U); shading interp, axis equal tight, colorbar,
view(2), title('Axial Displacement (mm)')

figure; surf(X,Y,V); shading interp, axis equal tight, colorbar,
view(2), title('Transverse Displacement (mm)')


%% Compute stresses, using plane stress model
% Material properties: Aluminum 6061-T6
E = 70000;       % MPa
G = 26000;       % MPa
nu = E/(2*G)-1;  % Poisson's ratio

% Normal and shear stresses (MPa)
sxx = E/(1-nu^2) .* (exx + nu*eyy);
syy = E/(1-nu^2) .* (eyy + nu*exx);
txy = 2*G .* exy;

% Principal stresses (MPa)
savg = (sxx + syy)/2;
R = sqrt(((sxx-syy)/2).^2 + txy.^2);

s1 = savg + R;
s2 = savg - R;
s3 = zeros(size(s1));  % Plane stress

% Absolute maximum shear stress (MPa)
smax = max(max(s1,s2),s3);
smin = min(min(s1,s2),s3);
tmax = (smax-smin)/2;

% Remove invalid measurement locations
tmax(isnan(s1) | isnan(s2)) = NaN;

% Von Mises stress (MPa)
svm = sqrt(sxx.^2 - sxx.*syy + syy.^2 + 3*txy.^2);

%% Contour plots of stresses

figure; surf(X,Y,sxx); shading interp, axis equal tight, colorbar,
view(2), title('\sigma_{xx} (MPa)')

figure; surf(X,Y,syy); shading interp, axis equal tight, colorbar,
view(2), title('\sigma_{yy} (MPa)')

figure; surf(X,Y,txy); shading interp, axis equal tight, colorbar,
view(2), title('\tau_{xy} (MPa)')

figure; surf(X,Y,s1); shading interp, axis equal tight, colorbar,
view(2), title('Maximum In-Plane Principal Stress (MPa)')

figure; surf(X,Y,s2); shading interp, axis equal tight, colorbar,
view(2), title('Minimum In-Plane Principal Stress (MPa)')

figure; surf(X,Y,tmax); shading interp, axis equal tight, colorbar,
view(2), title('Absolute Maximum Shear Stress (MPa)')

figure; surf(X,Y,svm); shading interp, axis equal tight, colorbar,
view(2), title('Von Mises Stress (MPa)')

%% Check maximum Von Mises stress

yieldStrength = 35000 * 0.00689476;  % psi to MPa

fprintf('\nMaximum Von Mises stress: %.2f MPa\n', ...
    max(svm(:),[],'omitnan'));

fprintf('Yield strength: %.2f MPa\n',yieldStrength);
