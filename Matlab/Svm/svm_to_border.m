%Take the boder of the isodescriptor in (x,y) points
path0 = '../Cartographies/';


for i=1:1%length(models)
    for j = 1:1%length(exciters)
        for k = 1:1%length(resonators)
            %path = strcat(path, models(i), '_', exciters(j), '_', resonators(k))
            %path = strcat(path0, exciters(j), '_', resonators(k), '/');
            %D = dir(strcat(path, '/*.mat'));
            %[nooffilesf garb]=size(D);
            for l = 1:1%nooffilesf
                file = '../Cartographie/reed_clarinet/modalreedclarinet__freq_zetafixe.mat';% %D(l).name;
                svm = load(strcat(path, file));
                h = svm.svm_end.isoplot();
                X = h(1).ContourMatrix(1,:);
                Y = h(1).ContourMatrix(2,:);
                
                % nb isoline !!!!!!!!!!! comment trouver
                fid = fopen(strcat(path, file(1:end-4), '.txt'),'w');
                for m=1:1%nb_isoLine
                    str = sprintf('%d,', m+60);
                    for n=1:length(X)
                        str = strcat(str, sprintf(' %f %f', X(n), Y(n)));
                    end
                    str = strcat(str, ';\n');
                    fprintf(fid, str);
                end
                fclose(fid);

                
            end
        end
    end
end
% svm = load('reed_clarinet/reedclarinet__oscillation.mat');
% h=svm.svm_end.isoplot();
%     
% X = h(1).ContourMatrix(1,:);
% Y = h(1).ContourMatrix(2,:);
% 
% % figure
% % plot(X, Y, 'o')
% nb_isoLine = 1
% %%
% 
% %put this border in a .txt file
% fid = fopen('../Cartographies/reed_clarinet/reedclarinet__oscillation.txt','w');
% 
% for i=1:nb_isoLine
%     str = sprintf('%d,', i+60);
%     for j=1:length(X)
%         str = strcat(str, sprintf(' %f %f', X(j), Y(j)));
%     end
%     str = strcat(str, ';\n');
%     fprintf(fid, str);
% end
% 
% fclose(fid);
% 
% %%
% %verifie the .txt file
% 
fid = fopen(strcat(path, file(1:end-4), '.txt'));
figure
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