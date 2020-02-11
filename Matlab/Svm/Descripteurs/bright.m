function out = bright(p) 
    out = 2*(mirgetdata(mirbrightness(miraudio(real(sum(p))'), 'cutoff', 1500)) < 0.1)-1;
end

