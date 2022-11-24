clear, clc

f1 = randn(1, 1000);
f2 = cumsum(f1);

figure(1)
subplot(311)
plot(f2)
title('Señal (random walk)')

% Este kernel nos servirá para suavizar, promediando 100 elementos para
% generar cada punto de la nueva serie senialConv
kernel = ones(1,100);
% Aquí normalizamos el kernel
kernel = kernel/sum(kernel);

% Este será un kernel Gausiano, le da más peso a los valores cercanos a la
% mitad del kernel y menos a los otros valores que están más lejos. La
% desviación estandar de esta distribución se interpretará como la cantidad
% de elementos que importan o que se están promediando alrededor del centro
% del kernel, en este caso es 20
kernel = normpdf(-50:50, 0, 20);

% Aquí funciona como un filtro pasabajo
senialConv = conv(f2, kernel, 'same');

subplot(312)
plot(f2, 'b-')
hold on, axis tight
plot(senialConv, 'r-'), axis tight

subplot(313)
plot(f2-senialConv, 'k-')
title('Frecuencias altas')

figure(2)
plot(kernel)

%% Ahora con imágenes

clear, clc

% La imagen será importada como un arreglo tridimensional con los valores
% y ubicación de cada pixel que la conforma
imagen = imread('auxFiles\BanderaNacional.jpg');

% Necesitamos usar un formato de números de doble precisión, ahorita cada
% pixel tiene un conjunto de tres valores numéricos de 8 bits sin signo
imagen = double(imagen);

figure(1)
subplot(141)
% Para mostrarla hay que usar la imagen en 8 bits, por eso regresamos a 8
% bits sin signo acá
imagesc(uint8(imagen))

% Haremos un kernel de 30 x 30 pixeles, y lo normalizamos
kernel = ones(50, 50)/2500;

imagenConv = convn(imagen, kernel, 'same');
subplot(142)
image(uint8(imagenConv))
title('Imagen pasa bajas')

subplot(143)
% Con este filtro podemos identificar los bordes de los objetos, porque es
% donde hay más contraste (mayor diferencia de la imagen original con
% respecto a la convolución)
imagenPasaAltas = imagen - imagenConv;
image(uint8(imagenPasaAltas)*2)
title('Imagen pasa altas')


subplot(144)
% Primero centramos la imagen en 0 restando la mitad del máximo de
% lumninacia (el -128) luego multiplicamos por 3 para hacer más marcadas
% las diferencias entre los valores, luego sumamos 138 de nuevo para
% regresarlo a su luminancia original
imagenContrastada = (imagen - 128) * 3 + 128;
image(uint8(imagenContrastada))
title('Imagen pasa altas')

% Aquí sacamos la intensidad del color rojo de la imagen
R = imagen(:,:,1);
G = imagen(:,:,2);
B = imagen(:,:,3);
% Podríamos graficar las intensidades de los colores
% figure(2)
% surf(B, 'EdgeColor','none')
% colormap("hot")

figure(2)
subplot(231)
image(uint8(imagen))

% Aquí hacemos una imagen en escala de grises, sacando los promedios de
% todas las intensidades de todos los colores, en cada dimensión
imagenBW(:,:,1) = mean(imagen, 3);
imagenBW(:,:,2) = mean(imagen, 3);
imagenBW(:,:,3) = mean(imagen, 3);
subplot(232)
image(uint8(imagenBW))

% Ahora hacemos una imagen binaria, usando un criterio de corte o umbral,
% el valor a partir del cual un pixel será negro y otro será blanco, usando
% como base la imagen en escalas de grises
subplot(233)
umbralCorte = 128;
imagenBinaria = (imagenBW > umbralCorte)*255;
image(uint8(imagenBinaria))


% Ahora haremos un detector de color rojo
subplot(234)
imagenR = imagen;
imagenR(:, :, 1) = imagen(:, :, 1) - imagen(:, :, 2) - imagen(:, :, 3);
imagenR(:, :, 2) = 0;
imagenR(:, :, 3) = 0;
image(imagenR)

subplot(235)
imagen = (imagen - 128) * 1.5 + 128;
imagenG = imagen;
imagenG(:, :, 1) = 0;
imagenG(:, :, 2) = imagen(:, :, 2) - imagen(:, :, 1) - imagen(:, :, 3);
imagenG(:, :, 3) = 0;
image(imagenG)

subplot(236)
imagenG = imagen;
imagenG(:, :, 1) = 0;
imagenG(:, :, 2) = 0;
imagenG(:, :, 3) = imagen(:, :, 3) - imagen(:, :, 1) - imagen(:, :, 2);
image(imagenG)




% Hay que replicar los análisis en una imagen que escojamos y cambiar los
% valores cuando se pueda, cambiar los parámetros y contraste y umbrales



