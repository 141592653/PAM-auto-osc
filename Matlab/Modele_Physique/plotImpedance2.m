clear all;
close all;

T = 1;
Fs = 44100;
f = 440;
c = 340;
L = c/2/f;

[p,u] = main2(0.9, 0.9, L, [1, 1], [0.1,0.11], 0.2);

N23 = floor(length(p)*2/3);
p = p(N23:end);
u = u(N23:end);

figure;
plot(p)
%figure;
plot(u)
%soundsc(real(p), Fs)


P = fft(p);
U = fft(u);

N = length(P);

Z = abs(P./U);

fabs = linspace(0,1,N)*Fs; 
figure;
subplot(2,1,1)
plot(fabs,Z);
xlim([0,2000]);
title("Impédance (amplitude et phase) guide d'onde, excitateur Anche, f0 440 hZ, zeta=gamma=0.9")
xlabel("f")
ylabel("|Z|")

Zphi = angle(P./U); 

subplot(2,1,2)
plot(fabs,Zphi);
xlim([0,2000]);
xlabel("f")
ylabel("arg(Z)")


