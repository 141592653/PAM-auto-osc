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

%Clarinette 2 modes

% f = 200*[1 3];
% A = 10*[1 0.75];
% Q = [10 15];

%Clarinette 7 modes 
% f = 235.5*[1 3 5 7 9 11 13];
% A = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
% Q = [10 15 20 25 30 40 50];

%Saxophone 2 modes

% f = 500*[1 2];
% A = 10*[1 0.75];
% Q = [10 15];

%Saxophone 2

% f = 235.5*[1 2 4 6 8 10 12];
% A = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
% Q = [10 15 20 25 30 40 50];


%Trompette

% f = [88.16, 237.16, 353.89, 473.8, 591.29, 706.7, 820.3, 932.05, 1054.77, 1173.35, 1284.21, 1397.63];
% Q = [18.6, 29, 33.5, 35.7, 38, 38, 37.7, 36.9, 34.9, 31.1, 32.3, 1.1]*2;
% A = [58.12, 38.2, 48.22, 59.72, 62.53, 61.88, 45.12, 27.8, 14.12, 6.54, 3.39, 1.46];



% create set of points
x = lhsdesign(nb_points,3);
x(:,3) = 1000*x(:,3);

g = @(x) (oscillation(real(sum(clarinet_modal2(x(1), x(2), T, dt, x(3), Q, A),1)),eps));

y = zeros(1, length(x));

% y is the descriptor applied on each pressure vector
for i = 1:nb_points
   y(i) = g(x(i,:)); 
end

y = y';

SVM = CODES.fit.svm(x,y);
svm_col = CODES.sampling.edsd(g, SVM, [0 0 0], [1 1 1000] , 'iter_max', 50, 'conv', false);
figure;
svm_col{end}.isoplot('legend', false, 'sv', false)
%axis equal 
xlabel('zeta')
ylabel('gamma')
title('Descripteur : oscillation. A = 30, Q = 10')