f = [88.16, 237.16, 353.89, 473.8, 591.29, 706.7, 820.3, 932.05, 1054.77, 1173.35, 1284.21, 1397.63]*2;
H = f/f(1);
Q = [18.6, 29, 33.5, 35.7, 38, 38, 37.7, 36.9, 34.9, 31.1, 32.3, 1.1]*2;
Z = [58.12, 38.2, 48.22, 59.72, 62.53, 61.88, 45.12, 27.8, 14.12, 6.54, 3.39, 1.46];
qr = 0.1;%beetween 0.2 and 1

% f = 440;
% Q = 40;
% Z = 50;

T = 1;
Fs = 44100;
N = T*Fs;
pr = zeros(1,N);
p = clarinet_modal2(0.3, 0.2, T, 1/Fs, f,Q,Z);
for i = 1:N
    pr(i) = sum(real(p(:,i)));
end

plot(pr)
%figure
%spectrogram(pr, 'yaxis')
%soundsc(pr, Fs)
%audiowrite('testnew.wav',pr/10, Fs)