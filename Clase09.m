

% Essence of Linear Algebra - 3Blue1Brown
% https://www.3blue1brown.com/topics/linear-algebra
% checar : CHAPTER 1,2,3,14

% vector, combinacion lineal, transformacion lineal
% vectores y valores propios

% Descargar archivo SpikeSorting.mat 
% https://www.lafuentelab.org/intro-a-matlab


% Deben correr seccion x sección usando 'Run seccion' en menu
% desplegable


% ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
%% NO MODIFICAR !!

clear
clc

% Mantiene las gráficas ancladas en el espacio de trabajo :
set(0,'DefaultFigureWindowStyle','docked')

rng(2022) % semilla de numeros aleatorios

% Función para graficar flechas
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),...
      0, varargin{:} );






%% ░░░░░░░░░░░░░░░░░░░░░░░░EJERCICIO 1░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
%                Varianza y Correlación de datos


% 1) Generaremos numeros correlacionados linealmente

n    = 200;   % Numeros aleatorios que queremos generar
rho  = 0.8;    % Coeficiente de correlación

% Generamos matriz de coeficientes para transformación lineal
coeff    = ones(2) * rho;  
coeff(1,1) = 1; 
coeff(2,2) = 1;
coeff    = sqrtm(coeff);

% ╔═══════════════════════════════════════════════════════════════════
% ║ TODO:             
%   Genera matriz 'DatosAleatorios' de numeros enteros aleatorios
%   con distribución normal. Debe medir 2 x 200 elementos.
%   Luego, usando la matriz 'datos' genera su matriz de correlación.
% ╚═══════════════════════════════════════════════════════════════════

DatosAleatorios  = randn(2,n);

% Hacemos la combinación lineal de numeros aleatorizados y obtenemos 
% matriz 'datos' de 200 x 2 elementos (x,y). 
tmp = coeff * DatosAleatorios;  % Combinación lineal
datos= tmp'; 

% Obtenemos matriz de correlacion
CorrMat = corrcoef(datos);

%  Pista: usa función corrcoef. Ingresa en la ventana de comandos 
% doc corrcoef para ver como puedes aplicarla
%% Visualización datos «««««««««««««««««««««««««««««««««««««««««««««««

fg = figure(1); clf
[datos,CorrMat] = corrDatos(rho);
grafica(datos, CorrMat, fg)

% Panel 3
hp3 = uipanel(fg,'position',[0.5, 0.0, 0.5, 0.3]);
titulo = ['Coeficiente de correlación Rho = ', sprintf('%.2f',rho)];
hp3.Title = titulo;
hp3.FontSize = 11;

% Slice control bar
b = uicontrol('Parent',hp3,'Style','slider',...
      'Position', [20, 50, 150, 20],...
      'value',rho, 'min',-1+eps, 'max',1-eps,...
      'CallBack', {@updateSystem,fg});

uicontrol('Parent',hp3,'Style',...
      'text','Position',[20,30,10,20],...
      'String','0' );
uicontrol('Parent',hp3,'Style',...
      'text','Position',[160,30,10,20],...
      'String','1');






% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××
% CONTESTA LAS SIGUIENTES PREGUNTAS:
% 1.- Jugar con el coeficiente de correlación 'rho' en la gráfica: 
%     Prueba los valores 0.1, 0.5, y 0.99 ¿Qué observas?
% 2.- ¿Qué pasa si rho es negativo? 
% 3.- ¿Cuál eje posee mayor cantidad de varianza?
% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××


%% ░░░░░░░░░░░░░░░░░░░░░░░░EJERCICIO 2░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
%                 Principal Component Analysis
%                  Eigenvalues & Eigenvectors



% ╔═══════════════════════════════════════════════════════════════════
% ║ TODO:             
%   Genera matriz de covarianza 'CovMat' a partir de la 
%   matriz 'datos'
% ╚═══════════════════════════════════════════════════════════════════


% Obtenemos matriz de covarianza
CovMat = cov(datos);

% Calcula eigenvectores de matriz de correlación
% Al calcular los vectores propios (V) y los valores propios (D)
% de la matriz de correlación, se puede calcular el eje
% de mayor varianza
[V,D] = eig(CovMat);  % V:eigenvectors  D:eigenvalues


% Rotacion de datos
% Multiplicamos los datos por los coeficientes para obtener 
% el nuevo sistema de coordenadas 'datosPCA'
coeff = fliplr(V);  % eigenvectores como nuevo sistema de coordenadas
datosPCA = datos* coeff;



