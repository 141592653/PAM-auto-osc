clear all;

nb_points = 300;
T = 1;
% f = 235.5*[1 3 5 7 9 11 13];
% A = 10*[1 0.75 0.5 0.14 0.15 .12 .17];
% Q = [10 15 20 25 30 40 50];
f = 300;
A = 30;
Q = 10;
Fs = 44100;
dt = 1/Fs;
N = T/dt;
eps = 0.1;

% create set of points
x = lhsdesign(nb_points,2);
% for each set of points, get pressure vector
% for i = 1:nb_points
%     pressure(i,:) = clarinet_modal(x(i,1), x(i,2), L, T, dt, Q1);
% %     pressure(i,:) = main2(x(i,1), x(i,2), L, F, Q, percent);
% end

f = @(x) (oscillation(real(sum(clarinet_modal2(x(1), x(2), T, dt, f, Q, A),1)),eps));

% y is the descriptor applied on each pressure vector
for i = 1:nb_points
   y(i) = f(x(i,:)); 
end

y = y';

plot(y);
SVM = CODES.fit.svm(x,y);
svm_col = CODES.sampling.edsd(f, SVM, [0 0], [1 1] , 'iter_max', 50, 'conv', false);
figure;
svm_col{end}.isoplot('legend', false, 'sv', false)
axis equal 
xlabel('zeta')
ylabel('gamma')
title('Descripteur : oscillation. A = 30, Q = 10')