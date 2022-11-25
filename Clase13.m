clear, clc

% Datos de concentración de un sustrato
datos = [...
    0 2
    20 25
    40 35
    60 37
    80 38
    100 42
    120 41
    140 48
    160 52
    180 53];

% Ajuste de modelo matemático a un conjutno de datos
S = 0:200;
Vmax = 20;
Km = 20;        % Concentración a la que se alcanza un medio de Vmax

% Aquí construiremos nuestra figura
figure(1), clf
hold on

% Separamos nuestros datos, entre concentraciones y velocidades de reacción
S_exp = datos(:, 1);
velReacc_exp = datos(:, 2);

% La velocidad que predice el modelo
I(1) = plot(S_exp, velReacc_exp, 'ko', 'MarkerSize', 5, ...
                'MarkerFaceColor', 'k');

% Graficamos el modelo con nuestro ajuste manual
velReacc = michaelisMenten2022(S, Vmax, Km);
plot(S, velReacc, 'b-', 'LineWidth', 3)
title('Cinemática de Michaelis-Menten')
xlabel('Concentración de sustrato [S]')
ylabel('Velocidad de reacción')

% Declaramos la variable independiente que usará el modelo para hacer el
% ajuste, será igual a nuestros datos experimentales
x = S_exp;

% Definimos el modelo que usaremos, citando el nombre de la función que
% definimos en el otro archivo
modelo = fittype('michaelisMenten2022(x, Vmax, Km)');

% También podemos usar la notación de función anónima, con el arroba y así
% no es necesario hacer el archivo de la función aparte
% modelo = fittype( @(Vmax, Km, x) Vmax * x ./ (Km + x));

% Realizamos el ajuste del modelo usando fir, que es un algoritmo de
% optimización
ajuste = fit(x, velReacc_exp, modelo, 'startpoint', [50 20]);

% Obtenemos los parámetros ajustados
Km_ajustada = ajuste.Km;
Vmax_ajustada = ajuste.Vmax;

% Obtenemos la velocidad de la reacción ajustada según los datos del modelo
velReacc_ajustada = michaelisMenten2022(S, Vmax_ajustada, Km_ajustada);
I(2) = plot(S, velReacc_ajustada, 'r-', 'LineWidth', 3);
legend('Ajuste manual', 'Datos experimentales', 'Ajuste optimizado')
% Acá otra forma de poner las leyendas
% legend(I, {'Datos experimentales', 'Ajuste optimizado'})


% Tarea: Elegir una funcipon que tenga al menos 2 parámetros, inventar
% datos y ajustarles dicha función












