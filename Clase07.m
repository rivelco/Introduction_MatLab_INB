clc
clearvars -except tablaDatos

% Cargamos la base de datos con la que trabajaremos
tablaDatos = readtable('databases\Rodríguez_Blanco_Luis Alfredo.xlsx');

% Frecuencia de muestreo (en Hz). Aquí se están registrando 11 cuadros por
% segundo
Fs = 3;
% Calculamos el tiempo total de registro en segundos
tTotal = (2000/Fs);
% Eje de tiempo, uno para los datos y otro para la derivada
ejeTiempoDatos = (1: 1: 2000)/Fs;
ejeTiempoDeriv = (1: 1: 1999)/Fs;

% Acá transformamos la tabla en una matriz
matrizDatos = table2array(tablaDatos);
tamanioMatrizDatos = size(matrizDatos);

figure(1), clf
subplot(411), hold on
primerRenglonDatos = matrizDatos(1, :);
plot(ejeTiempoDatos, primerRenglonDatos)

% Calculamos la primera derivada en la dimensión 2 de la matriz de datos,
% es decir en los renglones
derivadaDatos = diff(matrizDatos, 1, 2);
plot(ejeTiempoDeriv, derivadaDatos(1,:), 'r-')
xlabel('Tiempo (s)')
ylabel('Fluoresencia')

% Ahora queremos hacer un umbral, lo haremos calculando la desviación
% estándar de la derivada de los datos, ya derivados
STDev = std(derivadaDatos, [], 2);
% Le sacamos el promedio a todas las desviaciones estándar
meanSTD = mean(STDev);
% Ahora declaramos un umbral, cuatro veces arriba de la desviación
umbralSTD = mean(meanSTD) * 3;
% Sacamos los límites del dominio en x, lo usaremos para el umbral
limitesX = xlim;

% Graficamos el umbral, una línea recta que no tiene pendiente, que va del
% punto umbralSTD al punto umbralSTD, de color negro (k) y con puntos (:)
plot(limitesX, [umbralSTD umbralSTD], 'k:')
legend({'Fluoresencia', 'dF/dt', 'Umbral'})

subplot(412)
% Ahora graficamos todos los canales simultáneamente, trasponemos la matriz
% para que se grafique cada renglón y no cada columna, porque cada renglón
% es una célula
plot(ejeTiempoDatos, matrizDatos');
xlabel('Tiempo (s)')
ylabel('Fluoresencia')

subplot(413)
% Ahora queremos hacer una gráfica con los datos de la derivada que sean
% mayores al umbral. Es discreta porque solamente tendrá 1 cuando se pase
% el umbral o 0 cuando no lo pase
matrizDiscreta = derivadaDatos > umbralSTD;
% Vamos a declarar una distancia mínima entre picos para quedarnos con los
% puros momentos donde sube
distanciaMinima = 20;
graficar = false;

% Una vuelta por cada renglón de la matriz discreta, por eso la dimensión 1
% de la matriz discreta en size
for i = 1:size(matrizDiscreta, 1)
    % Tomamos cada renglón de la matriz
    datosRenglon = matrizDiscreta(i, :);
    % Acá encontramos los puntos que superan el umbral
    locs = find(datosRenglon);
    % Ahora calculamos la distancia entre todos los valores que superaron
    % el umbral
    pksIntervals = locs(2:end) - locs(1:end-1);
    % Ahora descartamos los valores contiguos (menores a la distancia
    % mínima)
    quitarPks = find(pksIntervals < distanciaMinima) + 1;
    locs(quitarPks) = [];
    tiempoPicos{i} = locs/Fs;
end

[xx, yy] = rasterplot(tiempoPicos, 'quickplot', 'yes');
plot(xx, yy, '.', 'MarkerSize', 5)
ylim([1 size(matrizDiscreta, 1)])
xlabel('Tiempo (s)')
ylabel('Número de neuronas')
title('Rasterplot')

subplot(414)
% Limpiamos el eje, por si estaba ocupado (clear axis), para que no haya
% nada en ese panel 4
cla
tAxis = 0:1:666;
xlabel('Tiempo (s)')
ylabel('Tasa promedio de picos')
peakRate = firingrate(tiempoPicos, tAxis, 'filtertype', 'exponential',...
            'timeconstant', 5);
plot(peakRate'/10), hold on
plot(tAxis, mean(peakRate), 'b-', 'LineWidth', 2)
xlim([0 666]);
title('Promedio de la tasa de picos de las 50 neuronas')

% En la figura 2 hay que sacar el espectro de potencia del panel 4 de la
% figura 1, para saber con qué regularidad (si existe) se activan esas
% neuronas




