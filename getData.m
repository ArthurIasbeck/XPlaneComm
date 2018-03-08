function data = getData(msgRecv, dataNum)
    % A obten��o de dados come�a a partir da sexta posi��o do vetor, j� que
    % os primeiros 5 bytes da mensagem s�o destinados ao cabe�alho. Neste
    % caso, o primeiro dado est� contido entre as posi��es 6 e 9, o segundo
    % entre 10 e 13, o terceiro entre 14 e 17, e assim por diante. Este
    % racioc�cio explica a equa��o abaixo.
    
    firstIndex = 6 + 4*(dataNum-1);
    lastIndex = firstIndex + 3;
    dataBytes = msgRecv(firstIndex:lastIndex);
    data = bytes2single(dataBytes);
end