clear all;

% parameters of the resonator 
resonator = 'clarinet';%['clarinet', 'saxophone', 'trompet'];['lippal', 'reed'];
% parameters of the exciter 
exciter = 'reed';%['lippal', 'reed'];
fixe = 'L'; % "gamma", "zeta"
qr = 0.1; % beetween 0.2 and 1 %parameter of the reed
zeta = 0.8;
gamma = 0.8;
L = 0.5;

% parmeters of the sound
T = 1;
Fs = 44100;
dt = 1/Fs;
N = T*Fs;
pr = zeros(1,N);
u0 = 0; u1 = 0;
p0 = 0; p1 = 0;

%plot(real(sum(clarinet_modal(0.8, 0.8, {1, 1/44100, [440 880], [10 15], [10 5], 0, 0, 0, 1}), 1)))

%[F,Q,Z] = paraResonator(resonator);


args = {fixe, resonator, T, dt, qr, u0, u1, p0, p1};

%{fixe reedmodel F Q Z T dt qr u0 u1 p0 p1}
p = clarinet_modal2(0.6, 0.5, {'L', 'reed', 'clarinet', 1, 1/44100, 0.1, 0, 0, 0, 0});%clarinet_modal2(zeta, gamma, args);

plot(real(sum(p)))

%figure
%spectrogram(pr, 'yaxis')
%soundsc(pr, Fs)
%audiowrite('testnew.wav',pr/10, Fs)