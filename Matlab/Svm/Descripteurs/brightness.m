function y = brightness(signal)

seuil_1 = .1;
seuil_2 = .2;
seuil_3 = .3;
seuil_4 = .4;
seuil_5 = .5;
seuil_6 = .6;
seuil_7 = .7;
seuil_8 = .8;
seuil_9 = .9;


res = mirgetdata(mirbrightness(miraudio(signal)));

if res < seuil_1 
    y = -6;
elseif res < seuil_2 && res >= seuil_1
    y = -5;
elseif res < seuil_3 && res >= seuil_2
    y = -4;
elseif res < seuil_4 && res >= seuil_3
    y = -3;
elseif res < seuil_5 && res >= seuil_4
    y = -2;
elseif res < seuil_6 && res >= seuil_5
    y = -1;
elseif res < seuil_7 && res >= seuil_6
    y = 0;
elseif res < seuil_8 && res >= seuil_7
    y = 0;
elseif res < seuil_9 && res >= seuil_8
    y = 0;
else
    y = 1;
    


end