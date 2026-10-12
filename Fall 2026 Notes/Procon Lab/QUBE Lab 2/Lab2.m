K = 23.809;
tau = 0.0997;
s = tf('s');
sys = K/(s*(tau*s + 1));
controlSystemDesigner(sys)