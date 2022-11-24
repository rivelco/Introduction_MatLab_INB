%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Tarea encargada el día jueves 13 de octubre, 2022            %
%      Análisis de espectograma del promedio de frecuencias en datos      %
%                  del compañero Luis Alfredo Rodríguez                   %
%                    Por: Ricardo Velázquez Contreras                     %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clearvars -except tablaDatos

%% Cargamos la base de datos
% Cargamos la base de datos con la que trabajaremos
tablaDatos = readtable('databases\Rodríguez_Blanco_Luis Alfredo.xlsx');
% Acá transformamos la tabla en una matriz
matrizDatos = table2array(tablaDatos);
% Tamaño de matriz de datos
[celulas, cuadros] = size(matrizDatos);

%% Comenzamos con el tratamiento de la señal
% Frecuencia de muestreo (en Hz). Aquí se están registrando 3 cuadros por
% segundo
Fs = 3;
% Eje de tiempo para los datos
ejeTiempoDatos = (1: 1: cuadros)/Fs;

% Calculamos la primera derivada en la dimensión 2 de la matriz de datos,
% es decir en los renglones
derivadaDatos = diff(matrizDatos, 1, 2);

% Ahora queremos hacer un umbral, lo haremos calculando la desviación
% estándar de la derivada de los datos, ya derivados
STDev = std(derivadaDatos, [], 2);
% Le sacamos el promedio a todas las desviaciones estándar
meanSTD = mean(STDev);
% Ahora declaramos un umbral, cuatro veces arriba de la desviación
umbralSTD = mean(meanSTD) * 4;

figure(1)
subplot(511)
% Ahora graficamos todos los canales simultáneamente, trasponemos la matriz
% para que se grafique cada renglón y no cada columna, porque cada renglón
% es una célula
plot(ejeTiempoDatos, matrizDatos');
xlim([0 round(cuadros/Fs)])
xlabel('Tiempo (s)')
ylabel('Fluoresencia')
title("FFo de todas las células registradas")

% Ahora queremos hacer una gráfica con los datos de la derivada que sean
% mayores al umbral. Es discreta porque solamente tendrá 1 cuando se pase
% el umbral o 0 cuando no lo pase
matrizDiscreta = derivadaDatos > umbralSTD;
% Vamos a declarar una distancia mínima entre picos para quedarnos con los
% puros momentos donde sube
distanciaMinima = 20;

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

subplot(512)
% Declaramos nuestro eje temporal, donde vamos desde 0 y hasta el tiempo
% total de registro, por eso dividimos la cantidad de cuadros entre la
% frecuencia de muestreo
tAxis = 0:1/Fs:round(cuadros/Fs);
% Ahora calculamos la frecuencia de disparos utilizando la función
% firingrate
peakRate = firingrate(tiempoPicos, tAxis, 'filtertype', 'exponential',...
            'timeconstant', 5);
% Graficamos todas las frecuencias de disparo de todas las células para
% mejor visibilidad de resultados. Se hace una división entre 10 para que
% queden a una altura comparable con la frecuencia promedio
plot(tAxis, peakRate'/10, 'HandleVisibility','off'), hold on
% Ahora calculamos el promedio de las frecuencias de todas las células y
% posteriormente la graficamos
meanPeakRate = mean(peakRate);
plot(tAxis, meanPeakRate, 'b-', 'LineWidth', 2)
% Delimitamos el dominio de la gráfica para que entre completa en la figura
xlim([0 round(cuadros/Fs)]);
% Ponemos las respectivas etiquetas para
xlabel('Tiempo (s)')
ylabel('Tasa promedio de picos')
legend('Promedio de la frecuencia de picos')
title('Promedio de la tasa de picos de todas las neuronas')

%% Análisis de frecuencias

subplot(513)
% Hacemos un eje de frecuencias, en Hz, hasta los 4Hz, hay que recordar
% además que nuestra frecuencia de muestreo es 3Hz.
frecuencias = 0:0.001:4;
% Ahora calculamos la amplitud espectral solamente por ventanas y calcula
% el promedio de los periodogramas de cada ventana.
ventana = 50;
% Necesitamos un factor de emplame, esta cantidad de elementos se
% compartirá entre una ventana y su anterior.
sobrelape = 40;
% Ahora usamos la función del periodograma para obtener las frecuencias y
% el poder de cada una. Posteriormente llevamos el poder a dB y graficamos.
[poder, Frecs] = periodogram(meanPeakRate, [], frecuencias, Fs, 'power');
poder_db = 10 * log10(poder);
plot(Frecs, poder_db);
% También ponemos los datos de la gráfica para entenderlo mejor
xlabel('Frecuencia Hz');
ylabel('Poder (dB)');
title('Periodograma de la freuencia promedio de respuesta');

subplot(514)
% Ahora hacemos el periodograma de Welch para obtener la información con el
% suavizado. Convertimos el poder a dB y graficamos
[poder, Frecs] = pwelch(meanPeakRate, ventana, sobrelape, frecuencias, Fs);
poder_db = 10 * log10(poder);
plot(Frecs, poder_db);
% También ponemos los datos de la gráfica para entenderlo mejor
xlabel('Frecuencia Hz');
ylabel('Poder (dB)');
title('Versión Welch del periodograma hasta 4Hz');

subplot(515)
% Hacemos un eje de frecuencias, en Hz, hasta los 100Hz solo para mostrar
% la naturaleza cíclica de el periodograma con esta señal y parámetros
frecuencias = 0:1:100;
[poder, Frecs] = pwelch(meanPeakRate, ventana, sobrelape, frecuencias, Fs);
poder_db = 10 * log10(poder);
plot(Frecs, poder_db);
% También ponemos los datos de la gráfica para entenderlo mejor
xlabel('Frecuencia Hz');
ylabel('Poder (dB)');
title('Versión welch del periodograma hasta 100Hz');

figure(2)
% Defino un nuevo rango de frecuencias
frecuencias = 0:0.001:3;
% Ahora hacemos el espectrograma para ver el poder y las frecuencias a lo
% largo del tiempo y convertimos el poder a dB
[~, Frecs, Tiempo, Poder ] = spectrogram(meanPeakRate, ventana, ...
                                sobrelape, frecuencias, Fs, 'yaxis');
Poder = 10*log10(Poder);
% Aquí vamos a graficar lo del espectrograma, con esto podremos notar tanto
% tiempo, como frecuencias como poder de la señal. Lo graficamos con una
% función de "surf" o superficie porque es en 3 dimensiones
surf(Tiempo, Frecs, Poder, 'EdgeColor','none')
view(0, 90)
% Le ponemos su información para que se entienda bien
title('Espectrograma')
xlabel('Tiempo (s)')
ylabel('Frecuencias ')
zlabel('Poder dB')

%% Resultados
% Podremos notar que el periodograma nmuestra un poder superior en las
% frecuencias cercanas a 0 y a 3, posteriormente este resultado se repite
% cada 3Hz. Hay que tener en cuenta que la frecuencia de muestreo es de 3Hz
% por lo que será difícil ver frecuencias mayores siendo dominantes. Esta
% naturaleza cíclica del poder para las frecuencias se ejemplifica bien en
% el último panel de la figura.
% Con el espectrograma podemos ver las diferencias del poder en cada
% frecuencia a lo largo del tiempo, donde notamos que todo el registro
% tienen mayor poder las frecuencias de cercanas a 3Hz y 0Hz. No grafico el
% periodograma en más frecuencias porque el resultado es repetitivo como ya
% describía arriba.

% EOF