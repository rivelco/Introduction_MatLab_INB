clear, clc

m = 3;
b = -1;
x = [0 1 2 3 4 5];

% Esta es una clásica función de la recta, cada entrada da una salida y
% esto siempre es consistente
y = m*x +b;
plot(y, 'o-')
% El resultado es un vector, un vector puede tener el resultado de una
% función.

% Ahora haremos otras funciones, cada una estará representada por un
% arreglo, cada vector representa los valores de salida de esa función que
% representa.
f1 = [1 2 5];
f2 = [3 1 4 7];

% Ahora haremos la función convolución, usando la función de MatLab
f3 = conv(f1, f2);

% De manera manual se vería como:
% f1: [1 2 5]
% Primero vamos a voltear los valores de la primer función
% f1: [5 2 1]
% f2:     [3 1 4 7]
convolucionAMano(1) = 3; % De (1*3)
% f1: [5 2 1]
% f2:   [3 1 4 7]
convolucionAMano(2) = 7; % De (2*3)+(1*1)
% f1:   [5 2 1]
% f2:   [3 1 4 7]
convolucionAMano(3) = 21; % De (5*3)+(2*1)+(1*4)
% f1:   [5 2 1]
% f2: [3 1 4 7]
convolucionAMano(4) = 20; % De (5*1)+(2*4)+(1*7)
% f1:     [5 2 1]
% f2: [3 1 4 7]
convolucionAMano(5) = 34; % De (5*4)+(2*7)
% f1:       [5 2 1]
% f2: [3 1 4 7]
convolucionAMano(6) = 35; % De (5*7)

% Ahora podemos ver que ambas cosas son iguales
disp(f3)                % La de Matlab
disp(convolucionAMano)  % La que se hizo a mano


% Ahora haremos una figura
figure(1), clf
% Ahora un ejemplo, hacemos una función sencilla que tiene muchos ceros
% en la mayoría de los lugares y a mano le ponemos algunos unos
x = 1:100;
f1 = zeros(100, 1);
f1(20) = 1;
f1(49) = 1;
f1(52) = 1;
f1(70:91) = 1;
subplot(311)
stem(x, f1, 'LineWidth', 2)
axis([0 100 0 1])
title('f1')
ylabel('f1(x)')
xlabel('x')

% Ahora hacemos otra serie de datos, una que parece como una gausiana
subplot(312), hold on
% A la siguiente se le llamaría Kernel Gausiano
f2 = [.01 0.05 .1 .2 .5 .6 .5 .2 .05 .01];
% El siguiente es un kernel exponencial
% f2 = [0 0 0 0 0 .9 .5 .2 .1 .05 .01 .0001 0 0 0 0 0];
% Ahora una más random
% f2 = [10 9 8 1 0 -20 0 1 8 9 10];
% Ahora una moving average o running mean
% f2 = [0 0 1 1 1 1 1 1 1 0 0]/7;
% Con esto podemos normalizar el kernel
f2 = f2/sum(f2);
x2 = 1:length(f2);
stem(x2, f2, 'LineWidth',2)
xlim([0 100])
plot(x2, f2, 'r-', 'LineWidth', 3)
title('f2')
ylabel('f2(x2)')
xlabel('x2')

% Por último la convolución de la primera con la segunda
subplot(313)
f3 = conv(f1, f2);
stem(f3, 'LineWidth', 2)
title('conv(f1, f2) f1(o)f2')
ylabel('f1(o)f2')
xlabel('x')
axis tight











