%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Tarea encargada el día jueves 29 de septiembre, 2022           %
%     Ejemplos de documentación de boxplot, anovan y kruskalwallis        %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Ejemplos de documentación de función boxplot

%% Gráfica con todos los datos juntos

% Cargamos los datos de muestra
load carsmall

% Ahora creamos una gráfica de caja y bigotes usando las mediciones de
% millas por galó, además agregamos título a la gráfica y descripciones a
% los ejes
boxplot(MPG)
xlabel('Todos los vehículos')
ylabel('Millas por Galón (MPG)')
title('Millas por galón de todos los vehículos')

% Como podemos notar, la gráfica muestra que la mediana de millas por galón
% para todos los vehículos en nuestra muestra es de aproximadamente 24, el
% valór mínimo es de 9 y el máximo es de 44.

%% Ejemplo de gráfica con los datos agrupados por origen

% Cargamos la base de datos
load carsmall

% Creamos nuestra gráfica y mandamos como parámetro de agrupación la
% variable origen
boxplot(MPG,Origin)
title('Millas por galón por origen del vehículo')
xlabel('País de origen')
ylabel('Millas por galón (MPG)')

% La gráfica resultante tiene 6 gráficas de caja en la misma figura, donde
% cada caja es la información de cada país

%% Ahora creamos una gráfica de caja con muescas

% Utilizamos este parámetro para reproducibilidad del ejemplo
rng default

% Ahora creamos nuestras distribuciones normales utilizando 100 elementos
% con mu = 5, para la primera, mu = 6 para la segunda y sigma = 1 para
% ambas.
x1 = normrnd(5, 1, 100, 1);
x2 = normrnd(6, 1, 100, 1);

% Ahora creamos las gráficas y poenmos sus etiquetas en el pie para que se
% identifique cada conjunto de datos
figure(1)
boxplot([x1, x2],'Notch','on','Labels', {'mu = 5', 'mu = 6'});
title('Comparación de datos aleatorios de diferentes distribuciones')

% El tener las muescas nos ayuda a ver con un 95% de seguridad si las
% medias son iguales o diferentes, en este caso como las muescas no se
% empalman, podemos decir que son diferentes.

% Podemos hacer otra figura ahora modificando los "bigotes" para que tengan
% una longitud de un rango intercuartil
figure(2)
boxplot([x1,x2],'Notch','on','Labels',{'mu = 5','mu = 6'},'Whisker',1)
title('Comparación de datos aleatorios de diferentes distribuciones')

% Los datos marcados con las cruces rojas indican que esos datos no entran
% en el rango que declaramos para los bigotes. Desde luego, mientras más
% pequeños sean esos bigotes, más datos serán cosiderados como extremos

%% Crear gráficas de caja compactas

% Creamos una matriz de 100 x 25 números aleatorios usando una distribución
% normal estándar para usar como ejemplo.
rng default  
x = randn(100,25);

% Creamos la figura
figure
% En el primer panel ponemos la información tal cual, una gráfica
% convencional
subplot(2,1,1)
boxplot(x)

% Ahora en el segundo panel ponemos el parámetro para que se grafiquen de
% manera compacta
subplot(2,1,2)
boxplot(x,'PlotStyle','compact')

% Con el formato pequeño es más fácil leer la información en este caso

%% Gráfica de cajas para vectores de diferentes tamaños

% Usaremos vectores de diferentes tamaños y una variable de agrupación.
% Generamos 3 vectores columna de diferentes tamaños, luego los combinamos
% todos en uno solo.

rng('default')  % Otra forma de marcar el generador aleatorio
x1 = rand(5,1);
x2 = rand(10,1);
x3 = rand(15,1);
x = [x1; x2; x3];   % Aquí los combinamos

% Ahora pasaremos a crear nuestra variable de agrupación, poniendo
% etiquetas repetidas en una matriz, repitiendo cada etiqueta la misma
% cantidad de veces que elementos tenga su respectivo vector.
g1 = repmat({'Primero'},5,1);
g2 = repmat({'Segundo'},10,1);
g3 = repmat({'Tercero'},15,1);
g = [g1; g2; g3];   % También los combinamos en una sola

% Ya solamente graficamos
boxplot(x, g);

% Fin de la función boxplot.

%% Ejemplos de la función anovan

% Cargamos la información de ejemplo, donde y es el vector de observaciones
% g1, g2 y g3 son las variables de agrupación o los factores. Cada factor
% tiene 2 niveles y cada observación es identificada por una combinación de
% facotres.
y = [52.7 57.5 45.9 44.5 53.0 57.0 45.9 44.0]';
g1 = [1 2 1 2 1 2 1 2]; 
g2 = {'hi';'hi';'lo';'lo';'hi';'hi';'lo';'lo'}; 
g3 = {'may';'may';'may';'may';'june';'june';'june';'june'};


% Primero probamos si la respuesta es la misma a través de todos los
% factores
p = anovan(y, {g1, g2, g3});

% En esta prueba podemos ver las comparaciones de las observaciones
% utilizando los diferentes criterios de agrupación, donde se puede notar
% que no hay una diferencia significativa entre los factores g1 y g3, pero
% sí la hay cuando los datos se agrupan por g2

% Podemos evaluar las interacciones de dos factores especificándolo en los
% parámetros de la función
p = anovan(y,{g1 g2 g3},'model','interaction','varnames',{'g1','g2','g3'})

% LAs interacciones se muestran como g1*g2, g1*g3 y g2*g3 en la tabla de
% ANOVA. También se muestran los valores de p para las interacciones. En
% este ejemplo vemos que la interacción entre g1 y g2 es significativa.

%% ANOVA de dos vías para diseños desbalanceados

