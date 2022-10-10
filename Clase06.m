%% Clase 06

clear, clc

% Frecuencia de muestreo, en Hz
Fs = 1000;
% Duración de la señal en segundos
duracion = 5;

% Hacemos nuestro eje de tiempo
ejeTiempo = 0 : 1/Fs: duracion - (1/Fs);

% Declaramos nuestra frecuencia en Hz
frecuencia = 30;

% Ahora haremos nuestra onda, que después inyectaremos a nuestra señal,
% notar aquí que la frecuencia de esta senoidal es de 30 Hz
senoidal = 40 * sin(2*pi * ejeTiempo * frecuencia);

% Hacemos dos señales de muestra
senial1 = randn(1, Fs*duracion);
% La segunda tendrá la suma acumulada, para ejemplo también. Esto hará una
% caminata aleatoria o randomwalk, en el que cada instante de tiempo se
% toma la elección de subir o bajar. Este es un random walk de 1 dimensión.
% De manera práctica, cumsum es una manera de general una señal.
senial2 = cumsum(senial1);

% Aquí le vamos a "inyectar" una senoidal de 30Hz. Notar que solamente
% inyectamos un segundo de la senoidal, da igual qué segundo de ella sea,
% pero que sea solamente uno porque en su totalidad mide 5000
senial2(2001:3000) = senial2(2001:3000) + senoidal(1:1000);

% Una caminata aleatoria tiene una propiedad llamada 1/f, donde a mayor
% frecuencia menor amplitud y a menos frecuencia mayor amplitud, entonces
% el resultado de 1/f es la amplitud

figure(1), clf
% Aquí nuestra prumer gráfica, la señal con un montón de datos aleatorios
subplot(321)
plot(ejeTiempo, senial1, xlabel('tiempo (s)'), ylabel('voltage'))
title('Datos aleatorios para generar señal')

subplot(323)
% Acá ponemos la señal acumulada
plot(ejeTiempo, senial2, xlabel('tiempo (s)'), ylabel('voltage'))
title('Señal simulada usando cumsum')

subplot(325)
% Hacemos un eje de frecuencias, en Hz
frecuencias = 0:1:100;
% La función de periodograma nos regresa el poder, la amplitud del
% recorriendo y las frecuencias. El periodograma es el poder de una señal
% en función de la frecuencia
[poder, Frecs] = periodogram(senial2, [], frecuencias, Fs, 'power');
% Ahora se transforma el poder a decibeles porque sino las frecuencias
% bajas tienen tanto poder comparadas con las demás que no veríamos mucho
poder_dB = 10*log10(poder);

% Al graficar la señal, podremos ver un pico en el poder en la señal a los
% 30 Hz que le pusimos arriba
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
[poder, Frecs] = pwelch(senial2, ventana, sobrelape, frecuencias, Fs);
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
[~, Frecs, Tiempo, Poder ] = spectrogram(senial2, ventana, sobrelape,...
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
% 30Hz
poderBanda30Hz = mean(Poder(25:35, :));
poderBanda5Hz = mean(Poder(65:75, :));

h(1) = plot(Tiempo, poderBanda30Hz);
hold on
h(2) = plot(Tiempo, poderBanda5Hz);

title('Poder en una banda alrededor de 30Hz')
xlabel('Tiempo (s)')
ylabel('Poder alrededor de 30Hz (dB)')
legend(h, {'Poder en 30Hz', 'Poder en 75 Hz'})

%% Análisis de datos de Armando Ortega
% Ahora usaremos un ejemplo real con datos reales
clear, clc

% Cargamos los datos usando abfload, con trazos de LFP de bulvo olfatorio.
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

figure(2)
plot(ejeTiempo, senial);

% Tarea, generar la figura 1 con los datos reales de Armando. Ver poder
% alrededor de los 5Hz, jugar con los parámetros. Tiene filtro de 0.3 a 300
% Hz





