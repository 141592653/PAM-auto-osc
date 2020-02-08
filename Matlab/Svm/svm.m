% desc_name (string) = le nom du descritpeur
% nb_points (int) = nb de points pour la svm
% model_name (string) = nom du modèle qu'on veut utiliser
% instrument_name (string) = nom de l'instrument qu'n modélise (c'est pour
% donner un nom à la figure)
% format (string) = format auquel on veut enregistrer 
% args (matrice) = liste des arguments constants pour le modèle
% path (string) = le dossier où enregistrer l'image

function svm(model_name, args, desc_name, nb_points, nb_edsd, instrument_name, path, formats)
    if(nargin > 9)
        error("too many inputs");
    end
    
    fprintf("Le descripteur est %s\n", desc_name);
    fprintf("Le modèle est %s\n", model_name);

    seuil = 2;
    
    % chercher pointeur sur la fonction de descripteur
    if(strcmpi(desc_name, 'oscillation'))
       descriptor = @(signal) oscillation(signal, 0.1);
    elseif(strcmpi(desc_name, 'brightness'))
       descriptor = @(signal) brightness(signal);
       seuil = 10;
    end
    
    % chercher pointeur sur la fonction du modèle
    if(strcmpi(model_name, 'clarinet_modal2'))
        model = @(zeta, gamma, args) clarinet_modal2(zeta, gamma, args);
    elseif(strcmpi(model_name, 'clarinet_modal'))
        model = @(args) clarinet_modal(args);
    end

    % créer les points
    fprintf("création des points\n");
    x = lhsdesign(nb_points,2);
    %x(:,3) = 1000*x(:,3);
    
    
    fprintf("appliquer le descripteur à tous les points\n");
    
    result = @(x) descriptor(real(model(x(1), x(2), args))');
    
    y = zeros(1, nb_points);
    for i = 1:nb_points
       y(i) = result(x(i,:)); 
    end
    
    fprintf("y OK\n");
    
    y = y';
    
    % 2 cas différents : descriptor -1 ou +1
    % descriptor à plusieurs seuils
    
    % if(seuil == 2)
        
    SVM = CODES.fit.svm(x,y);
    
    fprintf("Svm fit done\n");
    
<<<<<<< HEAD:Matlab_modele_modal/svm.m
    svm_col = CODES.sampling.edsd(result, SVM, [0 0], [1 1] , 'iter_max', 50, 'conv', false);
=======
    svm_col = CODES.sampling.edsd(result, SVM, [0 0], [1 1] , 'iter_max', nb_edsd, 'conv', false);
>>>>>>> f80639d3f0e5a6fe87454dfb47441ec87d106fe2:Matlab/Svm/svm.m
    
    fprintf("edsd fit done\n");
    figure;
    svm_col{end}.isoplot('legend', false, 'sv', false, 'samples', false)
    %axis equal 
    xlabel('zeta')
    ylabel('gamma')
    title('Descripteur : oscillation. A = 30, Q = 10')

    if(seuil > 2)
        fprintf("Cas où plusieurs seuil dans le descripteur\n");
        
        svm_end = svm_col{end};
        for i=1:seuil
            fprintf("seuil %d\n", i);
            SVM = CODES.fit.svm(svm_end.X, svm_end.Y + i);
            fprintf("edsd seuil %d\n", i);
<<<<<<< HEAD:Matlab_modele_modal/svm.m
            svm_col = CODES.sampling.edsd(result, SVM, [0 0], [1 1] , 'iter_max', 50, 'conv', false);
=======
            svm_col = CODES.sampling.edsd(g, SVM, [0 0], [1 1] , 'iter_max', nb_edsd, 'conv', false);
>>>>>>> f80639d3f0e5a6fe87454dfb47441ec87d106fe2:Matlab/Svm/svm.m
            % ?? pas sûre de s'il faut faire cette prochaine ligne 
            % ou continuer avec le svm_end du début
            svm_end = svm_col{end};
            svm_end.isoplot('bcol', 'k', 'samples', false);
            hold on
        end
    end
    
<<<<<<< HEAD:Matlab_modele_modal/svm.m
    
    % la partie récupération des courbes ne fonctionne pas 
    
%     fprintf("Récupére les courbes\n");
%     % récupérer toutes les courbes
%     courbe = findobj(gcf,'Color','g');
%     xd = get(courbe,'XData');
%     yd = get(courbe,'YData');
%     
%     
%     figure;
%     plot(xd, yd);
%     
%     % enregistrer les graphes en images
%     filename = strcat('svm_', instrument_name, int2str(num));
%     
%     fprintf("%s\n", filename);
%     saveas(gcf, filename, format);
%     
%     %saveas(gcf, filename, 'm');
=======
    % enregistrer les graphes en images
    if(~exist(path, 'dir'))
       mkdir(path); 
    end
    filename = strcat(path, 'svm_', instrument_name);
    
    for i=1:length(formats)
        saveas(gcf, filename, formats(i));
    end
>>>>>>> f80639d3f0e5a6fe87454dfb47441ec87d106fe2:Matlab/Svm/svm.m
 
end