function velocidadReaccion = michaelisMenten2022(S, Vmax, Km)
    % S -> Concentración de sustrato
    % Vmax -> Velocidad máxima de reacción
    % Km -> Concentración a la que se alcanza Vmax/2
    velocidadReaccion = Vmax * S ./ (Km + S);
end