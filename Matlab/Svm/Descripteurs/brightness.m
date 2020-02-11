function y = brightness(signal)
seuil = [0.1 0.15 0.2 0.25 0.3 0.4 0.45 0.5 0.55];
results = [-7 -6 -5 -4 -3 -2 -1 0 1];

res = mirgetdata(mirbrightness(miraudio(signal(:,1))));

if(res < seuil(1))
    y = results(1);
    return;
end

for i=2:length(seuil)
   if(res >= seuil(i-1) && res < seuil(i)
      y = results(i);
      return;
   end
end


end