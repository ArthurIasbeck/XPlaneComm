# Comunicação entre MATLAB e X-Plane 11
Neste repositório, você encontrará um algoritmo implementado em MATLAB que estabelece uma comunicação baseada no protocolo UDP com o simulador de voo X-Plane 11, de forma que seja possível tanto obter dados gerados durante a simulação quanto controlar a aeronave utilizada através de comandos enviados pelo MATLAB. 

O algoritmo deve ser inicializado com a simulação em andamento e com a aeronave em voo de cruzeiro. Depois de inicializado, o algoritmo e garante ao avião um voo estável através do controle dos ângulos de pitch e roll. Para estabeler uma comunicação com o simulador e inicializar o controle de atitude, basta baixar todos os arquivos do diretório na mesma pasta e executar o script PIDXPlane.m. 

Este código implementa dois controladores do tipo PID para realizar o controle de atitude do avião, porém, qualquer ténica de controle pode ser aqui aplicada e avaliada. 
