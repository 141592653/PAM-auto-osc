clear all;

% parameters of the resonator 
resonator = 'clarinet';%['clarinet', 'saxophone', 'trompet'];['lippal', 'reed'];
% parameters of the exciter 
exciter = 'lippal';%['lippal', 'reed'];
qr = 0.1;%beetween 0.2 and 1 %parameter of the anche
zeta = 0.8;
gamma = 0.8;
reedmodel = 1;

% parmeters of the sound
T = 1;
Fs = 44100;
dt = 1/Fs;
N = T*Fs;
pr = zeros(1,N);
u0 = 0; u1 = 0;
p0 = 0; p1 = 0;

if(strcmpi(resonator, 'clarinet'))
    % 2 modes
    % f = 200*[1 3];
    % Z = 10*[1 0.75];
    % Q = [10 15];

    %7 modes
    f = 235.5*[1 3 5 7 9 11 13];
    Z = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
    Q = [10 15 20 25 30 40 50];
elseif(strcmpi(resonator, 'saxophone'))
    % 2 modes
    % f = 500*[1 2];
    % A = 10*[1 0.75];
    % Q = [10 15];

    % 7 modes
    f = 235.5*[1 2 4 6 8 10 12];
    Z = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
    Q = [10 15 20 25 30 40 50];
elseif(strcmpi(resonator, 'trompet'))
    f = [88.16, 237.16, 353.89, 473.8, 591.29, 706.7, 820.3, 932.05, 1054.77, 1173.35, 1284.21, 1397.63]*2;
    H = f/f(1);
    Q = [18.6, 29, 33.5, 35.7, 38, 38, 37.7, 36.9, 34.9, 31.1, 32.3, 1.1]*2;
    Z = [58.12, 38.2, 48.22, 59.72, 62.53, 61.88, 45.12, 27.8, 14.12, 6.54, 3.39, 1.46];
end


args = [T dt reedmodel qr u0 u1 p0 p1];

p = clarinet_modal2(zeta, gamma, args, f, Q, Z);

for i = 1:N
    pr(i) = sum(real(p(:,i)));
end

plot(pr)

%figure
%spectrogram(pr, 'yaxis')
%soundsc(pr, Fs)
%audiowrite('testnew.wav',pr/10, Fs)