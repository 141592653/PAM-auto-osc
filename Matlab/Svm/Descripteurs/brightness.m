function y = brightness(signal)
seuil = [0 0.02 0.05 0.15 0.175 1];
results = [-3 -2 -1 0 1];

persistent list;
if(isempty(list))
   list = []; 
end

if(length(list) == 200)
  plot(list);  
end

res = mirgetdata(mirbrightness(miraudio(signal(:,1))));
list = [list res];
fprintf("result ==== %d \n", res);


for i=1:length(seuil)-1
    %fprintf("res >= %d && res < %d\n", seuil(i),seuil(i+1));
   if (res >= seuil(i) && res < seuil(i+1))
      %fprintf("entered the other if\n");
      y = results(i);
      break;
   end
end


if(isnan(res))
   y = -3;
end

end