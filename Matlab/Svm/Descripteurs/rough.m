function out = rough(p)
    out = 2*(mean(mirgetdata(mirroughness(miraudio(real(sum(p))')))) < 800)-1;
end
