function out = freq(p)
    %two octaves 
    freqs = [65.41, 69.30, 73.42, 77.78, 82.41, 87.31,...
        92.50, 98.00, 103.83, 110.00, 116.54, 123.47,...
        130.81, 138.59, 146.83, 155.56, 164.81, 174.61,...
        185.00, 196.00, 207.65, 220.00, 233.08,  246.94, 261.63];
        %261.63, 277.18, 293.66, 311.13, 329.63, 349.23,...
        %369.99, 392.00, 415.30, 440.00, 466.16, 493.88, 523.25];

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