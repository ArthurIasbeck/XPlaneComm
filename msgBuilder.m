function msg = msgBuilder(dataType, data1, data2, data3, data4, data5, data6, data7, data8)
    headerData = [68 65 84 65 0];
    msgData = [single2bytes(data1) single2bytes(data2) single2bytes(data3) single2bytes(data4) single2bytes(data5) single2bytes(data6) single2bytes(data7) single2bytes(data8)]; 
    msg = [headerData int2bytes(dataType) msgData];
end