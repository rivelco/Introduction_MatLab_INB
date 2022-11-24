clear, clc

opts = detectImportOptions("databases\Datos_Fernando_Lizcano.xlsx");
tabla = readtable("databases\Datos_Fernando_Lizcano.xlsx", opts);
matrizDatos = table2array(tabla(:, 2:end));

% Hacemos análisis de componentes principales. Hay que recoerdar que en la
% variable de salida score tiene los mismos datos que la tabla oriinal pero
% están ordenados de manera distinta, reordenados de manera que la primera
% columna tiene más varianza que todas las demás columnas.
% Usamos el PCA para reducir dimensiones
[coeff, score, latent, ~, explained] = pca(matrizDatos);

% Lo de las varianzas de score se puede demostrar así. Hay que notar que
% aquí ponemos 'omitnan' para omitir los NaN
varianzas = var(score, 'omitnan');

% Ahora centramos los datos en cer, a cada columna le restamos su promedio
Xcentered = score*coeff;

% Aquí tenemos los nombres de las diferentes variables de la tabla
variables = {'DigitDirecto','DigitInverso','Flanker','Aritmetica', ...
    'SpatialWM', 'Vocabulario','Gonogo','LocalGlobal','Speechinnoise', ...
    'velocidad','Wisconsin'};

% Explained nos dice la varianza explicada por cada columna
varExplicada = [explained cumsum(explained)];

figure(1)
% Aquí haremos una gráfica de los primeros 3 componentes, cada punto será
% un punto, cada sujeto es un punto
subplot(121)
plot3(score(:, 1), score(:, 2), score(:, 3), 'o', 'MarkerFaceColor', 'blue')
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')

% Con esto podemos graficar qué tanto aporta cada variable a cada uno de
% los componentes
subplot(122)
biplot(coeff(:, 1:3), 'Scores', score(:, 1:3), 'VarLabels', variables)

% Hacemos una prueba de cuántos grupos queremos probar para ver sus
% diferentes formas de clasificación
nGruposAProbar = 10;

% Ahora hacemos los clusters
clust = zeros(size(matrizDatos, 1), nGruposAProbar);

% Una vuelta por cantidad de grupos
for nGrupos = 1:nGruposAProbar
    clust(:, nGrupos) = kmeans(matrizDatos, nGrupos, 'Replicates', 5);
end

% Calcula el número de clusters óptimo utilizando el algoritmo ese de
% nombre CalinskiHarabasz, de tal manera que los grupos estén lo más
% separados posibles
eva = evalclusters(matrizDatos, clust, "CalinskiHarabasz");

% La forma de determinar en cuantos grupos se quiere clasificar es
% utilizando alguna razón biológica o sino pues usar el algoritmo de mejor
% cantidad de clusters como aquí
nClustersOptimo = eva.OptimalK;

% ID tiene a qué número de cluster pertenece cada dato. Se usa lo de los
% replicates = 10, para que se eviten los mínimos locales
[ID, C, sumdist] = kmeans(matrizDatos, nClustersOptimo, ...
    "Replicates", 10);

figure(2), clf
% Definimos los colores para cada grupo
colores = {'r', 'g', 'b', 'k'};

% Hacemos una vuelta por cada sujeto, vamos a graficar cada sujeto (que no
% tenga Nan), cada dato de un color diferente sobre el eje de los tres
% componentes principales
nSujetos = size(score, 1);
for n = 1:nSujetos
    h = plot3(score(n,1), score(n,2), score(n,3), 'o');
    hold on
    if isnan(ID(n))
        ID(n) = 4;
    end
    set(h, 'MarkerSize', 10, 'MarkerFaceColor', colores{ID(n)}, ...
        'MarkerEdgeColor', 'none')
end
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')
title('Clasificación de cada sujeto')
axis square

%% Ahora con los datos de Liliana

clear, clcbvgghgdhtkufgsgfddsgjggfgjghfmghf    YO AMO A MI AMOR, MÁS DE LO QUE ÉL ME AMA A MÍ, OBVIO

listaArchivos = dir(['databases\Sanchez_Zepeda_Liliana\*.mat']);

figure(1)

for ar = 1:length(listaArchivos)
    load([listaArchivos(ar).folder '/' listaArchivos(ar).name])

    subplot(411)
    hold on
    plot(trial.rate)
    title('Rate')

    subplot(412)
    hold on
    plot(trial.rateBaseline)
    title('RateBaseLine')

    subplot(413)
    hold on
    plot(trial.totalErr)
    title('totalErr')

    subplot(414)
    hold on
    plot(trial.nRep)
    title('nRep')
end

xlabel('Número de repetición')














