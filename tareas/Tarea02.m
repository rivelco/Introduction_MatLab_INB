%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Tarea encargada el día jueves 01 de septiembre, 2022           %
%                   Histograma y plot de mis datos                        %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc

% Cargo el archivo de mi base de datos en el entorno de MATLAB
% No es necesario usar detectImportOptions en este caso
load("databases\labDB.mat");

% Me interesa analizar por ahora la variable data
% que contiene los datos binarios de actividad de células usando
% imagenología por calcio, los 1 son actividad, los 0 son inactividad. Esta
% actividad se mide en diferentes momentos
actividad = data;

% Obtenemos la cantidad de frames. m frames y n neuronas
[m, n] = size(actividad);

% Ahora extraeré la cantidad de spikes (1's) que hubo en cada frame
actividadPorFrame = zeros(m, 1);        % Inicializo el vector
for i = 1:m     % Itero en los m frames
    actividadPorFrame(i) = sum(actividad(i,:)); % La suma es el conteo
end

figure(1)
% Grafico la actividad de las células en cada fotograma
plot(actividadPorFrame)
xlabel('Fotograma')                        % Título del eje x
ylabel('Cantidad de activaciones')         % Título del eje y
title('Activaciones en el tiempo')         % Título de la gráfica

figure(2)
% Puedo ver en un histograma las respuestas más frecuentes
histogram(actividadPorFrame)
xlabel('Cantidad de respuestas')           % Título del eje x
ylabel('Frecuencia')                       % Título del eje y
title('Frecuencia de respuestas')          % Título de la gráfica

% eof