function leaveControl(sockUDP)
    msgSend = msgBuilder(11, 0, 0, 0, -999, -999, -999, -999, -999);
    fwrite(sockUDP, msgSend);
    msgSend = msgBuilder(11, -999, -999, -999, -999, -999, -999, -999, -999);
    fwrite(sockUDP, msgSend);
    msgSend = msgBuilder(25, -999, -999, -999, -999, -999, -999, -999, -999);
    fwrite(sockUDP, msgSend);
    msgSend = msgBuilder(8, -999, -999, -999, -999, -999, -999, -999, -999);
    fwrite(sockUDP, msgSend);
end