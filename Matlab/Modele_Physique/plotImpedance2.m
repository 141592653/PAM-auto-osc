clear all;
close all;

T = 1;
Fs = 44100;
f = 500;
Q = 10;
A = 10;

% f = [88.16, 237.16, 353.89, 473.8, 591.29, 706.7, 820.3, 932.05, 1054.77, 1173.35, 1284.21, 1397.63];
% Q = [18.6, 29, 33.5, 35.7, 38, 38, 37.7, 36.9, 34.9, 31.1, 32.3, 1.1]*2;
% Z = [58.12, 38.2, 48.22, 59.72, 62.53, 61.88, 45.12, 27.8, 14.12, 6.54, 3.39, 1.46];

[p,u] = main2(0.8, 0.8, 0.3, [1, 1], [0.1,0.11], 0.2);

N23 = floor(length(p)*1/2);
p = p(N23:end);
u = u(N23:end);

figure;
plot(p)
figure;
plot(u)
soundsc(real(p), Fs)


P = fft(p);
U = fft(u);

N = length(P);

Z = abs(P./U);

fabs = linspace(0,1,N)*Fs; 
figure;
plot(fabs,Z);
xlim([0,Fs/2]);

Zphi = angle(P./U); 

figure;
plot(fabs,Zphi);
xlim([0,Fs/2]);


