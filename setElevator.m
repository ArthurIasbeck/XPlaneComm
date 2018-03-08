function setElevator(value,sendUDP)
    if value > 1
        value = 1;
    end
    if value < -1
        value = -1;
    end
    msgSend = msgBuilder(11,value,-999,-999,-999,-999,-999,-999,-999);
    fwrite(sendUDP, msgSend);
end