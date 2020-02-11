function out = inharm(p)
    out = 2*(mirgetdata(mirinharmonicity(miraudio(real(sum(p))'))) < 0.1)-1;
end
