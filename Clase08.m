clear, clc

% Cargamos la base de datos con la que trabajaremos
tablaDatos = readtable('databases\Cano_hernandez_lucia_carolina2.xlsx',...
    'VariableNamingRule', 'preserve');

% Obtenemos las propiedades de la tabla para luego sacar los nombres de
% variables
prop = tablaDatos.Properties;
VarNames = prop.VariableNames;
% Solamente nos interesan las columnas de la 6 a la 11
VarNames = VarNames(6:11);

% Extraemos los datos de interes, ya fuera de la tabla
datos = table2array(tablaDatos(:, 6:11));

% Sacamos los diferentes grupos experimentales que se realizaron. Sacamos
% en una variable todoos los datos de la columna condición y luego sacamos
% los datos unicos con unique
condiciones = tablaDatos.CONDICION;
grupos = unique(condiciones);

% Identificamos los valores que sean iguales a 'H' en la columna de sexo,
% en el arreglo 'isHembra' se ubica la misma cantidad de valores de la
% columna SEXO, por cada elemento con el valor de sexo 'H' entonces tenemos
% un 1, si tenemos algo diferente de 'H' nos pondrá un 0
isHembra = strcmpi(tablaDatos.SEXO, 'H');

% También sacamos los valores de la hora Zeitgeber, todos los valores y los
% únicos
ZT = tablaDatos.ZT2;
ZTs = unique(ZT);

figure(1), clf

% Ahora haremos una iteración por cada grupo
nGrupos = length(grupos);
for g = 1:nGrupos
    subplot(1, nGrupos, g)
    % Seleccionamos los elementos de cada grupo. Es decir, ponemos un 1 en
    % las condiciones (elementos del arreglo 'condiciones' que sean iguales
    % a la condición que estamos revisando actualmente
    idxG = strcmpi(grupos(g), condiciones);
    % Luego sacamos los demás datos de ese grupo que acabamos de aislar,
    % por eso tomamos los valores de la variable 'datos' indexando por idxG
    datosGrupo = datos(idxG,:);
    % También obtenemos cuántos datos hay por cada grupo
    nDatosGrupo = size(datosGrupo, 1);
    
    % Ahora graficamos el conjunto de datos para ese grupo
    h = boxplot(datosGrupo, VarNames);
    % Vamos a declarar un rango específico para que todos los grupos tengan
    % la misma escala
    ylim([0 500]);
    % Y ponemos el título de cada grupo arriba de su panel
    title(grupos(g))
end

figure(2), clf
% Ahora vamos a graficar los datos para cada punto temporal para cada grupo

limInfy = inf;
limSupy = -inf;
nHoras = length(ZTs);
for g = 1:nGrupos
    % Obtenemos los datos del grupo
    idxG = strcmpi(grupos(g), condiciones);

    subplot(1, nGrupos, g)
    % Ahora iteramos sobre los datos de cada horario
    for hora = 1:length(ZTs)
        % Ahora seleccionamos una hora en específico
        idxZT = ZT == ZTs(hora);
        % Ahra hacemos una doble selección, del grupo y la hora, usamos
        % 'all' para que se seleccionen los índices solamente cuando se
        % cumple tanto el índice de grupos como de puntos temporales
        idxAll = all([idxG idxZT], 2);
        % Obtenemos el número de datos sumando todos los índices verdaderos
        % que cumplieron con los criterios
        nDatos(hora) = sum(idxAll);
        % Vamos a establecer la columna de interés 
        colInteres = 1;
        % Seleccionamos los datos de la columna 3 porque contiene la
        % glucosa y ahorita queremos ver eso
        promedio(hora) = mean(datos(idxAll, colInteres));
        % Obtenemos el error de la media del mismo conjunto de datos
        stdErr(hora) = std(datos(idxAll, colInteres)) / sqrt(nDatos(hora));
        
        % Ahora graficamos el valor de la n en el lugar donde va el
        % promedio de los datos
        text(ZTs(hora)+0.2, promedio(hora)+10, ...
            ['n=' num2str(nDatos(hora))])
        hold on
    end
    % Ahora sí graficamos los valores del error estándar de la media y los
    % promedios de los datos
    errorbar(ZTs, promedio, stdErr, 'LineWidth', 2), hold on
    plot(ZTs, promedio, 'o-', 'MarkerSize', 5, 'LineWidth', 2)
    % Agregamos los ejes y título, además de poner cada valor con una misma
    % escala
    title(grupos(g))
    ylabel('Valor de GLU')
    xlabel('Hora')
    ylim([40 220])
end

% Ahora de tarea hay que hacer una gráfica como la figura 2 pero separada
% en dos líneas, una para hembras y otra para machos






