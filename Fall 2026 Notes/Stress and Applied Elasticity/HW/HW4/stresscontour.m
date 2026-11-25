% ME 300 HW4, Problem 3: Stress contours for a plate with a hole
meshgen;

sigma0 = 100;                        % Applied stress, MPa

% Plot all four quadrants of the plate
Kt = 0;
for k = 1:10
    figure;
    hold on;
    for q = 1:4
        % Coordinates (x_ij, y_ij) in each quadrant
        if q == 1
            x = X;  y = Y;
        elseif q == 2
            x = -X; y = Y;
        elseif q == 3
            x = -X; y = -Y;
        else
            x = X;  y = -Y;
        end

        % Parts (a) and (b): Polar and Cartesian stress components
        % Polar coordinates (r, theta)
        r = sqrt(x.^2 + y.^2);
        theta = atan2(y,x);

        % Polar normal stress: sigma_rr
        sigma_rr = sigma0/2*((1 - a^2./r.^2) ...
                 + (1 - 4*a^2./r.^2 + 3*a^4./r.^4).*cos(2*theta));

        % Polar normal stress: sigma_theta_theta
        sigma_theta = sigma0/2*((1 + a^2./r.^2) ...
                    - (1 + 3*a^4./r.^4).*cos(2*theta));

        % Polar shear stress: tau_r_theta
        tau_rtheta = sigma0/2*(-1 - 2*a^2./r.^2 ...
                   + 3*a^4./r.^4).*sin(2*theta);

        % Stress transformation from (r, theta) to (x, y), angle = -theta
        sigma_ave = (sigma_rr + sigma_theta)/2;
        delta_sigma = sigma_rr - sigma_theta;

        % Cartesian normal stress: sigma_x
        sigma_x = sigma_ave + delta_sigma/2.*cos(2*theta) ...
                - tau_rtheta.*sin(2*theta);

        % Cartesian normal stress: sigma_y
        sigma_y = sigma_ave - delta_sigma/2.*cos(2*theta) ...
                + tau_rtheta.*sin(2*theta);

        % Cartesian shear stress: tau_xy
        tau_xy = delta_sigma/2.*sin(2*theta) ...
               + tau_rtheta.*cos(2*theta);

        % Stress concentration factor: Kt = max(sigma_x)/sigma0
        Kt = max(Kt,max(sigma_x(:))/sigma0);

        % Part (c): In-plane principal stresses
        % Mohr's circle: sigma_ave and R
        sigma_ave = (sigma_x + sigma_y)/2;
        R = sqrt(((sigma_x - sigma_y)/2).^2 + tau_xy.^2);

        % In-plane principal stresses: sigma_1 and sigma_2
        sigma1 = sigma_ave + R;
        sigma2 = sigma_ave - R;

        % Part (d): Maximum shear stress and Von Mises stress
        % Out-of-plane principal stress: sigma_3 = 0 (plane stress)
        sigma3 = zeros(size(sigma1));

        % Maximum shear stress over all orientations: tau_max
        tau_max = (max(max(sigma1,sigma2),sigma3) ...
                 - min(min(sigma1,sigma2),sigma3))/2;

        % Von Mises stress: sigma_VM
        sigma_VM = sqrt(sigma_x.^2 + sigma_y.^2 ...
                   - sigma_x.*sigma_y + 3*tau_xy.^2);

        % Select the stress for contour plot k
        stresses = {sigma_x, sigma_y, sigma_rr, sigma_theta, ...
                    tau_xy, tau_rtheta, sigma1, sigma2, tau_max, sigma_VM};
        contourf(x,y,stresses{k},20,'LineColor','none');
    end
    titles = {'sigma_x','sigma_y','sigma_{rr}','sigma_{theta theta}', ...
              'tau_{xy}','tau_{r theta}','sigma_1','sigma_2', ...
              'tau_{max}','sigma_{VM}'};
    title(titles{k});
    xlabel('x (m)');
    ylabel('y (m)');
    axis equal tight;
    colorbar;
    ylabel(colorbar,'Stress (MPa)');
end

% Stress concentration factor: Kt = max(sigma_x) / sigma0
fprintf('Stress concentration factor: %.2f\n',Kt);
