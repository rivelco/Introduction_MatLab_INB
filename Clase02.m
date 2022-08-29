clear, clc

%datos = readtable("databases\DB01.txt", 'ReadVariableNames', false)

datos = [1 1 2 3 5 8 13 21];

mean(datos)         % Media del arreglo datos
std(datos)          % Desviación estándar de los datos
var(datos)          % Varianza de los datos
median(datos)       % Media de los datos

x = 1:8;            % Rango que funcionará como nuestro eje x
figure(1)           % Marcamos que empezamos la primera figura
plot(x, datos,'-o') % Se grafica el arreglo datos con bolitas en los puntos graficados

xlabel('Números Fibonacci') % Título del eje x
ylabel('Valor')             % Título del eje y
title('Gráfica de ejemplo') % Título de la gráfica

% randn -> Genera números aleatorios de una distribución normal,
% desviación 1 y promedio 0

datos2 = randn(10000, 1);
mean(datos2)
std(datos2)

% Lo mejor es primero ver la distibución de los datos

figure(2)                           % Marcamos que es la segunda figura
histogram(datos2)                   % Generamos un histograma de los datos
xlabel('Valor de la variable')      % Le ponemos nombre a sus ejes
ylabel('Frecuencia')                % Igual al otro eje
title('Histograma de randn')        % También su título

figure(3)                           % Hacemos una tercera figura
datos3 = rand(10, 1);               % rand hace distribuciones homogéneas
histogram(datos3)                   % Vemos que todos tienen una frecuencia similar

mean(datos3)                        % Al límite tiene un promedio de 1/2

figure(4)                           % Una cuarta figura
plot(datos3, '-o')                  % Sin eje y igual grafica los datos
% En este caso tendrán un rango al límite de 1 y 0
% En x se enumera el número de datos graficados

figure(5)                           % Una quinta figura
datos2 = datos2 + 10;               % Para una media centrada en 10
histogram(datos2)                   % Aquí se ve
datos2 = datos2 * 10;               % Así hacemos que tenga desviación 10
histogram(datos2)                   % Acá lo vemos

% Ahora vamos con una gráfica en 3 dimensiones
datos4 = randn(1000, 3);            % Matriz de 1000 x 3 (tres columnas)
figure(6)                           % Sexta figura
x = datos4(:,1);                    % Aislamos la primera dimensión
y = datos4(:,2);                    % Aislamos la segunda dimensión
z = datos4(:,3);                    % Aislamos la tercera dimensión
plot3(x, y, z, 'o')                 % Graficamos los datos usando bolitas

% Vamos con otro ejemplo
datos5 = randn(100, 100)            % Coordenadas nuevas
imagesc(datos5)                     % Interpretamos los datos como una imagen
colorbar                            % Para que se muestre la barra de color
% Aparece como un heatmap donde el color refleja el dato

surf(datos5)                        % En tres dimensiones
colormap('gray')                    % Para mostrarla en escala de grises
colorbar

% Lo primero que hay que hacer con un conjunto de datos es graficarlos
% para poder ver la distribución y la naturaleza de los datos
% "El primer paso que hay que hacer con los datos es verlos" VDLF, 2022


% Notas de MatLab y matemáticas
% 10 / 0; % MatLab lo marca como infinito
% 0 / 0;  % Lo marca como nan, "Not A Number"

% Cosas sobre operadores lógicos
% and(1, 1) == 1  Evalúa si ambos son verdaderos
% or(1, 0) == 1   Evalúa si cualquiera es verdadero
% xor(1, 1) == 0  Evalúa si solo uno es verdadero
% Recordar que 1 es verdadero y 0 es falso

% Sobre el módulo
% mod(10, 2) == 0  El residuo de aplicar 10/2
% mod(10, 3) == 1  El residuo de hacer 10/3

% Fin de la clase del lunes 29 de agosto, 2022
