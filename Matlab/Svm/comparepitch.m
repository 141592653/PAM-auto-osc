function out = comparepitch(x)
    x
    c = 340;
    L = 0.3;
    freq = 300;
    seuil = 20;
    f = c/2/L; 
    Q = 10;
    A = 30;
    f = mirgetdata(mirpitch(miraudio(real(clarinet_modal2(x(1), x(2), 0.5, 1/44100,f , Q, A))', 44100), 'Mono'));
    if(abs(freq-f)<seuil)
        out = 1;
    else
        out = -1;
    end
end