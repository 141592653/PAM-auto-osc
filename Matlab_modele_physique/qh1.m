function out = qh1(t, q, f, Zc, T, b, a, deltaT)
% calcul of qh depending on former q(t), f(t)
    N = length(q);
    Y = zeros(N,1);
    for k=1:length(q)
       x=(k-1)*deltaT;
       if(t>=x)
           Y(k) = a*exp(-b*(t-x-T)^2)*(q(k)+Zc*f(k));
       end
    end
    X = linspace(0, (N-1)*deltaT, N);
    out = trapz(X,Y);    
end


function out = r(t, T, b, a)
    if(t<0) 
        out = 0;
    else
        out = a*exp(-b*(t-T).^2);
    end

end