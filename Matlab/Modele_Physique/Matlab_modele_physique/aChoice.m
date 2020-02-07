function a = aChoice(T, b, N)
    %pour qu il y ait 95 % de la gaussienne (mu-2*sigma, mu+2*sigma)
    X = linspace(max(0,T-2*sqrt(1/(2*b))), T+2*sqrt(1/(2*b)), N);
    Y = r(X, T, b);
    int = trapz(X,Y);
    a = -1/int;
end


function out = r(t, T, b)
    if(t<0)
        out = 0;
    else
        out = exp(-b*(t-T).^2);
    end
end