%   Pista: lee documentación de función 'cov'
%% Visualización datos «««««««««««««««««««««««««««««««««««««««««««««««

% Visualización de Eigenvectores 
figure(2),clf
subplot(121)
plot(datos(:,1),datos(:,2), 'o', ...
      'MarkerFaceColor', [ 0.5 0.2 0.3],...
      'MarkerEdgeColor', 'w'), hold on
xlabel('x'), ylabel('y') 
set(gca, 'XTick', -3:3,...
      'YTick', -3:3,...
      'Xlim', [-3,3],...
      'Ylim', [-3,3])
title('Datos Originales')
box off, axis square



% 1er eigenvector de la matriz de covarianza
ar{1} = drawArrow([0, V(1,1)], [0 V(1,2)],'MaxHeadSize',15,...
       'linewidth',4,'color','g');

% 2do eigenvector de la matriz de covarianza
ar{2} = drawArrow([0, V(2,1)], [0 V(2,2)],'MaxHeadSize',15,...
      'linewidth',5,'color','b');




subplot(122)
plot(datosPCA(:,1),datosPCA(:,2), 'o',...
      'MarkerFaceColor', [ 0.5 0.2 0.3],...
      'MarkerEdgeColor', 'w'), hold on

xlabel('principal component 1 (PC1)')
ylabel('principal component 2 (PC2)') 
set(gca, 'XTick', -3:3,...
      'YTick', -3:3,...
      'Xlim', [-3,3],...
      'Ylim', [-3,3])
title('Datos rotados por PCA')
box off, axis square

%  Rotamos también los eigenvectores para poderlos visualizar:
V_transf = V * coeff;

% 1er eigenvector de la matriz de covarianza
ar{1} = drawArrow([0, V_transf(1,1)], [0 V_transf(1,2)],...
      'MaxHeadSize',15,'linewidth',4,'color','g');

% 2do eigenvector de la matriz de covarianza
ar{2} = drawArrow([0, V_transf(2,1)], [0 V_transf(2,2)],...
      'MaxHeadSize',15,'linewidth',5,'color','b');

% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××
% CONTESTA LAS SIGUIENTES PREGUNTAS:
% 1.- Después de esta transformación 
%     ¿Cuál eje posee mayor cantidad de varianza?
%       El eje del componente 1
% 2.- Porqué se rotaron 45 grados los datos?
%       El eje de mayor peso se convierte en el eje horizontal
%     ¿Porqué los eigenvectores están a 90º entre si?
%       Porque cada
% 3.- ¿Qué representa el PC1? ¿Qué unidades tiene?
% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××


%% ░░░░░░░░░░░░░░░░░░░░░░░░EJERCICIO 3░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
%                   PCA  y varianza explicada

clear 
clc

n = 200;
x = randn(n,1);
y = x * 0.85 + rand(n,1)*0.1;
z = y * 0.1 + rand(n,1)*0.5;

datos = [x,y,z];


% ╔═══════════════════════════════════════════════════════════════════
% ║ TODO:             
%   Aplica la función 'pca' en la matriz datos, y asegurate de
%   obtener las siguientes variables llamadas: 
%   'coeff'       : coeficientes de los componentes principales 
%   'datosPCA'    : Principal component scores are the representations 
%                    of X in the principal component space
%   'VarianzaExp' : the percentage of the total variance explained by
%                    each principal component
% ╚═══════════════════════════════════════════════════════════════════



% Obtenemos el PCA usando la función de Matlab


[coeff, datosPCA, ~, ~, VarianzaExp] = pca(datos);



% pista: busca qué input y output necesita la función pca
% utilizando doc pca en la ventana de comandos

%% Visualización datos «««««««««««««««««««««««««««««««««««««««««««««««
figure(3),clf

tiledlayout(3, 2, 'TileSpacing','compact', 'Padding','compact')

% Datos originales 
nexttile([1,2])
plot3(x,y,z, 'o', 'MarkerFaceColor','w', 'MarkerEdgeColor','k',...
      'MarkerSize', 7, 'LineWidth',1), hold on
title('Datos Originales')
xlabel('x'), ylabel('y'), zlabel('z') 
view([10 25])
grid on

% + Ejes de mayor varianza
plot3([0 coeff(1,1)],[0 coeff(2,1)],[0 coeff(3,1)],...
      'r', 'LineWidth',5)
plot3([0 coeff(1,2)],[0 coeff(2,2)],[0 coeff(3,2)],...
      'b', 'LineWidth',5)