% Cargamos la información de ejemplo, donde hay información de 406 carros,
% la variable org tiene el registro de donde fueron hechos y when muestra
% el año en el que se fabricó
load carbig

% Ahora hacemos nuestro análisis de dos vías donde podemos ver que el
% kilómetraje depende de dónde y cuándo se hicieron los autos
p = anovan(MPG,{org when},'model',2,'varnames',{'origin','mfg date'})

% El parámetro de 'model' 2, representa las dis interacciones, el valor de
% p para la interacción es grande, indicando que hay poca evidencia de que
% el efecto del momento de fabricación dependa de dónde se hizo el arro.
% Pero los efectos del origen y fecha sí son significativos.

%% Comparaciones múltiples con ANOVA de tres vías

% Hacemos nuestra pequeña base de datos, donde y es la observación o
% respuesta y g1, g2 y g3 son factores, cada uno con dos niveles y cada
% observación en y es definido por una combinación de los niveles de cada
% factor. 
y = [52.7 57.5 45.9 44.5 53.0 57.0 45.9 44.0]';
g1 = [1 2 1 2 1 2 1 2];
g2 = ["hi" "hi" "lo" "lo" "hi" "hi" "lo" "lo"];
g3 = ["may" "may" "may" "may" "june" "june" "june" "june"];

% Queremos probar si la respuesta es la misma para todos los niveles de 
% factores y hacer el cálculo de las estadísticas necesarias para las
% pruebas de múltiples comparaciones
[~,~,stats] = anovan(y,{g1 g2 g3},"Model","interaction", ...
    "Varnames",["g1","g2","g3"]);

% Podemos ver que hasta aquí es lo mismo que hicimos más arriba. Podemos
% ver que las medias del fector g1 y g2 son diferentes (entre sus
% factores). Ahora vamos a realizar una comparación múltiple para encontrar
% qué grupos de factores g1 y g2 son significativamente diferentes
[results,~,~,gnames] = multcompare(stats,"Dimension",[1 2]);

% En la gráfica que se produce podemos seleccionar las diferentes
% comparaciones haciendo click. La combinación de factores que
% seleccionemos se pondrá azul, las otras combinaciones se pondrán rojas si
% son significativamente diferentes o gris si no lo son.

% Ahora podemos ver nuestros resultados como una tabla, donde escribiremos
% los resultados para cada comparación de la varaible 'results', y además
% especificaremos el resto de los encabezados. Luego pondremos quién es
% cada grupo
tbl = array2table(results,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl.("Group A")=gnames(tbl.("Group A"));
tbl.("Group B")=gnames(tbl.("Group B"))

% Fin de los ejemplos de ANOVAN

%% Ejemplos para función kruskalwallis

%% Probar datos para una misma distribución

% Vamos a crear dos objetos diferentes con probabilidades de distribución
% iguales. La primera con una mu =0, la segunda con mu = 2 y ambas con
% sigma igual a 0.
pd1 = makedist('Normal');
pd2 = makedist('Normal','mu',2,'sigma',1);

% Ahora creamos una matriz de estos datos muestra generando números
% aleatorios de estas dos distribuciones. Agregamos el default al generador
% de números aleatorios
rng('default');
x = [random(pd1,20,2), random(pd2,20,1)];

% Las primeras dos culumnas de x contienen los datos generados por la
% primera distribución, la tercera contiene datos generados de la segunda
% distribución.

% Ahora probamos la hipótesis nula de que los datos de ejemplo de cada
% columna vienen de la misma distribución.
p = kruskalwallis(x)

% Por el valor de p obtenido rechazamos la hipótesis nula de que las tres
% distribuciones vienen de una misma distribución con un 1% de nivel de
% significancia. La tabla da más resultados adicionales

%% Tests adicionales para medias desiguales

% Ahora creamos dos distribuciones diferentes. La primera con mu=0, la
% segunda con mu=2 y ambas con sigma =1
pd1 = makedist('Normal');
pd2 = makedist('Normal', 'mu', 2, 'sigma', 1);

% Ahora creamos una matriz con las distribuciones anteriores
rng default;
x = [random(pd1, 20, 2), random(pd2, 20, 1)];

% Las primeras dos columnas son generadas de la primera distribución, la
% segunda es de la segunda. Ahora probamos la hipótesis nula de que todas
% vienen de la misma distribución.
[p, tbl, stats] = kruskalwallis(x, [], 'off')

% Por el valor obtenido de p se rechaza la hipótesis nula, pero haremos
% análisis adicionales. Ahora haremos un test para ver qué muestra
% (columna) viene de una distribución diferente.
c = multcompare(stats);

% Ahora podemos ver los resultados en una tabla convirtiéndolos a tabla
% desde la matriz
tbl = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"])

% Como podemos ver por los datos tanto de la tabla como del gráfico
% interactivo, los datos de la primera y última columna son de la misma
% distribución mientras que la tercera es significativamente diferente.

%% Probar por la misma ditribución pero a través de los grupos

% Ahora crearemos un vector strength que contiene las medidas de diferentes
% rayos de metal. Creamos además otro arreglo con las aleaciones

strength = [82 86 79 83 84 85 86 87 74 82 78 75 76 77 79 79 77 78 82 79];

alloy = {'st','st','st','st','st','st','st','st', 'al1','al1','al1',...
        'al1','al1','al1','al2','al2','al2','al2','al2','al2'};

% La hipótesis nula sería que todas las fuerzas de las aleaciones vienen de
% una misma distribución, a través de las tres aleaciones
p = kruskalwallis(strength,alloy,'off')

% Podemos ver que el valor de p es 0.0010 por lo que se rechaza la
% hipóteisis nula con significancia del 1%

% Fin de kruskalwallis y fin de toda la tarea.




