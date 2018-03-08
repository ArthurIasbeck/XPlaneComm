clear;
clc;
close;

display('Iniciando comunica��o...');
sockUDP = udp('127.0.0.1', 
   'RemotePort', 49000, 'LocalPort', 8888);
fopen(sockUDP);
display('Comunica��o UDP inicializada.');

% Vari�veis de controle e armazenamento
loops = 1;
tic;
t = 0;
fileID = fopen('pitch_roll_data.txt','w');

% Vari�veis relacionadas ao PID
firstLoop = 1;
ierr = 0;
err = zeros(1,2);

while 1
    msgRecv = fread(sockUDP);
    pitch = getData(msgRecv,2);
    roll = getData(msgRecv,3);
        
    % Dados recebidos s�o armazenados em um arquivo
    fprintf(fileID,'%f\t',pitch);
    fprintf(fileID,'%f\t',roll);
    fprintf(fileID,'%f\r\n',t);
    
    % Este if garante que a mensagem seja mostrada apenas a cada 5 loops, o
    % que garante que fique mais f�cil vizualiz�-la.
    dt = toc;
    t = t + dt;
    if rem(loops,5) == 0
        clc;
        fprintf('pitch = %f\n',pitch);
        fprintf('roll = %f\n',roll);
        fprintf('t = %f\n\n',t);
        
        fprintf('elevatorValue = %f\n',elevatorValue);
        fprintf('aileronValue = %f\n',aileronValue);
    end
    tic;
    
    % A ideia � controlar o Pitch para que o avi�o se estabelize em
    % cruzeiro, para que futuramente seja poss�vel controlar a altura a
    % partir do controle do pitch.
    
    % C�digo que computa o PID para o pitch
    kpp = 0.13; kip = 0.0015; kdp = 0.05;
    input = pitch;
    ref = 0;
    err(1) = ref - input;
    perr = kpp*err(1);
    ierr = ierr + (kip*err(1));
    derr = kdp*(err(1) - err(2));
    output = perr + ierr + derr;
    err(2) = err(1);
    elevatorValue = output;
    
    % O valor calculado pelo PID � ent�o enviado ao XPlane
    setElevator(elevatorValue,sockUDP);
    
    % C�digo que computa o PID para o roll
    kpr = 0.2; kir = 0.003; kdr = 0.02;
    input = roll;
    ref = 0;
    err(1) = ref - input;
    perr = kpr*err(1);
    ierr = ierr + (kir*err(1));
    derr = kdr*(err(1) - err(2));
    output = perr + ierr + derr;
    err(2) = err(1);
    aileronValue = output;
    
    % O valor calculado pelo PID � ent�o enviado ao XPlane
    setAileron(aileronValue,sockUDP);
    
    loops = loops + 1;
end
%% Encerramento da comunica��o UDP
clc;
leaveControl(sockUDP);
display('Encerrando comunica��o UDP...');
fclose(sockUDP);
delete(sockUDP);
clear sockUDP;
display('Comunica��o UDP encerrada.');

%% Resultados obtidos
clc;
close all;
% Leitura do arquivo.
fileData = load('pitch_roll_data.txt');
pitch = fileData(:,1);
roll = fileData(:,2);
t = fileData(:,3);

% Vari�vel que determina quantos dados da amostra ser�o mostrados.
nData = length(t);

% Plot dos dados.
figure(1);
plot(t(1:nData),pitch(1:nData));
hold on;
plot(t(1:nData),zeros(1,nData)); 
title('Pitch x Tempo');
xlabel('Tempo');
ylabel('Pitch');
sizeAxis = axis;
sizeAxis(2) = max(t(1:nData));
sizeAxis(3) = sizeAxis(3) - 5;
sizeAxis(4) = sizeAxis(4) + 5;
axis(sizeAxis);
fileName = strrep(['images\pitch\kp ' num2str(kpp) ' ki ' num2str(kip) ' kd ' num2str(kdp)],'.',',')
% print(fileName,'-dpng');

