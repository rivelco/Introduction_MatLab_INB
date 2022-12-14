%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Tarea encargada el día jueves 8 de septiembre, 2022            %
%         Ejercicio de uso de for, if y find con nuestros datos           %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Contexto
% Este código es una función porque la uso así en un programa que estoy
% haciendo para analizar mis datos. En este caso la función recibe la
% ubicación de un archivo para leer, si no se le pasa la ubicación uno
% puede seleccionarlo manualmente. El archivo contiene una matriz con
% vectores poblacionales para análisis de ensambles utilizando imagenología
% por calcio. La función genera un archivo donde se encuentran los
% vectores poblacionales donde se encuentre una actividad menor o igual a
% K, es decir, donde al menos K células hayan tenido actividad. Los demás
% datos del archivo original se mantienen.
% El resto del programa en su versión actual están en mi repositorio de
% GitHub: https://github.com/rivelco/TransientsCharacterizer

function finalFile =  SignificantVectors(fileToRead)
    if nargin == 0
        % Change this to select a different
        fileToRead = uigetfile('*.*','Choose file to filter');
    end

    % Load that file
    load(fileToRead);
    
    % Get the sizes from data and UDF matrix
    [~, colsD] = size(data);
    [~, colsU] = size(UDF);
    
    % Select only those population vectors that has K or more active
    % neurons
    K = 10;
    indexes = find(sum(data, 2) >= K);
    
    % Create the new variables
    newData = zeros(length(indexes), colsD);
    newUDF = zeros(length(indexes), colsU);
    
    % Fill the new variables using only the indexes from the valid vectors
    for i = 1:length(indexes)
        newData(i, :) = data(indexes(i), :);
        newUDF(i, :) = UDF(indexes(i), :);
    end

    % Make sure that coords has 3 dimensions, so it works right away with 
    % the CRF program
    [rowsC, colsC] = size(coords);
    if colsC < 3
        coords = [coords zeros(rowsC, 1)];
    end
    
    % Change the variables, only for the name
    data = newData;
    UDF = newUDF;
    
    % Change the filename to add the K used
    filename = filename + "_K" + K;

    % Create the new file name
    [~, finalFile, ~] = fileparts(fileToRead);
    finalFile = finalFile + "_K" + K;
    
    % Save the variables in a new file, ready to use
    save(finalFile, "filename", "coords", "data", "UDF");
end