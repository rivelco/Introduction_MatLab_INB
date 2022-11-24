%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Tarea encargada el día lunes 10 de noviembre, 2022             %
%    Hacer manipulación de imágenes con contrastes y selección de color   %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc

% La imagen será importada como un arreglo tridimensional con los valores
% y ubicación de cada pixel que la conforma
imagen = imread('auxFiles\GeometricShapes.png');

% Necesitamos usar un formato de números de doble precisión, justo ahora
% cada pixel tiene un conjunto de tres valores numéricos de 8bits sin signo
imagen = double(imagen);

figure(1)
subplot(221)
% Para mostrarla hay que usar la imagen en 8 bits, por eso regresamos a 8
% bits sin signo acá
imagesc(uint8(imagen))
title('Imagen original')

% Haremos un kernel de 80 x 1 pixeles, y lo normalizamos, al no ser una
% matriz, sino solamente tener una columna, la imágen será al aplicar la
% convolución solamente se afectará al eje vertical de la imágen y no al
% horizontal, esto se notará porque el marco negro de los costads seguirá 
% estando bien definido, mientras que el inferior no
kernel = ones(80, 1)/80;

% Aquí aplicamos la convolución
imagenConv = convn(imagen, kernel, 'same');
subplot(222)
image(uint8(imagenConv))
title('Imagen borrosa eje vertical')

subplot(223)
% Con este filtro podemos identificar los bordes de los objetos, porque es
% donde hay más contraste (mayor diferencia de la imagen original con
% respecto a la convolución). Hay que notar que como el kernel es una
% columna nada más, no se "detectarán" los bordes del eje horizontal,
% solamente el vertical
imagenPasaAltas = imagen - imagenConv;
image(uint8(imagenPasaAltas)*5)
title('Imagen pasa altas (borde)')

subplot(224)
% Ahora centramos la imagen en 0 restando la mitad del máximo de
% lumninacia (el -128) luego multiplicamos por 2.5 para hacer más marcadas
% las diferencias entre los valores, luego sumamos 128 de nuevo para
% regresarlo a su luminancia original
imagenContrastada = (imagen - 128) * 2.5 + 64;
image(uint8(imagenContrastada))
title('Imagen contrastada')

figure(2)
% Mostramos la imagen original para hacer las comparaciones más fácilmente
subplot(231)
image(uint8(imagen))
title('Imagen original')

% Aquí hacemos una imagen en escala de grises, sacando los promedios de
% todas las intensidades de todos los colores, en cada dimensión, además le
% damos más contraste para mayor efecto dramático
subplot(232)
imagenBW(:,:,1) = mean(imagen, 3);
imagenBW(:,:,2) = mean(imagen, 3);
imagenBW(:,:,3) = mean(imagen, 3);
imagenBW = (imagenBW - 128) * 4 + 128;
image(uint8(imagenBW))
title('Imagen en blanco y negro con contraste')

% Ahora hacemos una imagen binaria, usando un criterio de corte o umbral,
% el valor a partir del cual un pixel será negro y otro será blanco, usando
% como base la imagen en escalas de grises. El umbral lo establezco como la
% mediana de los datos, para variar un poco
subplot(233)
umbralCorte = median(imagenBW);
imagenBinaria = (imagenBW > umbralCorte)*255;
image(uint8(imagenBinaria))
title('Imagen binaria')

% Ahora haremos un detector de color rojo, solamente seleccionamos una
% pequeña porción, que sea lo más concentrado de rojo
subplot(234)
imagenR = (imagen - 128) * 0.6 + 128;
imagenR(:, :, 1) = imagenR(:, :, 1) - imagenR(:, :, 2) - imagenR(:, :, 3);
imagenR(:, :, 2) = 0;
imagenR(:, :, 3) = 0;
image(imagenR)
title('Selección de color rojo')

% Para el color verde seleccionamos muchas cosas cercanas al verde,
% abarcando también al amarillo
subplot(235)
imagenG = (imagen - 128) * 6 + 128;
imagenG(:, :, 2) = imagenG(:, :, 2) - imagenG(:, :, 1) - imagenG(:, :, 3);
imagenG(:, :, 1) = 0;
imagenG(:, :, 3) = 0;
image(imagenG)
title('Selección de color verde')

% Para el color azul tomamos uno más intermedio
subplot(236)
imagenB = (imagen - 128) * 2 + 128;
imagenB(:, :, 3) = imagenB(:, :, 3) - imagenB(:, :, 1) - imagenB(:, :, 2);
imagenB(:, :, 1) = 0;
imagenB(:, :, 2) = 0;
image(imagenB)
title('Selección de color azul')


% EOF
