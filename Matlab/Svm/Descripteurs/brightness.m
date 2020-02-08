function y = brightness(signal)

seuil1 = .1;
seuil2 = .2;
seuil3 = .3;
seuil4 = .4;
seuil5 = .5;
seuil6 = .6;
seuil7 = .7;
seuil8 = .8;
seuil9 = .9;


res = mirbrightness(signal);

if res < seuil1
    y = -6;
elseif res < seuil2
    y = -5;
elseif res < seuil3
    y = -4;
elseif res < seuil4 
    y = -3;
elseif res < seuil5
    y = -2;
elseif res < seuil6
    y = -1;
elseif res < seuil7
    y = 0;
elseif res < seuil8
    y = 0;
elseif res < seuil9
    y = 0;
else
    y = 1;
    


end