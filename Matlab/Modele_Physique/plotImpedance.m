clear variables;
close all;

T = 1;
Fs = 44100;

%Un mode
f = 300;
Q = 10;
A = 10;

%Clarinette

% f = 440*[1 3];
% A = 10*[1 0.75];
% Q = [10 15];

%Clarinette 2
% f = 235.5*[1 3 5 7 9 11 13];
% A = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
% Q = [10 15 20 25 30 40 50];

%Saxophone

% f = 440*[1 2];
% A = 10*[1 0.75];
% Q = [10 15];

%Saxophone 2

% f = 235.5*[1 2 4 6 8 10 12];
% A = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
% Q = [10 15 20 25 30 40 50];


%Trompette
f = [88.16, 237.16, 353.89, 473.8, 591.29, 706.7, 820.3, 932.05, 1054.77, 1173.35, 1284.21, 1397.63];
Q = [18.6, 29, 33.5, 35.7, 38, 38, 37.7, 36.9, 34.9, 31.1, 32.3, 1.1]*2;
A = [58.12, 38.2, 48.22, 59.72, 62.53, 61.88, 45.12, 27.8, 14.12, 6.54, 3.39, 1.46];


w = 2*pi*f;


%%

[p,u] = clarinet_modal2(0.3, 0.5, T, 1/Fs, f,Q,A, 0, 0, 0, 1);

p = 2*real(sum(p,1));

N23 = floor(length(p)*2/3);
p = p(N23:end);
u = u(N23:end);

figure;
plot(u)
%figure;
% plot(u)
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
title("Impédance (amplitude et phase) résonateur trompette, excitateur VDP, f0 88 hZ, zeta 03 gamma 0.5")
xlabel("f")
ylabel("|Z|")

Zphi = angle(P./U); 

subplot(2,1,2)
plot(fabs,Zphi);
xlim([0,2000]);
xlabel("f")
ylabel("arg(Z)")

%%
% N = 44100;
% 
% fabs = linspace(0,1,N)*Fs; 
% wabs = 2*pi*fabs;
% 
% Zth = zeros(1, N);
% for m = 1:length(f)
%     Zth = Zth + A(m)./(1+1i*Q(m)*(wabs/w(m) - w(m)./wabs));
% end
% 
% plot(fabs, Zth)



