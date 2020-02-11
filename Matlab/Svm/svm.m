% desc_name (string) = le nom du descritpeur
% nb_points (int) = nb de points pour la svm
% model_name (string) = nom du modèle qu'on veut utiliser
% instrument_name (string) = nom de l'instrument qu'n modélise (c'est pour
% donner un nom à la figure)
% format (string) = format auquel on veut enregistrer 
% args (matrice) = liste des arguments constants pour le modèle
% path (string) = le dossier où enregistrer l'image

function svm(model_name, desc_name, exc_name, resonator_name, para_fixe, args,...
    nb_points, nb_edsd, nom_svm, path, formats)

    if(strcmpi(model_name, 'clarinet_modal2'))
        models = "modal";
    else
        models = "guide_onde";
    end

    if(nargin > 11)
        error("too many inputs");
    end
    
    fprintf("Le descripteur est %s\n", desc_name);
    fprintf("Le modèle est %s\n", model_name);

    seuil = 2;
    
    % arguments 
%     if(strcmpi(model_name, 'clarinet_modal2'))
%         [F,Q,Z] = paraResonator(resonator_name);
%     end
    
    % chercher pointeur sur la fonction de descripteur
    if(strcmpi(desc_name, 'oscillation'))
       descriptor = @(signal) oscillation(signal, 0.1);
    elseif(strcmpi(desc_name, 'brightness'))
       descriptor = @(signal) brightness(signal);
       seuil = 10;
    elseif(strcmpi(desc_name, 'freq'))
       descriptor = @(signal) freq(signal);
       seuil = 24;
    end
    
    
    % chercher pointeur sur la fonction du modèle
    if(strcmpi(model_name, 'clarinet_modal2'))
        model = @(x,y,args) clarinet_modal2(x,y,args);
    elseif(strcmpi(model_name, 'clarinet_modal'))
        model = @(args) clarinet_modal(args);
    end

    % créer les points
    fprintf("création des points\n");
    x = lhsdesign(nb_points,2);
    
    min_svm = [0,0];

    % les parametres de la svm
    if((strcmpi(para_fixe, 'L')))
        % zeta gamma
        %L = 0.5; % fixe     
        max_svm = [1,1];      
    elseif((strcmpi(para_fixe, 'gamma')))
        % zeta L
        % gamma = 0.8;
        x(:,2) = 2*x(:,2); % L peut varier jusqu'à 2m
        max_svm = [1,2]; 
    else
    % gamma L
        % zeta = 0.8;
        x(:,2) = 2*x(:,2); % L peut varier jusqu'à 2m
        max_svm = [1,2]; 
    end
     
    fprintf("appliquer le descripteur à tous les points\n");

    args0 = {para_fixe, exc_name, resonator_name};
    args = [args0, args];
    

    result = @(x) descriptor(real(model(x(1), x(2), args))');
    
    y = zeros(1, nb_points);
    for i = 1:nb_points
       y(i) = result(x(i,:)); 
    end
    
    fprintf("y OK\n");
    
    y = y';
    
    % 2 cas différents : descriptor -1 ou +1
    % descriptor à plusieurs seuils
    SVM = CODES.fit.svm(x,y);
    fprintf("Svm fit done\n");
    
    svm_col = CODES.sampling.edsd(result, SVM, min_svm, max_svm, 'iter_max', nb_edsd, 'conv', false);

    fprintf("edsd fit done\n");
    
    svm_end = svm_col{end};
        
    figure;

    
    if(seuil > 2)
        if(~exist(strcat(path, desc_name, '_', para_fixe) , 'dir'))
            mkdir(strcat(path, desc_name, '_', para_fixe) ); 
        end
        fprintf("Cas où plusieurs seuil dans le descripteur\n");
        
        filename0 = strcat(path, desc_name, '_', para_fixe, '/', models, exc_name, resonator_name, '_', para_fixe, 'fixe_');
        svm_end = svm_col{end};
        save(strcat(filename0, '1.mat'), 'svm_end');
        
        for i=1:seuil-1
            color = [i/seuil, i/seuil, 1-i/seuil];
            fprintf("seuil %d\n", i);
            %svm_end.Y = svm_end.Y + 1;
            %svm_end.Y
            svm_end.Y
            SVM = CODES.fit.svm(svm_end.X, svm_end.Y+i);
            fprintf("edsd seuil %d\n", i);
            svm_col = CODES.sampling.edsd(result, SVM, min_svm, max_svm , 'iter_max', nb_edsd, 'conv', false);
            svm_end = svm_col{end};
            svm_end.isoplot('bcol',color, 'samples', false, 'sv', false);
            save(strcat(filename0, sprintf('%d.mat', i) ), 'svm_end');
            hold on 
        end
    end
    
    if(seuil == 2)
        svm_end.isoplot('legend', false, 'sv', false, 'samples', false)
    end
    %axis equal 
    if(strcmpi(para_fixe, 'L'))
        xlabel('zeta')
        ylabel('gamma')
    elseif(strcmpi(para_fixe, 'gamma'))
        xlabel('zeta')
        ylabel('L')
    elseif(strcmpi(para_fixe, 'zeta'))
        xlabel('gamma')
        ylabel('L')
    end
        
    title(sprintf('Descripteur : %s  Instrument : %s  Model : %s', desc_name, strcat(exc_name, resonator_name), models))

    

    % enregistrer les graphes en images
    if(~exist(path, 'dir'))
       mkdir(path); 
    end
    filename = strcat(path, models, nom_svm, '_', para_fixe, 'fixe');
    
    for i=1:length(formats)
        saveas(gcf, filename, formats(i));
    end
    % save(strcat(filename, '.mat'), 'svm_end')
end