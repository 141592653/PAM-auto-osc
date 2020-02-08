function out = freq(p)
    %two octaves 
    freqs = [130.81, 138.59, 146.83, 155.56, 164.81, 174.61,...
        185.00, 196.00, 207.65, 220.00, 233.08,  246.94, 261.63,...
        277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30,...
        440.00, 466.16, 493.88, 523.25];


%freqs = [130.81, 207.65, 311.13, 415.30, 523.25];

    %comment les faire passer en paramètres
    %f = c/2/y; 
    %zeta = 0.8;
    %Q = 10;
    %A = 30;

    freq = mirgetdata(mirpitch(miraudio(p', 44100), 'Mono'));

    if isempty(freq)
        out = 1;
    else
        i=1;
        out = 1;
        while(i<= length(freqs) & freq>freqs(i))
            out = 1-i;
            i = i+1;
        end
    end

end