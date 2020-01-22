function a = aChoice(T, b, N,r)
    %pour qu il y ait 95 % de la gaussienne (mu-2*sigma, mu+2*sigma)
    X = linspace(max(0,T-2*sqrt(1/(2*b))), T+2*sqrt(1/(2*b)), N);
    Y = r1(X, T, b);
    int = trapz(X,Y);
    a = -r/int;
end


function out = r1(t, T, b)
    if(t<0)
        out = 0;
    else
        out = exp(-b*(t-T).^2);
    end
end
