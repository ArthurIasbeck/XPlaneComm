function data = getData(msgRecv, dataNum)
    % A obtenção de dados começa a partir da sexta posição do vetor, já que
    % os primeiros 5 bytes da mensagem são destinados ao cabeçalho. Neste
    % caso, o primeiro dado está contido entre as posições 6 e 9, o segundo
    % entre 10 e 13, o terceiro entre 14 e 17, e assim por diante. Este
    % raciocício explica a equação abaixo.
    
    firstIndex = 6 + 4*(dataNum-1);
    lastIndex = firstIndex + 3;
    dataBytes = msgRecv(firstIndex:lastIndex);
    data = bytes2single(dataBytes);
end