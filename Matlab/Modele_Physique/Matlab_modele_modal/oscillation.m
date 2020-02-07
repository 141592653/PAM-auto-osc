function b = oscillation(p, eps)
% return true if it produces sound

N = ceil(length(p) * 2/3);

env = abs(hilbert(p(N:end)));
b = 1/length(env) * sum(env);

if b > eps
    b = 1;
else 
    b = -1;
end
end