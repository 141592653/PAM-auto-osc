%Take the boder of the isodescriptor in (x,y) points
svm = load('isSound_440_0.3_1.1_0_6.mat');
h=svm.finalSVM.isoplot();
    
X = h(1).ContourMatrix(1,:);
Y = h(1).ContourMatrix(2,:);

% figure
% plot(X, Y, 'o')
nb_isoLine = 1
%%

%put this border in a .txt file
fid = fopen('test.txt','w');

for i=1:nb_isoLine
    str = sprintf('%d,', i);
    for j=1:length(X)
        str = strcat(str, sprintf(' %f %f', X(j), Y(j)));
    end
    str = strcat(str, ';\n');
    fprintf(fid, str);
end

fclose(fid);

%%
%verifie the .txt file

fid = fopen('test.txt');
hold on
j = 1;
while(~feof(fid))
    ligne = fgetl(fid);	
    ligne = split(ligne, ',');
    ligne = ligne(2);
    ligne = split(ligne, ';');
    ligne = ligne(1);
    ligne = split(ligne, ' ');
    ligne = ligne(2:end);
    for i=1:floor(length(ligne)/2-1)
        plot(str2double(ligne(2*i)),str2double(ligne(2*i+1)),  'o')
    end
    j = j+1;
end

fclose(fid);