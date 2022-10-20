%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Tarea encargada el día jueves 06 de octubre, 2022            %
%      Análisis de espectograma y poder en datos de Armando Ortega        %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear, clc, clf

% Cargamos los datos usando abfload, con trazos de LFP de bulbo olfatorio.
% LFP es potencial de campo local, donde encontraremos señal de neuronas.
% vemos cambios de potencial de acción lentos alrededor del electrodo. Hay
% 20 minutos de basal, luego hay estímulos cada 10 segundos
[datos, sampleInterval] = abfload('databases/Ortega_Xique_Armando.abf');

% Frecuencia de muestreo en Hz
Fs = 1000;

% Seleccionamos la primera columna de la 
% Aquí tendríamos solamente 1 minuto de registro
senial = datos(1:60*Fs, 1);
% Pero probaremos con todo el registro
senial = datos(:,1);

% Haremos un eje de tiempo para la señal
ejeTiempo = [1:length(senial)]/Fs-1;

% Hacemos nuetsra figura
figure(1)

subplot(323)
% Acá ponemos la señal original
plot(ejeTiempo, senial, xlabel('tiempo (s)'), ylabel('voltaje'))
title('Señal original')

subplot(325)
% Hacemos un eje de frecuencias, en Hz, hasta los 500Hz
frecuencias = 0:1:500;
% La función de periodograma nos regresa el poder, la amplitud del
% recorriendo y las frecuencias. El periodograma es el poder de una señal
% en función de la frecuencia
[poder, Frecs] = periodogram(senial, [], frecuencias, Fs, 'power');
% Ahora se transforma el poder a decibeles porque sino las frecuencias
% bajas tienen tanto poder comparadas con las demás que no veríamos mucho
poder_dB = 10*log10(poder);
plot(Frecs, poder_dB);
% También ponemos los datos de la gráfica para entenderlo mejor
xlabel('Frecuencia Hz');
ylabel('Poder (dB)');
title('Periodograma');

subplot(326)
% Ahora calculamos la amplitud espectral solamente por ventanas y calcula
% el promedio de los periodogramas de cada ventana.
% Aquí declaramos una ventana de 500 elementos, o 0.5 segundos. Los tamaños
% de la ventana y sobrelape varían según lo que necesitamos, si la ventana
% es muy pequeña entonces podríamos no ver la ventana que queríamos.
ventana = 500;
% Necesitamos un factor de emplame, esta cantidad de elementos se
% compartirá entre una ventana y su enterior, entonces irá avanzando
% solamente de 100 en 100 elementos
sobrelape = 400;
% Notaremos que pwelch da un periodograma, también nos regresa el poder y
% las frecuencias pero está mucho más suavizado que el periodograma
[poder, Frecs] = pwelch(senial, ventana, sobrelape, frecuencias, Fs);
Poder = 10 * log10(poder);
plot(Frecs, Poder);
% También ponemos los datos de la gráfica para entenderlo mejor
xlabel('Frecuencia Hz');
ylabel('Poder (dB)');
title('Versión welch del periodograma');

% Hay que notar que pwelch no nos dice en qué momento de la señal está esa
% frecuencia dominante. Necesitamos una transformada de Fourier, haremos un
% espectrograma.

subplot(324)
[~, Frecs, Tiempo, Poder ] = spectrogram(senial, ventana, sobrelape,...
                                frecuencias, Fs, 'yaxis');
% Hacemos nuestra conversión a decibeles, de no hacerla tampoco veríamos
% muy bien el poder de las frecuencias
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

subplot(322)
% Ahora seleccionaremos una banda en función del tiempo, alrededor de los
% 5Hz, 300Hz, 420Hz y 450 Hx
poderBanda5Hz = mean(Poder(1:10, :));
poderBanda300Hz = mean(Poder(298:301, :));
poderBanda420Hz = mean(Poder(418:421, :));
poderBanda450Hz = mean(Poder(448:451, :));

h(1) = plot(Tiempo, poderBanda5Hz);
hold on
h(2) = plot(Tiempo, poderBanda300Hz);
hold on
h(3) = plot(Tiempo, poderBanda420Hz);
hold on
h(4) = plot(Tiempo, poderBanda450Hz);

title('Poder alrededor de diferentes bandas')
xlabel('Tiempo (s)')
ylabel('Poder (dB)')
legend(h, {'5Hz', '300Hz', '420Hz', '450Hz'})