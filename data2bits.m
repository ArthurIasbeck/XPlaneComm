function dataOut = data2bits(dataIn)
    dataIn = dec2bin(dataIn,8);
    % Note que o vetor de bits resultante � construido de tr�s para frente
    % Isso � explicado pelo fato de o Windows utilizar o padr�o little 
    % endian.
    dataOut = [dataIn(4,:) dataIn(3,:) dataIn(2,:) dataIn(1,:)];
end