clear all;

% add path
addpath '..\Modele_Physique\modele_modal'
addpath '..\Modele_Physique\modele_guide_onde'
addpath '\Descripteurs'

% une liste de tous les noms de modèles
% A REMPLIR AU FUR ET A MESURE !!!!!!!!!
models = ["clarinet_modal2", "clarinet_modal2"];

% une liste de tous les noms de descripteurs
% A REMPLIR AU FUR ET A MESURE !!!!!!!!!
descriptors = ["oscillation", "brightness"];

% toutes les combinaisons d'instrument
% resonator
resonators = ["clarinet", "saxophone", "trompet"];
% exciter 
exciters = ["lippal", "reed"];

% données qui ne varient pas
% A REMPLIR !!!!!!!!!
nb_points = 300;
nb_edsd = 50;
T = 1;
Fs = 44100;
dt = 1/Fs;
N = T/dt;
qr = 0.1;
u0 = 0; u1 = 0; p0 = 0; p1 = 0;

% données d'enregistrement d'image
format = ["m", "pdf"];
path = "../../Cartographies/";

% les arguments
% A FAIRE !!!!!!!
args = [T dt qr u0 u1 p0 p1];
parameters = ["gamma", "zeta"]; %% rajouter dans un boucle !!!!!!!!!!

for i=1:1%length(models)
    for j = 1:1%length(exciters)
        for k = 1:1%length(resonators)
            new_path = strcat(path, strcat(exciters(j), resonators(k), '_'), "/");
            for l = 1:1%length(descriptors)
               nom_svm = strcat(strcat(exciters(j), resonators(k), '_'), '_', descriptors(i));
               fprintf("Calculating SVM for %s\n", nom_svm);
               svm(models(i), descriptors(i), exciters(j), resonators(k),...
                   parameters, args, nb_points, nb_edsd, nom_svm, new_path, format);
            end
        end
    end
end