x = linspace(0,1,50);
y = linspace(0,1,50);

[X,Y] = meshgrid(x,y);

f = 300;
A = 30;
Q = 10;

T = 0.5;
Fs = 44100;

f = @(x,y) getpitch(x,y);
freq = arrayfun(f, X,Y, 'UniformOutput', true);
plot3(X,Y,freq)

