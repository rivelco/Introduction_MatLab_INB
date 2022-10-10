% Clase 3 para datos experimentales

% Limpiamos las variables y la consola respectivamente
clear, clc

% Primero declaramos el número de datos a usar
Ndatos = 10;

% Generamos datos aleatorios, enteros y hasta el 100, hacemos cinco
% columnas con 10 filas cada una
% Primero usaremos un generador de números aleatorios con rng
rng(59)     % Esta es la semilla del generador de los números aleatorios
% Vamos a generar datos aleatorios que diremos que serán de peso, para que
% los datos tengan sentido y un promedio de alrededor de 70, le sumamos 20
datos = randi(100, Ndatos, 5) + 20;

% Ahora obtenemos el promedio paa cada fila, y su desviación estándar
promedio = mean(datos);
desvEst = std(datos);

% Calculamos el error estándar de la media (SEM), que equivale a la
% desviación estándar entre la raíz cuadrada de la cantidad de datos
stderr = desvEst/sqrt(Ndatos);

% Limpiamos cualquier figura que esté por ahí
clf

% Ahora hacemos una gráfica, le ponemos el 'hold on' porque queremos que se
% conserve el dibujo de los errores que agregaremos después
bar(promedio), hold on
xlabel("Grupo experimental")    % Agregamos título a los ejes
ylabel("Promedio por grupo (Kg)")          

% Ahora agregaremos una línea de error estándar, sobre los dats de
% promedios. Se agregan cosas de estilo, como el grosor de la línea y
% además, con 'linestile' 'none' quitamos las líneas que unen a las líneas
% de error
errorbar(promedio, stderr, 'linewidth', 2, 'linestyle', 'none')

% Volvemos a borrar la vieja gráfica de barras
clf

% Mejor haremos una gráfica de boxplot (o de caja y bigotes), que es cada
% vez más común. La línea roja de cada caja indica la mediana, la caja
% indica el intercuartil, abarca el 50% de los datos, los "bigotes" son el
% rango completo de los datos
h = boxplot(datos);
set(h, 'linewidth', 2)
xlabel("Grupo experimental")    % Agregamos título a los ejes
ylabel("Promedio por grupo (Kg)") 

% Como algunas personas en la clase no tienen el módulo de estadística, el
% doctor nos sugiere usar el comando return para detener la ejecución hasta
% que instalen el módulo. El comando return detiene la función en el punto
% donde se encuentra
% return

%% Ahora vamos con análisis de series de tiempo

% Aquí declaramos la frecuencia de muestreo de los datos. Experimentar a
% modificar este valor, subir o bajar la frecuencia de muestreo, veremos
% como cambia la resolución o el espacio entre puntos, menos muestreo más
% espacio entre puntos
Fs = 50; 

% Hacemos nuestra serie de tiempo, desde 0 a 1 segundos (datos iniciales y
% finales) con un "step" o avanzando de 1/1000 cada vez (en este caso).
ejeTiempo = 0 : 1/Fs : 1;

% Aquí determinamos la frecuencia de nuestra onda, haremos que nuestros
% datos tengan una frecuencia de 2 Hz (se completan 2 ciclos en 1 segundo)
Frecuencia = 2;

% Ahroa haremos los datos para y, haremos una gráfica de una onda senoidal,
% notar que multiplicamos por 2pi porque Matlab maneja radianes, entonces
% es nuestro factor de conversión. Multiplicamos por la frecuencia para
% tener la frecuencia deseada.
y = sin(ejeTiempo*2*pi*Frecuencia);

% Ahora haremos más pruebas, detectaremos valores, por ejemplo.
% Aquí encontrará las coordenadas de los valores que tienen un valor mayor
% a 0.8. Es como poner un umbral
coord = find(y>0.8);

% Si hacemos esto, "recortamos" los valores que fueron mayores a 0.8 y los
% hacemos iguales a 0.9
y(coord) = 0.9;

