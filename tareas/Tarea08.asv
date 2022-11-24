% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%                          TAREA PCA
%           »»»»»»»»»»»  ver Oct 2022  «««««««««««

% ░░░░░░░░░░░░░░░░░░░░░   ~ readme ~   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
% 
% Fecha de entrega: Jueves 3 de Noviembre
% Corregido y enviado de nuevo el Jueves 24 de Noviembre

% A continuación trabajarás con los datos de la compañera Lucia Cano
% y aplicarás PCA y Kmeans 

% ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░


% Antes de comenzar con el ejercicio responde:
% ¿Cuál es el propósito del análisis?¿Qué esperas observar?

% Que los datos de cada grupo se diferencíen entre sí en diferentes
% clusters, pues en conjunto todos los datos de cada grupo deberán formar
% un punto en caa uno de los n componentes en un espacio de n dimensiones,
% cada punto deberá de estar en un lugar diferente en ese espacio pues lo
% grupos serán diferentes entre sí. Es probable que varios datos compartan
% una psociión cercana o casi igual en el espacio pues un par de grupos
% podría ser semejante entre sí.


% __________________________start_____________________________________


clear
clc


% Mantiene las gráficas ancladas en el espacio de trabajo :
set(0,'DefaultFigureWindowStyle','docked')

% Paso 1. Pre-procesar los datos
tabla = readtable('Cano_hernandez_lucia_carolina2.xlsx', ...
             'VariableNamingRule', 'preserve');

% Convertir tabla a matriz
datos = table2array(tabla(:, 6:11));

% Re-organizar datos de la siguiente forma : 
% filas    = grupos
% columnas = obervaciones

% Obtener indice de cada grupo
namesCondiciones  = tabla.CONDICION;
[grupos,indices,ocurrencia] = unique(namesCondiciones,'legacy');

% Número minimo de observaciones
minObs = min(indices - [0; indices(1:3)]);
% Número maximos de observaciones
maxObs = max(indices - [0; indices(1:3)]);

% Declaramos matriz vacía para almacenar los datos
datosXgrupo = nan(size(grupos,1),maxObs*size(datos,2));

% Obtenemos los datos de cada gpo
for g = 1 : length(grupos)
      tmp = reshape(datos(ocurrencia==g, :),1,[]);  
      datosXgrupo(g,1:size(tmp,2)) = tmp;
end

% Matriz final de datos re-organizados
X = datosXgrupo(:,1:minObs*6);

%%
% Aplicar PCA a matriz de datos re-organizados
[coeff, datosPCA, ~, ~, VarianzaExp] = pca(X');

% Aplicar K means de 3 clusters
nClusters = 3;  % numero de 'clusters'
idx = kmeans(datosPCA(:,1:3), nClusters);


%% Visualización de datos 

% Grafica de 3 dimensiones con los primeros 3 componentes principales
% Separando por diferentes colores cada grupo
% + Ejes de mayor varianza
colores = [  [156,215,139] ; [90, 50, 93] ;   [187, 220, 221] ; 
      [255, 177, 78]]./256;

figure(1), clf
for grupo = 1:length(grupos)
    plot3(datosPCA(ocurrencia==grupo, 1),...
        datosPCA(ocurrencia==grupo, 2),...
        datosPCA(ocurrencia==grupo,3), ...
        'o', 'MarkerFaceColor',colores(grupo,:));
    hold on
end
title('Datos PCA : ','nuevo sistema de coordenadas')
xlabel('PC1'), ylabel('PC2'), zlabel('PC3')
view([10 25])
grid on, axis tight
% Corregí la distribución de colores

% Grafica de 3 dimensiones donde se identifique cada cluster 
% por un color diferente 
figure(2), clf
for jj = 1:nClusters
      plot3(datosPCA(idx==jj,1), datosPCA(idx==jj,2),...
            datosPCA(idx==jj,3), 'o',...
            'MarkerFaceColor', colores(jj,:),...
            'MarkerEdgeColor', 'w',...
            'MarkerSize',10), hold on
end

%% Responde:

% ¿Qué observas de tus resultados de K-means? 
% Los resultados de K-means muestran la distribución en diferentes grupos o
% clústers, los grupos parecen envolver a tres conjuntos diferentes de
% puntos, hay un punto que es definitivamente muy diferente a los demás.
% Creo que es un resultado muy útil pues permite distinguir dos grupos 
% principales y probablemente un extremo, habría que revisar la forma en 
% que se obtuvo ese dato, igual ver si separar dos grupos tiene congruencia
% en la literatura.

% ¿Qué concluyes de este análisis?
% Es posible modelar estos datos con un PCA, al parecer tres componentes
% explican una cantidad importante de varianza y separa muy bien tres
% grupos diferentes, pero hay que revisar el sentido que pueden tener esos
% tres grupos diferentes. Creo que es un análisis muy útil para hacer
% reducción dimensional y aunque no siempre es el mejor análisis de este
% tipo, es relativamente rápido hacerlo, lo que ayuda mucho como un
% análisis "exploratorio" aunque claro que se puede usar para más cosas que
% solo explorar los datos.
