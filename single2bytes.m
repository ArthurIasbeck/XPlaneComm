function bytes = single2bytes(single)
    %#ok<*AGROW>
    if single == 0
        bytes(4) = 0;
        bytes(3) = 0;
        bytes(2) = 0;
        bytes(1) = 0;
    else
        log2 = 0.69314718056;
        exp = floor(log(abs(single)) / log2);
        biasedExp = exp + 127;
        binaryBiasedExp = dec2bin(biasedExp,8);

        mantissa = 1;
        mantissaString = '';
        absfloat = abs(single);
        for ctr = 1:23
            mantissaTemp = mantissa + 2^(-ctr);
            if (mantissaTemp * 2^(exp)) <= absfloat
                mantissaString(end+1) = '1'; 
                mantissa = mantissaTemp;
            else
                mantissaString(end+1) = '0';
            end
        end
        if single > 0 
            signal = '0';
        else 
            signal = '1';
        end

        binaryNumber = [signal binaryBiasedExp mantissaString];
        bytes = zeros(1,4);
        bytes(4) = bin2dec(binaryNumber(1:8));
        bytes(3) = bin2dec(binaryNumber(9:16));
        bytes(2) = bin2dec(binaryNumber(17:24));
        bytes(1) = bin2dec(binaryNumber(25:32));
    end
end