clear, clc

% Esta función detecta el tipo de archivo que va a leer
opciones = detectImportOptions("databases\datos01.xls");

% Ahora podemos leer el archivo que queremos importar
tablaDatos = readtable("databases\datos01.xls", opciones);

% Ahora convertimos la tabla a una matriz usando table2array
matrizDatos = table2array(tablaDatos);

% Podemos ver el tamaño de la matriz usando el comando size
% Nos va a dar el tamaño de cada dimensión de la matriz
size(matrizDatos);

% Ahora hay que ver cómo se distribuyen esos datos
% Usamos el operador : para hacer un vector con la matriz, poniendo
% cada columna abajo de la otra, como es un vector, podemos usar histogram
histogram(matrizDatos(:));

% Sacando promedios
% Podemos ver otras métricas relevantes, por ejemplo así sería el promedio
% De cada columna de la matriz, devuelve un arreglo
mean(matrizDatos);           % lo mismo que mean(matrizDatos, 1)
% Acá sería el promedio de cada renglón
mean(matrizDatos(:));
% Podemos sacar el promedio de cada renglón usando como argumento la 
% dimensión de la matriz que queremos promediar
mean(matrizDatos, 2);

% Ahora desviaciones estándar
% Igual sin segundo argumento toma por default la primer dimensión
std(matrizDatos);           % O std(matrizDatos, 1)
% O de todos los datos
std(matrizDatos(:));
% Para sacar por columnas o filas, hay que usar algo así, aquí sacamos la
% desviación estándar de cada fila
std(matrizDatos, [], 2)
% Esto de los corchetes es por un detalle de la estadística, sobre los
% pesos de cada valor

% Vamos a asumir que tenemos 20 variables con 10 datos cada uno
% Extraemos la primer columna (todos los datos : columna 1) y graficamos
columna1 = matrizDatos(:,1);
plot(columna1, '-o');

% Ahora podemos extraer el primer reglón de cada columna
primerRenglon = matrizDatos(1, :);

% También podemos extraer un valor individual, por ejemplo, valor 
% de el tercer renglón y la cuarta columna
matrizDatos(3, 4);

% También podemos encontrar un valor específico utilizando find
% Por ejemplo encontrar la ubicación de cualquier número 68
find(matrizDatos == 68);
% Pero esta función así solamente regresa la posición numerando
% consecutivamente todos los valores de la matriz, da solo un número

% Si queremos las coordeadas debemos de pedirlo así
[x, y] = find(matrizDatos == 68);

% Si evaluamos algo como esto, nos regresará otra matriz del mismo tamaño
% que la original pero con verdaderos y falsos, según se cumpla la prueba
% lógica, esto mismo lo podemos usar en find
matrizDatos > 0;

% Acá estaríamos sacando las coordenadas de valores que sean mayores a 80
[x, y] = find(matrizDatos > 80);

% Podemos obtener mínimos y máximos también usando
max(matrizDatos(:));
min(matrizDatos(:));

% Ahora vamos a graficar todos los datos de la segunda columna
figure(1)
% Podemos usar subplot para dividir una figura en paneles, por ejemplo
% Dos paneles, acomodados en columnas y en el primer panel irá mi primer
% plot
subplot(2, 1, 1)
plot(matrizDatos(:,2), 'o-')

% Ahora agreguemos otra gráfica a ese subplot, podemos ponerle en el
% segundo panel, la siguiente gráfica con los datos de la tercer columna
subplot(2, 1, 2)
plot(matrizDatos(:,3), 'o-')

figure(2), clf
% Esta figura estará divida en 3 páneles, en el primero pondremos el
% siguiente plot
subplot(3,1,2)
plot(matrizDatos(:,4), 'o-')

% De manera general el subplot tiene el formato:
% subplot({{ paneles por renglón }}, {{ paneles por columna }}, {{donde}})
subplot(3, 1, 3)
plot(matrizDatos(:,5), 'o-')

% Tarea: Enviar un histograma de cómo se distribuyen mis datos
% Una de histograma y otra de plot
% Hay que mandar tanto el código como las figuras que salen
% La tarea es para el siguiente jueves

datos2 = randn(4, 50*1000);
figure(5)
subplot(4, 1, 1)
plot(datos2(1, :))

subplot(4, 1, 2)
plot(datos2(2, :))

subplot(4, 1, 3)
plot(datos2(3, :))

subplot(4, 1, 4)
plot(datos2(4, :))
