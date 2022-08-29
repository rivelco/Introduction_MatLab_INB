x = 5;  % escalar
vec1 = [1 2 3 4 5]; % vector fila
vec2 = [1; 2; 3; 4; 5]; % vector columna

% Vector de cantidades aleatorias
randi(3, [4, 1])
randn(2)

% Vectores de un mismo número
ones(1, 5)
zeros(1, 5)
nan(1, 5)

% Secuencias de números
1:10
1:2:10  %inicio step fin
linspace(1, 2*pi, 5); % Desde 1 hasta 2pi con 100 elementos uniformemente distribuidos

% comando open <<var>> abre la variable en el editor
length(vec1); % solamente un valor
size(vec1);   % Tamaño de todaslas dimensiones del vector, recomendado siempre

%Operaciones aritméticas
% + - * / ^
% No olvidar la comilla para transponer
sqrt(vec1)  % Aplica la raíz a cada elemento de la matriz
mod(vec1)
log(vec1)
exp(vec1)
mean(vec1)

% Nota de operaciones
% vec1 * vec2 = 55 -> solamente un valor
% vec1 .* vec2 = arreglo -> todo un arreglo nuevo

% Operadores lógicos
% && -> y
% || -> o
% xor(arg1, arg2)
% ~ -> not
% == < > <= >=

% Indexar
vec1(:,:) % Los dos puntos vacíos cubren todo el rango de esa dimensión
vec1(1, 1:2) % 

% Índices lógicos
idx = logical([1 0 1 0 0]);
vec1(idx)

% Reemplazar un valor
vec1(2) = []

% indexar con condicionales
vec1(isnan(vec1)) = [];

% Unión de vectores
horzcat(vec1, vec2')
vertcat(vec1', vec2)

% Seleccionar elementos de forma intercalada
x = [1, 2, 3, 4, 5, 6]
idx = find(x == 4) % Find da una un vector con las posiciones de la coordenada 4
x(x == 4) = []  % Da un vector lógico de los índices donde los encontró

% Creación de matrices
randi(4, [5, 5])
randn(5, 8)
magic(5)
ones(5, 3)
zeroes(5, 5)
nan(5, 9)
% x(filas, columnas)

% Operaciones con matrices
%   .*  ./  .^   para operaciones elemento por elemento

% Para probar las propiedades del cuadrado mágico
a = magic(5)
a(: , 1)
sum(a)

% Reshape
x = ones(2, 6)
numel(x) % Número de elementos en la matriz x
reshape(x, [3, 4])  % Adapta la matriz vieja a las nuevas medidas
% acomoda de arriba a abajo y de izquierda derecha


% For Loop

x = 1:100;
for jj = 1:100  % Iterador jj desde 1 a 100
    actividad = sin(x) + randn(1, 100);
end

x = 1:100;
actividad = nan(100, 100);
for jj = 1:100  % Iterador jj desde 1 a 100
    actividad(jj,:) = sin(x) + randn(1, 100);
end

% Aquí dice que se pueden anidar las cosas 
% Se puede usar disp("para mostrar") texto

% if else elseif

condicion = x == 10;
if condicion
    disp('se cumplió la cosa')
elseif x == 5
    disp('se cumple otra cosa')
end

% Figuras
%plor
fig = figure(1)
plot(x, mean(actividad1), 'Linewidth', 10)
xlabel('tiempo')
ylabel('spks/s')
xlim([50, 100])
ylim([-2, 2])

% Comando show all properties de las figuras para mostrar todas las cosas
% modificables

% También se revisó subplot
% histogram
% scatter
% bar

% Salvar y cargar
mivariable = 42;
save('miprimeraclase.mat', 'mivariable')

clear all
save('miprimeraclase.mat')

% Se pueden hacer bloques de código con doble porcentaje
% Para correr un bloque puedes usar ctrl + enter
% También se pueden ejecutar diferentes líneas individualmente

% Recomienda empezar cada código con clear, clc

% Para ayuda se puede usar help, doc, keyboard

% Tarea
% 1. Verificar que la suma de 

