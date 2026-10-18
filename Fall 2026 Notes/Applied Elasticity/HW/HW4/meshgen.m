% Mesh for a square plate with a central circular hole (TFI)
% Based on MeshSquarePlateWithHole2023 by Siva Srinivas Kolukula

L = 1;                  % Plate half-width
a = L/5;              % Hole radius
m = 21;                 % Angular subdivisions (0 to pi/4)
n = 41;                 % Radial subdivisions

xi = linspace(0,1,m);
eta = linspace(0,1,n);
X1 = zeros(m,n);
Y1 = zeros(m,n);

% Boundary curves for transfinite interpolation
P1 = [a;0];
P2 = [L;0];
P3 = [L;L];
C  = [a*cos(pi/4);a*sin(pi/4)];

Xb = @(s) [a*cos(pi*s/4); a*sin(pi*s/4)];
Xt = @(s) P2 + s*(P3-P2);
Xl = @(s) P1 + s*(P2-P1);
Xr = @(s) C  + s*(P3-C);

for i = 1:m
    for j = 1:n
        s = xi(i);
        t = eta(j);
        % Transfinite interpolation: (x_ij, y_ij)
        xy = (1-t)*Xb(s) + t*Xt(s) + (1-s)*Xl(t) + s*Xr(t) ...
           - ((1-s)*(1-t)*Xb(0) + s*(1-t)*Xb(1) ...
           + (1-s)*t*Xt(0) + s*t*Xt(1));
        X1(i,j) = xy(1);
        Y1(i,j) = xy(2);
    end
end

% Reflect across x = y to form the first quadrant
X = [X1; Y1(end-1:-1:1,:)];
Y = [Y1; X1(end-1:-1:1,:)];