plot3([0 coeff(1,3)],[0 coeff(2,3)],[0 coeff(3,3)],...
      'g', 'LineWidth',5)

% Legend
[~,hObj] = legend({'','','',''},'FontSize',12,...
      'Location','NorthEastOutside',...
      'AutoUpdate','off',...
      'Box', 'off');
hleg = legend(hObj,{'','1er','2do','3er'});   
title(hleg, 'Ejes de','mayor varianza');


% Datos PCA
nexttile
plot3(datosPCA(:,1),datosPCA(:,2),datosPCA(:,3), 'o',...
       'MarkerFaceColor','b', 'MarkerEdgeColor','k',...
      'MarkerSize', 7, 'LineWidth',1)
title('Datos PCA : ','nuevo sistema de coordenadas')
xlabel('PC1'), ylabel('PC2'), zlabel('PC3')
view([10 25])
grid on, axis tight

% Varianza explicada
nexttile
tmp = cumsum(VarianzaExp);
plot(tmp, '-.', 'LineWidth',6, 'Color','m');
xlabel('Componente'), ylabel('% Var Exp')
box off
title("Varianza Explicada")

nexttile([1 2])
plot( datosPCA(:,1),datosPCA(:,2),'o', ...
      'MarkerFaceColor','b', 'MarkerEdgeColor','k',...
      'MarkerSize', 7, 'LineWidth',1)
title('Reduccion','de dimensiones')
box off
xlabel('PC1'), ylabel('PC2'), zlabel('PC3')




% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××
% CONTESTA LAS SIGUIENTES PREGUNTAS:

% 1.- Observa el rango de los ejes 'x', 'y', y 'z',
% ¿Qué pasó con los ejes del nuevo sistema de coordenadas luego de
%  aplicar el PCA? 
% ¿Qué crees que signifique?
% 2.- ¿Qué información te da la gráfica de Varianza Explicada?

% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××



%% ░░░░░░░░░░░░░░░░░░░░░░░░EJERCICIO 4░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
%                PCA de series de tiempo y Kmeans

% Vamos a usar PCA para reducir las dimensiones de las espigas de 40
% muestras a 3, para ver si podemos diferenciar los tipos de espigas que
% tenemos en el registro

clear 
clc

% % Carga archivo
load('SpikeSorting.mat')

% Tenemos 80mil espigas! Selecionamos unas cuantas para el analisis
espigas         = double(session(2).wf);  % Waveform
numEspigas      = size(espigas,1);
numEspigasFinal = 500;
indices         = randi(numEspigas,1,numEspigasFinal);
espigas_sample  = espigas(indices,:);


% ╔═══════════════════════════════════════════════════════════════════
% ║ TODO:             
%   Aplica la función 'pca' en la matriz espigas_sample, con la
%   siguiente variable como output : 
%  'pcaEspigas' : Principal component scores are the representations 
%                    of X in the principal component space
%   
% ╚═══════════════════════════════════════════════════════════════════


[coeff, pcaEspigas, ~, ~, VarianzaExp] = pca(espigas_sample);





