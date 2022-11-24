%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Tarea encargada el día lunes 20 de octubre, 2022              %
%     Reconstruir la figura 2 de la clase y separar machos de hembras     %
%                  Por: Ricardo Velázquez Contreras                       %
%              Probado en MARLAB R2022a - Windows 10 21H2                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc

% Cargamos la base de datos con la que trabajaremos, pongo el
% 'VariableNamingRule' como true para evitar un warning
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

% También sacamos los valores de la hora Zeitgeber, todos los valores y los
% únicos
ZT = tablaDatos.ZT2;
ZTs = unique(ZT);

% Ahora vamos a graficar los datos para cada punto temporal para cada grupo
figure(1), clf
% Ahora haremos una iteración por cada grupo
nGrupos = length(grupos);
for g = 1:nGrupos
    % Obtenemos los datos del grupo
    idxG = strcmpi(grupos(g), condiciones);

    subplot(1, nGrupos, g)
    % Ahora iteramos sobre los datos de cada horario
    for hora = 1:length(ZTs)
        % Ahora seleccionamos una hora en específico
        idxZT = ZT == ZTs(hora);
        % Identificamos los valores que sean iguales a 'H' en la columna de sexo,
        % en el arreglo 'idxH' se ubica la misma cantidad de valores de la
        % columna SEXO, por cada elemento con el valor de sexo 'H' entonces tenemos
        % un 1, si tenemos algo diferente de 'H' nos pondrá un 0. Hacemos
        % lo mismo para los machos
        idxH = strcmpi(tablaDatos.SEXO, 'H');
        idxM = strcmpi(tablaDatos.SEXO, 'M');
        % Ahra hacemos una doble selección, del grupo y la hora, usamos
        % 'all' para que se seleccionen los índices solamente cuando se
        % cumple tanto el índice de grupos como de puntos temporales y el
        % sexo
        idxAllHembras = all([idxG idxZT idxH], 2);
        idxAllMachos = all([idxG idxZT idxM], 2);
        % Obtenemos el número de datos sumando todos los índices verdaderos
        % que cumplieron con los criterios
        nDatosH(hora) = sum(idxAllHembras);
        nDatosM(hora) = sum(idxAllMachos);
        % Vamos a establecer la columna de interés 
        colInteres = 1;
        % Seleccionamos los datos de la columna 3 porque contiene la
        % glucosa y ahorita queremos ver eso
        promedioH(hora) = mean(datos(idxAllHembras, colInteres));
        promedioM(hora) = mean(datos(idxAllMachos, colInteres));
        % Obtenemos el error de la media del mismo conjunto de datos
        stdErrH(hora) = std(datos(idxAllHembras, colInteres)) / sqrt(nDatosH(hora));
        stdErrM(hora) = std(datos(idxAllMachos, colInteres)) / sqrt(nDatosM(hora));
        
        % Ahora graficamos el valor de la n en el lugar donde va el
        % promedio de los datos
        text(ZTs(hora)+1, promedioH(hora)+1, ...
            ['n=' num2str(nDatosH(hora))])
        hold on
        text(ZTs(hora)+1, promedioM(hora)-1, ...
            ['n=' num2str(nDatosM(hora))])
        hold on
    end
    % Ahora sí graficamos los valores del error estándar de la media y los
    % promedios de los datos
    plot(ZTs, promedioH, '*-', 'MarkerSize', 5, 'LineWidth', 2, 'Color', 'red')
    hold on
    plot(ZTs, promedioM, 'o-', 'MarkerSize', 5, 'LineWidth', 2, 'Color', 'blue')
    hold on
    errorbar(ZTs, promedioH, stdErrH, 'LineWidth', 2, 'Color', 'red')
    hold on
    errorbar(ZTs, promedioM, stdErrM, 'LineWidth', 2, 'Color', 'blue')
    
    % Agregamos los ejes y título, además de poner cada valor con una misma
    % escala
    legend({'Hembras', 'Machos'})
    title(grupos(g))
    ylabel('Valor de GLU')
    xlabel('Hora')
    ylim([38 405])
end

% EOF
