clear all;

nb_points = 300;
T = 1;
Fs = 44100;
dt = 1/Fs;
eps = 0.1;

%Un mode 
% f = 500;
% A = 30;
% Q = 10;

%Clarinette 2 modes
% 
% f = 220*[1 3];
% A = 10*[1 0.75];
% Q = [10 15];

%Clarinette 7 modes 
% f = 235.5*[1 3 5 7 9 11 13];
% A = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
% Q = [10 15 20 25 30 40 50];

%Saxophone 2 modes

f = 220*[1 2];
A = 10*[1 0.75];
Q = [10 15];

%Saxophone 2

% f = 235.5*[1 2 4 6 8 10 12];
% A = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
% Q = [10 15 20 25 30 40 50];


%Trompette

% f = 220*[88.16, 237.16, 353.89, 473.8, 591.29, 706.7, 820.3, 932.05, 1054.77, 1173.35, 1284.21, 1397.63]/88.16;
% Q = [18.6, 29, 33.5, 35.7, 38, 38, 37.7, 36.9, 34.9, 31.1, 32.3, 1.1]*2;
% A = [58.12, 38.2, 48.22, 59.72, 62.53, 61.88, 45.12, 27.8, 14.12, 6.54, 3.39, 1.46];



% create set of points
x = lhsdesign(nb_points,2);

gOsc = @(x) (oscillation(real(sum(clarinet_modal2(x(1), x(2), T, dt, f, Q, A),1)),eps));
gBright = @(x) 2*(mirgetdata(mirbrightness(miraudio(real(sum(clarinet_modal2(x(1), x(2), T, dt, f, Q, A),1))'), 'cutoff', 1500)) < 0.1)-1;
gInhar = @(x) 2*(mirgetdata(mirinharmonicity(miraudio(real(sum(clarinet_modal2(x(1), x(2), T, dt, f, Q, A),1))'))) < 0.1)-1;
gRough = @(x) 2*(mean(mirgetdata(mirroughness(miraudio(real(sum(clarinet_modal2(x(1), x(2), T, dt, f, Q, A),1))')))) < 800)-1;



yOsc = zeros(1, length(x));
yBright = zeros(1, length(x));
yInhar = zeros(1, length(x));
yRough = zeros(1, length(x));


% y is the descriptor applied on each pressure vector
for i = 1:nb_points
   yOsc(i) = gOsc(x(i,:)); 
   yBright(i) = gBright(x(i,:)); 
   yInhar(i) = gInhar(x(i,:)); 
   yRough(i) = gRough(x(i,:)); 
end

yOsc = yOsc';
yBright = yBright';
yInhar = yInhar';
yRough = yRough';

SVMOsc = CODES.fit.svm(x,yOsc);
SVMBright = CODES.fit.svm(x,yBright);
SVMInhar = CODES.fit.svm(x,yInhar);
SVMRough = CODES.fit.svm(x,yRough);

svm_colOsc = CODES.sampling.edsd(gOsc, SVMOsc, [0 0], [1 1] , 'iter_max', 50, 'conv', false);
svm_colBright = CODES.sampling.edsd(gBright, SVMBright, [0 0], [1 1] , 'iter_max', 50, 'conv', false);
svm_colInhar = CODES.sampling.edsd(gInhar, SVMInhar, [0 0], [1 1] , 'iter_max', 50, 'conv', false);
svm_colRough = CODES.sampling.edsd(gRough, SVMRough, [0 0], [1 1] , 'iter_max', 50, 'conv', false);
figure;
svm_colOsc{end}.isoplot('legend', false, 'sv', false)
hold on;
svm_colBright{end}.isoplot('legend', false, 'sv', false, 'bcol', 'r')
svm_colInhar{end}.isoplot('legend', false, 'sv', false, 'bcol', 'b')
svm_colRough{end}.isoplot('legend', false, 'sv', false, 'bcol', [0 0.5 0])
legend('Oscillation', 'Brightness>0.1', 'Inharmonicity > 0.08', 'Roughness > 1000', 'Location', 'southoutside') 
%axis equal 
xlabel('zeta')
ylabel('gamma')
title({'Instrument : Clarinette 2 modes.', 'f0 = 220Hz'})