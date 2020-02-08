clear all;

nb_points = 300;
T = 1;
Fs = 44100;
dt = 1/Fs;
N = T/dt;
eps = 0.1;

%Un mode 
f = 500;
A = 30;
Q = 10;

qr = 1;
reedModel = 1;

args = [T dt f Q A qr 1 1 reedModel];

svm('clarinet_modal2', args, 'oscillation', 30, 10, 'clarin', '../../Cartographies/', 'png');
