% Stress tensor
stress_tensor = [100, 60, 0;
                  60, 20, 0;
                   0,  0, -30];

% Solve eigenvalue problem
[V, D] = eig(stress_tensor);

% Principal stresses and directions
principal_stresses = diag(D);

% Sort principal stresses from largest to smallest
[principal_stresses, order] = sort(principal_stresses, 'descend');
principal_directions = V(:, order);

% Individual principal stresses (after sorting, 1 is the largest, 3 is the smallest)
sigma1 = principal_stresses(1);
sigma2 = principal_stresses(2);
sigma3 = principal_stresses(3);

% Absolute maximum shear stress
tau_max = (sigma1 - sigma3) / 2;

% Von Mises (equivalent) stress
sigma_e = sqrt(0.5 * ((sigma1 - sigma2)^2 + ...
                       (sigma2 - sigma3)^2 + ...
                       (sigma3 - sigma1)^2));

% Display results
stress_tensor
principal_stresses
principal_directions
tau_max
sigma_e