%% Visualización datos «««««««««««««««««««««««««««««««««««««««««««««««
figure(4)
subplot(211)
plot(espigas(1:200,:)')
xlabel('# de muestras (t)'), ylabel('voltage (mV)')
title('Potencial de Acción extracelular')
box off

subplot(212)
plot3(pcaEspigas(:,1),pcaEspigas(:,2),pcaEspigas(:,3), 'o')
xlabel(gca,'PC1'), ylabel(gca,'PC2'), zlabel(gca,'PC3')
title('PCA de registro')




% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××
% CONTESTA LAS SIGUIENTES PREGUNTAS:
% 1.- ¿Qué representa cada punto en este caso?
% 2.- ¿Qué información representan los componentes principales?

% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××

%% K means
% Algoritmo de clasificación 

nClusters = 2;  % numero de 'clusters'
idx = kmeans(pcaEspigas(:,1:3),nClusters);



%% Visualización datos «««««««««««««««««««««««««««««««««««««««««««««««
colores = [  [156,215,139] ; [90, 50, 93] ;   [187, 220, 221] ; 
      [255, 177, 78]]./256;

figure(5)

subplot(211)
for jj = 1:nClusters
      plot3(pcaEspigas(idx==jj,1), pcaEspigas(idx==jj,2),...
            pcaEspigas(idx==jj,3), 'o',...
            'MarkerFaceColor', colores(jj,:),...
            'MarkerEdgeColor', 'w',...
            'MarkerSize',10), hold on
end

xlabel(gca,'PC1'), ylabel(gca,'PC2'), zlabel(gca,'PC3')
title('Clusterización por K means')


% Colorizamos las espigas originaes usando la agrupación que obtuvimos
% por Kmeans
subplot(212)
for k = 1 : numEspigasFinal
      plot(espigas_sample(k,:), 'Color', colores(idx(k),:)), hold on
end
xlabel('# de muestras (t)'), ylabel('voltage (mV)')

% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××
% CONTESTA LAS SIGUIENTES PREGUNTAS:
% 1.- Juega con el numero de clusters. ¿Qué pasa con la clasificación?
% ¿Cuál crees que es el número de clusters adecuado?
% 
% ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××










%% 
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⠴⠶⠶⠶⠶⠶⠶⠶⠶⢤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠶⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⣰⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣦⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⢰⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⣿⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⢹⡄⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⡏⠀⢰⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢸⡇⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⣿⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡟⠀⢸⡇⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⢹⡆⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⠀⣾⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠈⢷⡀⢸⡇⠀⢀⣠⣤⣶⣶⣶⣤⡀⠀⠀⠀⠀⠀⢀⣠⣶⣶⣶⣶⣤⣄⠀⠀⣿⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠈⢷⣼⠃⠀⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⡇⠀⢸⡾⠃⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⠃⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠘⢿⣿⣿⣿⣿⡿⠃⠀⢠⠀⣄⠀⠀⠙⢿⣿⣿⣿⡿⠏⠀⠀⢘⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠀⠈⠉⠉⠀⠀⠀⣴⣿⠀⣿⣷⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣄⡀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠀⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣟⠳⣦⡀⠀⠀⠀⠸⣿⡿⠀⢻⣿⡟⠀⠀⠀⠀⣤⡾⢻⡏⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⢻⠻⣆⠀⠀⠀⠈⠀⠀⠀⠈⠀⠀⠀⢀⡾⢻⠁⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⡆⢹⠒⡦⢤⠤⡤⢤⢤⡤⣤⠤⡔⡿⢁⡇⠀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡇⠀⢣⢸⠦⣧⣼⣀⡇⢸⢀⣇⣸⣠⡷⢇⢸⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⠀⠈⠺⣄⣇⢸⠉⡏⢹⠉⡏⢹⢀⣧⠾⠋⠀⢠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣆⠀⠀⠀⠈⠉⠙⠓⠚⠚⠋⠉⠁⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
% ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⠶⠦⣤⣤⣤⡤⠶⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀




% PUMPKIN
figure(6)
bumps=10; bdepth=.1; bdepth2=.02; dimple=.2; width_r=1; height_r=.8;
[ Xs, Ys, Zs ] = sphere(199);
Rxy=(0-(1-mod(linspace(0,bumps*2,200),2)).^2)*bdepth + (0-(1-mod(linspace(0,bumps*4,200),2)).^2)*bdepth2;
Rz = (0-linspace(1,-1,200)'.^4)*dimple;
Xp = (width_r+Rxy).*Xs;
Yp = (width_r+Rxy).*Ys;
Zp = (height_r+Rz).*Zs.*(Rxy+1);
Cp = hypot(hypot(Xp,Yp),width_r.*Zs.*(Rxy+1));

% STEM
sheight=.5; scurve=.4;
srad = [ 1.5 1 repelem(.7, 6) ] .* [ repmat([.1 .06],1,bumps) .1 ]';
[theta, phi] = meshgrid(linspace(0,pi/2,size(srad,2)),linspace(0,2*pi,size(srad,1)));
Xs = (scurve-cos(phi).*srad).*cos(theta)-scurve;
Zs = (sheight-cos(phi).*srad).*sin(theta) + height_r-max(0,dimple*.9);
Ys = -sin(phi).*srad;

% DRAW
surf(Xp,Yp,Zp,Cp,'Clipping','off');
shading interp
colormap([ linspace(.94, 1, 256); linspace(.37, .46, 256); linspace(0, .1, 256) ]');
surface(Xs,Ys,Zs,[],'FaceColor', '#008000', 'EdgeColor','none', 'Clipping','off');
material([ .6, .9, .3, 2, .5 ])
lighting g
axis('equal',[-1 1 -1 1 -1 1]);
xlabel('x')
set(gca,'XColor', 'none','YColor','none','ZColor','none')
box off, grid off

% TEXT
text(-0.8,0.5,-1.5,  'happy HALLOWEEN',...
      'FontSize',30, 'FontWeight','bold')

camlight

