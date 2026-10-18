% Zeshui Song
% updated values from experimental results:
K = 26.77;
tau = 0.11;
sys = tf(K, [tau 1]);
[sysmag, sysphase, w] = bode(sys);

sysmag = mag2db(squeeze(sysmag));
sysphase = squeeze(sysphase);

figure;
bode(sys);
grid on;

% Experimental Data
input_freqs = [0.5 1 2 5 10 20 50 100];

magpoints = [28.591 28.556 28.261 26.795 ...
             24.004 19.350 11.250 3.014];

phasepoints = -[4.757 8.978 16.909 37.572 ...
                59.095 82.158 113.918 141.962];
%Note: Matlab bode function reports phase lag as negative

% Question 6: Experimental vs Theoretical Bode Plot

subplot(2,1,1)
semilogx(w,sysmag,'k',input_freqs,magpoints,'bs','linewidth',2);
xlabel('Frequency (rad/s)'); ylabel('Magnitude (dB)')
ylim([-20,40]);
yticks(-20:20:40);
grid on;
title('Experimental vs Theoretical Bode Plot - Zeshui Song');

subplot(2,1,2)
semilogx(w,sysphase,'k-',input_freqs,phasepoints,'bs','linewidth',2);
xlabel('Frequency (rad/s)'); ylabel('Phase (deg)')
ylim([-180,0]);
yticks(-180:45:45);
grid on;
