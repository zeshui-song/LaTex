s = tf('s');

K = 23.809;
tau = 0.0997;

kp = 0.08;
ki = 0.42;

P = K/(tau*s + 1);
C = kp + ki/s;

T = feedback(C*P,1);
info = stepinfo(T)