% Stress tensor [MPa]
stress_tensor = [40, 40, 30;
       40, 20,  0;
       30,  0, 20];

% Direction cosines (unit normal vector)
n = [cosd(40); 
     cosd(75); 
     cosd(54)];

% Traction vector
p = stress_tensor * n;

% Normal stress magnitude [MPa]
sigma_mag = abs(dot(p, n));

% Shear stress magnitude [MPa]
tau_mag = sqrt(norm(p)^2 - sigma_mag^2);

% Display results
fprintf('Normal stress magnitude: %.2f MPa\n', sigma_mag);
fprintf('Shear stress magnitude:  %.2f MPa\n', tau_mag);

