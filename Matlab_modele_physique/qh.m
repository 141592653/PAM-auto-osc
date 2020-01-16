function out = qh(t, q, f, Zc, T, b, a, deltaT)
% calcul of qh depending on former q(t), f(t)
    N = length(q);
    X = linspace(0, (N-1)*deltaT, N);
    Y = r(t-X, T, b, a).*(q + Zc*f);
    out = trapz(X,Y);    
end


function out = r(t, T, b, a)
    if(t<0) 
        out = 0;
    else
        out = a*exp(-b*(t-T).^2);
    end

end