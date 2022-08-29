%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Tarea encargada el día lunes 29 de agosto, 2022              %
%                    Leer un archivo con readtable                        %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc

% Para leer una archivo en el mismo directorio de la ejecición podemos
% utilizar directamente la función 'readtable' pasando como argumento
% el nombre del archivo a leer, o en su defecto el directorio hijo completo
datos1 = readtable("DB01.txt");

% Si esta función levanta una advertencia, puede ser porque el archivo
% no contiene cabecera con nombre de cada variable, es decir, el archivo 
% tiene solamente una línea de valores, en ese caso hay que indicar que
% hay que manejar esa primera (y única línea) como variables, pasando
% los siguientes argumentos

datos2 = readtable("DB01.txt", 'ReadVariableNames', false);

% Exploración incial de los datos

mean(datos2)
std(datos2)
histogram(datos2)

% eof