% Ahora hacemos nuestra gráfica, damos formato a la gráfica, usamos líneas
% y puntos para que se muestre el muestreo de nuestra gráfica
figure(1)
plot(ejeTiempo, y, '-o', 'linewidth', 2)
xlabel('Tiempo (s)')
ylabel('Voltaje')

% Mantenemos la gráfica para que no se borre
hold on
% Haremos una nueva variable con plot para modificar otras propiedades.
% Notar las características de estilo usadas, sus nombres son
% autoexplicativos. En el caso del 'ro' es porque usamos el color rojo para
% poner los puntos. Solamente graficamos los valores de ejeTiempo y y que
% tengan las coordenadas de los valores que identificamos
h = plot(ejeTiempo(coord), y(coord), 'ro', 'markersize', 10);
set(h, 'markerfacecolor', 'r')  % Acá rellenamos los marcadores

% Ahora vamos con otra cosa.

%% Ciclos

clear, clc, clf     % Limpiamos todo
format compact      % Para que la salida esté compacta en la consola

% Creamos una nueva frecuencia de muestreo, eje de tiempo y datos
% aleatorios para nuestros nuevos ejemplos. Notar los argumentos para crear
% los datos, usando el tamaño de lo muestreado
Fs = 50;
ejeTiempo = 0: 1/Fs: 1;
longitud = length(ejeTiempo);
datos = randn(10, longitud);

% Hacemos nuestra gráfica, pero con todos los datos ahí revueltos a la vez
plot(ejeTiempo, datos, 'LineWidth', 3)
xlabel('Tiempo (s)')
ylabel('Voltaje')

% Ahora buscaremos graficar cada línea individualmente, para eso usaremos
% un ciclo
% Notar que usamos el intervalo de 1 a 3, que serán los valores de i
for i = 1:3 
    i^2;
end
% Notar que este letrero no se muestra hasta que no se terminen las 3
% repeticiones del for de arriba
disp('Termina el for')

% Como tip, se pueden hacer identaciones del código, por ejemplo en el for,
% haciendo un Ctrl + i con el texto a identar seleccionado

% Notar el resultado del siguiente ciclo, sobretodo la declaración de i
for i = [-2 3 10 .5]
    i^2;
end

% Ahora sí empezaremos a hacer nuestra figura
figure(1), clf
for i = 1:10
    % Se puede entender el uso de este if si vemos también la siguiente
    % sección
    if i == 5
        % Con esta línea el canal 5 se amplificaría 5 veces, se vería más
        % grande
        datos(i,:) = datos(i,:)+5;
        % También lo podemos "borrar" el canal o los datos haciendo todos
        % los valores de ese canal igual a nan (not a number)
        datos(i,:) = nan;
    end

    % Hacemos nuestra gráfica, usamos hold on para que se mantenga ahí,
    % notar que grafiamos datos(i:1)+ i*5, esto es para "separar" las
    % gráficas en la misma figura y plano
    h = plot(ejeTiempo, datos(i,:) + i*5, 'o-', 'LineWidth',2);
    hold on

    % Podemos usar el comando pause para ir deteniendo la ejecución en cada
    % iteración. La pausa se puede cancelar con ctrl + c. Pause se puede
    % usar como una función y se le pueden pasar como parámetro el número
    % de segundos que se hará la pausa
    pause
end

% Con esto se trata de lograr que no se vea el eje y, aunque sigue ahí y se
% nota si el marco de la ventana no es blanco. Notar que se trabaja sobre
% el elemento gca que significa "Get Current Axis"
set(gca, 'ycolor', 'w')

%% Ahora sobre la sentencia if

% Declaramos una variable de pruebas
variable = 68;

% Ahora usamos nuestro if para hacer comparaciones, podemos usar los
% operadores lógicos de menor que, mayor que, mayot o igual, etc
if variable < 50
    variable = 50;
end

%% Tarea

% Usar un if y un for para modificar algo de mis datos, hacer
% modificaciones de estilo y cosillas así, también usar el comando find,
% también hay que buscar subir datos.
