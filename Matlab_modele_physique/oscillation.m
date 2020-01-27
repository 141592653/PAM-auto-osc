function b = oscillation(p, eps)
% return true if it produces sound

N = ceil(length(p) * 2/3);

b = 1/N * sum(p(1:N));

if b > eps
    b = -1;
else 
    b = 1;
end
end