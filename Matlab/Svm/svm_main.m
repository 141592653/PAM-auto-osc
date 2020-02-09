clear all;

% add path
addpath '..\Modele_Physique\modele_modal'
addpath '..\Modele_Physique\modele_guide_onde'
addpath '\Descripteurs'

% une liste de tous les noms de modèles
% A REMPLIR AU FUR ET A MESURE !!!!!!!!!
models = ["clarinet_modal", "clarinet_modal2"];

% une liste de tous les noms de descripteurs
% A REMPLIR AU FUR ET A MESURE !!!!!!!!!
descriptors = ["oscillation", "brightness"];

% données qui ne varient pas
% A REMPLIR !!!!!!!!!
nb_points = 300;
nb_edsd = 50;
T = 1;
Fs = 44100;
dt = 1/Fs;
N = T/dt;

% données d'enregistrement d'image
format = ["m", "pdf"];
path = "../../Cartographies/";

% les arguments
% A FAIRE !!!!!!!
args = ["des", "choses"];


for i=1:length(models)
    new_path = strcat(path, models(i), "/");
    for j=1:length(descriptors)
       nom_svm = strcat(models(i), '_', descriptors(i));
       fprintf("Calculating SVM for %s\n", nom_svm);
       
       svm(models(i), args, descriptors(i), nb_points, nb_edsd, nom_svm, new_path, formats);
    end
end