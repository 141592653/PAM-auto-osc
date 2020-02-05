function out = getpitch(x,y)
f = 300; 
Q = 10;
A = 30;
out = mirgetdata(mirpitch(miraudio(real(clarinet_modal2(x, y, 0.5, 1/44100,f , Q, A))', 44100), 'Mono'));
if isempty(out)
    out = 0;
end
end

