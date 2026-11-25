% Stress tensor in baseline coordinates (x, y, z) [MPa]
sigma_xyz = [ 3.5,  1.0,  1.2;
              1.0, -1.5,  0.0;
              1.2,  0.0, -1.0];

% Given direction cosine matrix [A]
A = [ 0.8529,  0.4924, -0.1736;
     -0.4742,  0.8697,  0.1371;
      0.2185, -0.0345,  0.9752];

% Textbook direction cosine matrix [L] = [A]'
L = A';

% Transformed stress tensor in local coordinates (f, n, t)
sigma_fnt = L * sigma_xyz * L';

sigma_f  = sigma_fnt(1, 1); % Wood fiber direction
sigma_n  = sigma_fnt(2, 2); % Normal to wood grain
tau_nf   = sigma_fnt(2, 1); % Parallel to fibers on grain plane
tau_nt   = sigma_fnt(2, 3); % Transverse to fibers on grain plane
tau_tf   = sigma_fnt(3, 1); % Normal to fiber direction

% Display results
fprintf('Normal stress in fiber direction (sigma_f):     %7.3f MPa\n', sigma_f);
fprintf('Normal stress normal to grain (sigma_n):        %7.3f MPa\n', sigma_n);
fprintf('Shear stress parallel to fibers (tau_nf):       %7.3f MPa\n', tau_nf);
fprintf('Shear stress transverse to fibers (tau_nt):     %7.3f MPa\n', tau_nt);
fprintf('Shear stress normal to fiber direction (tau_tf): %7.3f MPa\n', tau_tf);
