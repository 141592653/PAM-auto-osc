clear all;

nb_points = 300;
T = 1;
L = 1;
Fs = 50002;
dt = 1/Fs;
Q1 = 10;
N = T/dt;
eps = 0.1;

% variables spécifiques au modèle "physique"
F=[1.8,2.6]; %??,
Q=[2.5,3.5]; %??
percent = 0.2;

% create set of points
x = lhsdesign(nb_points,2);

pressure = zeros(nb_points,N);

% for each set of points, get pressure vector
% for i = 1:nb_points
%     tic
% %     pressure(i,:) = clarinet_modal(x(i,1), x(i,2), L, T, dt, Q1);
%     pressure(i,:) = main2(x(i,1), x(i,2), L, F, Q, percent);
%     toc
% end

%f = @(x) (oscillation(main2(x(1), x(2), L, F, Q, percent), eps));
f = @(x) (oscillation(main2(x(1), x(2), L, F, Q, percent), eps));
% y is the descriptor applied on each pressure vector
for i = 1:nb_points
   y(i,:) = f(x(i,:)); 
end

plot(y);
SVM = CODES.fit.svm(x,y);
svm_col = CODES.sampling.edsd(f, SVM, [0 0], [0.99 0.99] , 'iter_max', 50, 'conv', false);
figure;
svm_col{end}.isoplot
axis equal 