figure(2);
plot(t(1:nData),roll(1:nData));
hold on;
plot(t(1:nData),zeros(1,nData)); 
title('Roll x Tempo');
xlabel('Tempo');
ylabel('Roll');
sizeAxis = axis;
sizeAxis(2) = max(t(1:nData));
sizeAxis(3) = sizeAxis(3) - 5;
sizeAxis(4) = sizeAxis(4) + 5;
axis(sizeAxis);
fileName = strrep(['images\roll\kp ' num2str(kpr) ' ki ' num2str(kir) ' kd ' num2str(kdr)],'.',',')
% print(fileName,'-dpng');

figure(3);
plot(t(1:nData),roll(1:nData));
hold on;
plot(t(1:nData),pitch(1:nData));
hold on;
plot(t(1:nData),zeros(1,nData)); 
title('Roll x Tempo e Pitch x Tempo');
xlabel('Tempo');
legend('roll', 'pitch');
sizeAxis = axis;
sizeAxis(2) = max(t(1:nData));
sizeAxis(3) = sizeAxis(3) - 5;
sizeAxis(4) = sizeAxis(4) + 5;
axis(sizeAxis);
fileName = strrep(['images\pitch_roll\(kp ' num2str(kpp) ' ki ' num2str(kip) ' kd ' num2str(kdp) ')( kp '  num2str(kpr) ' ki ' num2str(kir) ' kd ' num2str(kdr) ')'],'.',',')
% print(fileName,'-dpng');

%% Testes
%% Teste msgBuilder
% Este c�digo constroi e envia uma mensagem para o XPlane de duas formas
% diferentes. Manualmente e por meio da fun��o msgBuilder. Este c�digo foi
% desenvolvido para testar a fun��o msgBuilder.

clear 
clc
display('Iniciando comunica��o UDP...');
sockUDP = udp('127.0.0.1', 'RemotePort', 49000, 'LocalPort', 1000);
fopen(sockUDP);
headerData = [68 65 84 65 0];
display('Iniciando envio de mensagens...');
while 1
    display('Envio modo manual');
    controlSurfaces = [single2bytes(1) single2bytes(0) single2bytes(0) single2bytes(-999) single2bytes(-999) single2bytes(-999) single2bytes(-999) single2bytes(-999)]; 
    msgSend = [headerData int2bytes(11) controlSurfaces];
    fwrite(sockUDP, msgSend);
    pause(1);

    controlSurfaces = [single2bytes(-1) single2bytes(0) single2bytes(0) single2bytes(-999) single2bytes(-999) single2bytes(-999) single2bytes(-999) single2bytes(-999)];
    msgSend = [headerData int2bytes(11) controlSurfaces];
    fwrite(sockUDP, msgSend);
    pause(1);
    
    display('Envio usando msgBuilder');
    msgSend = msgBuilder(11,1,0,0,-999,-999,-999,-999,-999);
    fwrite(sockUDP, msgSend);
    pause(1);

    msgSend = msgBuilder(11,-1,0,0,-999,-999,-999,-999,-999);
    fwrite(sockUDP, msgSend);
    pause(1);
end
%%
display('Encerrando comunica��o UDP...');
fclose(sockUDP);
delete(sockUDP);
clear sendUDP;
display('Comunica��o UDP encerrada.');

%% Teste setElevator e leaveControl
% Este c�digo envia para o XPlane mensagens que alteram a angula��o dos
% elevators (profundores) e por fim devolte o controle ao usu�rio. Este 
% c�digo foi desenvolvido para testar as fun��es setElevator e 
% leaveControl

clear 
clc
display('Iniciando comunica��o UDP...');
sockUDP = udp('127.0.0.1', 'RemotePort', 49000, 'LocalPort', 1000);
fopen(sockUDP);

while 1
    setElevator(1,sockUDP);
    pause(1);
    setElevator(-1,sockUDP);
    pause(1);
end
%%
leaveControl(sockUDP);
display('Encerrando comunica��o UDP...');
fclose(sockUDP);
delete(sockUDP);
clear sendUDP;
display('Comunica��o UDP encerrada.');