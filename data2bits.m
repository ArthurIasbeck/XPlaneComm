function dataOut = data2bits(dataIn)
    dataIn = dec2bin(dataIn,8);
    % Note que o vetor de bits resultante é construido de trás para frente
    % Isso é explicado pelo fato de o Windows utilizar o padrão little 
    % endian.
    dataOut = [dataIn(4,:) dataIn(3,:) dataIn(2,:) dataIn(1,:)];
end