function dataOut = bits2single(dataIn) 
    bin = dataIn;
    signal = (-1)^bin2dec(bin(1));
    e = bin2dec(bin(2:9));
    fraction = 1;
    j = 1;
    for i=10:32
        fraction = fraction + bin2dec(bin(i))*2^(-j);
        j = j + 1;
    end

    value = signal*fraction*2^(e-127);
    dataOut = value;
end