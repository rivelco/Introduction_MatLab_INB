% Suma de senoidales

clear, clc       % Limpiamos variables
tTotal = 1;      % Segundos
Fs = 1000;       % Hz
tAxis = 0: 1/Fs : tTotal;       % Es nuestro eje x

frecs = [3 11 27];      % Frecuencias de las senoidales
amps = [10 4 8];        % Amplitud
fase = [0 pi/3 pi/5];

% Una vuelta por cada senoidal
for n = 1:length(frecs)
    senoidales(n,:) = amps(n)*sin(2*pi*tAxis*frecs(n)+fase(n));
end

% Aquí graficamos solamente las senoidales individualmente
subplot(2, 1, 1)
plot(tAxis, senoidales, 'LineWidth', 3);
title('Senoidales puras')
xlabel('tiempo (s)')
ylabel('amplitud')

% Graficamos la suma de las senoidales en el otro panel
subplot(2, 1, 2)
% Se hace la suma solamente las columnas
sumaSenoidales = sum(senoidales, 1); 
% Graficamos esa nueva suma ahora
plot(tAxis, sumaSenoidales, 'LineWidth', 3)
title('suma de senoidales')
xlabel('tiempo (s)')

%% Transformada de Fourier

% La transformada de Fourier permite descomponer cualquier señal en una
% suma de curvas senoidales

% Declaración de un número complejo
% Podemos pensar en los números complejos como las coordenadas en el plano
% de los complejos, en el caso del siguiente número tendríamos un punto con
% la coordenada 3 en los reales y la coordenada 4 en los imaginarios
b = 3 + 4i;

% Podemos obtener la maginitud del vector resultante sacando el valor
% absoluto del número complejo. Podemos pensar en la magnitud como la
% distancia que hay desde el 0 y hasta el punto marcado por las
% coordenadas, veremos que para este ejemplo la magnitud es 5, igual lo
% podríamos sacar con teorema de Pitágoras
magnitud = abs(b);

% Podemos obtener el ángulo del vector que se forma usando la función
% angle. Hay que tener en cuenta que el valor que nos da estará en
% radianes, pero lo podemos convertir a decimales multiplicando por 180/pi
angulo = angle(b);

% Podemos hacer una línea vertical o ángulo de 90 grados si hacemos
% cualquier número complejo con valor 0 en los reales y cualquier número en
% los imaginarios
c = 0 + 2i;

%% Ahora un ejemplo con una señal random

clear, clc

% Tenemos una señal original, en función del tiempo
%senial = [0 -1 -2 -3 0 -1 -2 -3];      % Serie original
senial = randi(19, 1,  10);

% Pasamos a una función transformada con el Fast Fourier Transform, que
% ahora está en función de la frecuencia. Tendremos números complejos
% La posición de los números en la senialFFT indica la frecuencia, por lo
% que al final reconstruiremos ondas senoidales con frecuencia desde 0 y
% hasta N
senialFFT = fft(senial);        % Serie transformada

% Ahora vamos a reconstruir la señal original

N = length(senial);
% Con el siguiente 2*pi/N nos aseguramos que tendremos N elementos en el
% eje
tAxisOrig = 0: 2*pi/N : 2*pi;
% Ahora otra serie de tiempo pero con más puntos
tAxisCos = 0 : 2*pi/100 : 2*pi;

% Haremos ahora una vuelta por cada frecuencia (por cada número complejo)
for f = 1:N
    Frecuencia = f-1; % Frecuencia de la senoidal
    % Dividimos entre N para tenerlo normalizado
    Amplitud    = abs(senialFFT(f)) / N;
    Fase        = angle(senialFFT(f));
    senoidales(f, :)    = Amplitud*cos(tAxisOrig * Frecuencia + Fase);
    senoidalesCos(f, :) = Amplitud*cos(tAxisCos * Frecuencia + Fase);
end

figure(2), clf
subplot(211)
plot(tAxisCos, senoidalesCos, 'LineWidth', 3);
title('Senoidales que resultan de la FFT')

% Ahora confirmaremos que si sumamos todas las senoidales obtendremos la
% señal original
subplot(212)
sumaSenoidales = sum(senoidalesCos);
plot(tAxisCos, sumaSenoidales, 'LineWidth',3);
% Ahora empalmaremos la siguiente gráfica
hold on
% La graficaremos con bolitas rojas, rellenas de color rojo. Haay que notar
% que se usa el rango del eje (1:end-1) para que también tenga 6 elementos,
% porque sino tiene 7 porque éste está indexado en 0 (empieza en 0)
plot(tAxisOrig(1:end-1), senial, 'ro', 'MarkerFaceColor','r', 'MarkerSize',15)

% Podremos notal, que al graficar la señal original (los puntos de la señal
% original que estaban en función del tiempo) sobre la suma de las
% senoidales podremos ver que los puntos de la señal original caen sobre la
% suma de las senoidales, por lo que la señal nueva en efecto estaría
% cubriendo los puntos que nosotros marcamos

% Ahora vamos a imprimir en la consola el valor de cada una de las series,
% lado a lado, tanto de la señal original como de la reconstruida por la
% serie de Fourier, veremos que son exactamente iguales.
senialReconstruida = sum(senoidales(:, 1:end-1))
[senial', senialReconstruida']

%% Tarea 4
% Leer y ejecutar todos los ejercicios de las funciones siguientes
% boxplot(), anovan(), kruskalwallis()

%% Ahora vamos a hacer una práctica con una base de datos

clear, clc

% En d están los datos de voltaje en el tiempo y si es el SampleInterval
[d si] = abfload('databases/Ortega_Xique_Armando.abf');

figure(1)
plot(d(:, 1))