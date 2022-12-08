%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Tarea encargada el día jueves 24 de noviembre, 2022            %
%      Ajuste exponencial para la señal de transitorios de calcio         %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc

% Aquí cargo los datos, que son las intensidades normalizadas del promedio
% de los transitorios de calcio de una neurona. Este archivo contiene esas
% intensidades registradas en 200 cuadros. Además, ya está la información
% acomodada de tal manera que en la mitad de la ventana (cuadro 100) se
% encuentra el pico del transitorio, por lo tanto se abarcan 100 cuadros
% antes y después de ese pico.
load('FFoStack.mat')

% Declaro mi frecuencia de muestreo
Fs = 4;

% Lo que hice acá es un ajuste exponencial, de manera que pueda dividir
% modelar la subida del transitorio y la bajada del transitorio de manera
% sencilla. Hay que notar que utilicé un ajuste de doble exponencial, esto
% lo hago así porque de esta manera se ajustan mejor los datos del modelo a
% la línea base, aunque hay que tener en cuenta que más abajo restrinjo los
% límites de cada parámetro
modelo = fittype(@(a, b, c, d, x) a*exp(b*x)+c*exp(d*x));

% Voy a hacer un ajuste para la subida del transitorio y otro para la
% bajada, esto lo hago así para poder calcular la tau de subida y de bajada
% del transitorio de cada parte por separado tratando de tener el mejor
% ajuste posible

% Aquí especifico el método con el que quiero hacer la optimización.
optsUp = fitoptions( 'Method', 'NonlinearLeastSquares' );
optsDown = fitoptions( 'Method', 'NonlinearLeastSquares' );

% Ahora defino los límites en los que quiero que se busque la optimización,
% estos límites los pongo acá porque son los que me han permitido tener una
% mejor ajuste en transitorios como este. Notar que restrinjo la variable d
% a 0, para que el ajuste a la línea base sea lo más horizontal posible,
% sino subiría.
optsUp.Lower = [-10e-09 0   0   0];
optsUp.Upper = [2e-08   0.3 0.2 0];

% Ahora defino los límites para la bajada.
optsDown.Lower = [18    -0.1    0 0];
optsDown.Upper = [30    0       1 0];

% Separo mis datos y ejes, entre la subida (la primera mitad de los datos)
% y la bajada (la segunda mitad
xUp = 1:101;
yUp = cellStack(xUp);
xDown = 101:200;
yDown = cellStack(xDown);

% Para cada ajuste hago un "prepareCurveData" para asegurarme que los datos
% tienen la estructura y dimensionalidad correcta para el modelo.
% Posteriormente hago el ajuste y extraigo las variables del modelo como
% tal y la variable de bondad de ajuste.
[xData, yData] = prepareCurveData( xUp, yUp );
[fitUp, gofUp] = fit(xData, yData, modelo, optsUp);
[xData, yData] = prepareCurveData( xDown, yDown );
[fitDown, gofDown] = fit(xData, yData, modelo, optsDown);

% Ahora preparo mi figura
figure(1), clf
hold on
% Primero la subida del transitorio, producto de la función ajustada en
% función del eje x
a = fitUp(xUp);
% La normalizo acá para fines visuales
a2 = a/max(a);
% Hago lo mismo para la bajada, pero con el modelo y datos de la bajada
b = fitDown(xDown);
b2 = b/max(b);

% Puedo mostrar qué tan bueno fue el ajuste usando la rsquared de la bondad
% de ajuste
rsquareUp = gofUp.rsquare; 
rsquareDown = gofDown.rsquare; 
disp("R^2 del modelo para la subida: " + rsquareUp)
disp("R^2 del modelo para la bajada: " + rsquareDown)

% También puedo calcular la tau de subida y bajada de la señal como sigue
tauDown = ((1/(-fitDown.b))*(1/Fs))*1000;
tauUp = ((1/(fitUp.b))*(1/Fs))*1000;
disp("tau de subida (s): " + tauUp)
disp("tau de bajada (s): " + tauDown)

% Ahora grafico el modelo y los datos

% Primero los datos experimentales, del transitorio como tal, lo pongo
% como puntos para que se aprecie mejor el modelo ajustado
plot(1:max(xDown), cellStack, '.', 'Color', 'black', ...
    'MarkerFaceColor','black')
% Ahora sí hago las gráficas del modelo, primero la subida ajustada
plot(xUp, a2, 'LineWidth', 2, 'Color', 'red')
% Luego la bajada también con el modelo
plot(xDown, b2, 'LineWidth', 2, 'Color', 'blue')
% Ahora marco con una línea vertical el punto donde se encuentra el pico
% del transitorio, esto es en el cuadro 100
xline(100, 'LineWidth', 2, 'Color', 'green')
% Agrego las etiquetas de lo que acabo de lo que grafiqué
legend("Datos experimentales", "Ajuste de subida", "Ajuste de bajada", ...
    "Pico del transitorio")
xlabel("Fotograma")
ylabel("Señal de calcio normalizada")
title("Modelo exponencial de un transitorio de calcio")

