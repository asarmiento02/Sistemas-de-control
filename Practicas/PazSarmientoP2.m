% Datos
tiempo_simulacion=15;
theta_d=0;
k=5;
b=0.9;
J=1;
K0=1;
%% 1. Determinar la respuesta del sistema en lazo abierto (considere r(t)=0)
% ante perturbaciï¿½n de escalï¿½n unitario.
G_1=tf(1/J,[1 b/J k/J])%Funcion de transferencia en lazo abierto
step(G_1,tiempo_simulacion);
legend('Lazo abierto K0=1')
title('Respuesta en lazo abierto ante una perturbaciï¿½n Escalï¿½n Unitario')
%% 2. Presente la funciï¿½n de transferencia del sistema en lazo cerrado.
figure(2)
G_2=feedback(G_1,K0)  %La referencia es nula. Por lo tanto,
%La funcion de transferencia solamente esta dada por la ganancia en lazo
%cerrado del aporte de la perturbacion
step(G_2,tiempo_simulacion)
legend('Lazo cerrado K_0=1')
title('Respuesta ante perturbaciï¿½n Escalï¿½n Unitario lazo cerrado K0=1')

% Grafica adicional para comparar apartado 1 y 2
figure(3)
step(G_1,tiempo_simulacion)
hold on
step(G_2,tiempo_simulacion)
hold off
title('Comparativa lazo abierto vs lazo cerrado ante perturbacion')
legend('Lazo abierto','Lazo cerrado K_0=1')
%% 3. Determine la respuesta en lazo cerrado ante una perturbaciï¿½n de 50
K0=50;% escalï¿½n unitario, fijando K0 en 50.
G_3=feedback(G_1,K0); %Nueva funcion de transferencia lazo cerrado variando K0
figure(4)%Creacion de nueva figura
step(G_1,tiempo_simulacion)% Respuesta de lazo abierto ante perturbacion, no hay retroalimentacion
hold on
step(G_3,tiempo_simulacion)
hold off
%Propiedades de la grafica
legend('Lazo Abierto','Lazo Cerrado (K0 = 50)');
title('Respuesta ante perturbaciï¿½n - Lazo Abierto vs Lazo Cerrado K0=50')
grid on
%% Paso Extra. Evaluar la funciï¿½n de transferencia ante una perturbaciï¿½n de
% escalï¿½n unitario, fijando K0 en diferentes valores.
figure(5)
K0=transpose([1 50 70 100]);%Valores respectivos de K0
estado_estable=[];%Creacion de la variable que almacena las constantes de estado estable
for i=1:length(K0)%% el bucle es del tamano de las ganancias que se quieren evaluar    
    G_ext=feedback(G_1,K0(i)); % Crea la funcion de transferencia con el valor de K0 respectivo
    if i~=1
        step(G_ext,tiempo_simulacion)% para omitir la primera grafica ya que no se aprecian las demas
    end
    hold on
    leyenda(i)=strcat('G2 con K_0=',string(K0(i)));%Crea la leyenda para cada valor de K0
    disp(leyenda(i))% Se muestra en consola la funcion de transferencia y su valor de K0
    estado_estable(i,1)=1/(K0(i)+k/J);%almacena el valor de estado estable de la tf, el 5=k/J
    fprintf('\t1/(Kp)=%f\n',estado_estable(i))% Imprime en consola el valor de estabilizacion
    G{i}=G_ext;%almacena en una celda la funcion obtenida, en el elemento i=1 2 3 lenght(K0)
    escalon_info{i}=stepinfo(G_ext);%almacena en una celda escalon, las caracteristicas de la tfnction
end
% Propiedades de la grafica
legend(leyenda(2),leyenda(3),leyenda(4))%Se muestra la leyenda en la grafica
title('Respuesta ante perturbacion - K0 de distintos valores')
hold off

    %% 4. Compare las respuestas obtenidas de los apartados 2 y 3.
    %Analice los resultados en funciï¿½n de las propiedades del sistema 
    %de control de lazo cerrado 
    %y su actuaciï¿½n ante perturbaciones del sistema.
    % Creacion de las matrices que almacenaran los valores de interes de cada
    % funcion de transferencia
    Tiempo_asentamiento=[];
    Tiempo_pico=[];
    Sobrelongacion=[];
    Sobrelongacion_porcentual=[];
    for i=1:4    
        Tiempo_asentamiento(i,1)=escalon_info{i}.SettlingTime;
        %En el elemento i es una estructura que si se accede a su variable 
        %.SettlingTime otorga el tiempo de asentamiento, de igual forma con los
        %demas valores
        Tiempo_pico(i,1)=escalon_info{i}.PeakTime;
        Sobrelongacion(i,1)=escalon_info{i}.Peak;
        Sobrelongacion_porcentual(i,1)=escalon_info{i}.Overshoot;
        % El tamaño de las matrices es de nx1 siendo un vector columna para ser
        % mostrado en consola
    end
    funcion_transferencia=transpose(1:4);
    resultado=table(K0,estado_estable,Tiempo_asentamiento,Tiempo_pico,Sobrelongacion,Sobrelongacion_porcentual)
