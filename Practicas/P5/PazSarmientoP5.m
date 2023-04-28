% Practica 5 Alexander Sarmiento Eduardo Paz
% Parte a
G=tf(1,[1,15,50,0]);
K=30:20:150; %Crea varios valores de K del 30 al 150 de 20 en 20
tabla=table;
figure(1) %Figura 1, step de distintos valores de K
for j=1:length(K) %Evaluar respuesta del sistema para distintos valores de K
    T{j,1}=feedback(G*K(j),1);%Funcion de lazo cerrado para cada valor de K
    %apartado a.1 Error en estado estacionario y valor de Kv ante entrada
    %rampa
    [Kv(j,1),EssRamp(j,1)]=error_rampa(K(j)*G.Numerator{1,1},G.Denominator{1,1});
    %apartado a.2, porcentaje de sobrelongacion y el tiempo de asentamiento
    %entrada escalon
    if j==1
        hold off %esto es para que al ejecutar por segunda vez, no se superpongan las graficas
    else 
        hold on
    end
    step(T{j,1}); %Respuesta transitoria escalon unitario ante variacion de K
    tabla=[tabla; struct2table(stepinfo(T{j,1}))];% Almacena en una tabla, la informacion del stepinfo para cada valor de K
end
legend('K=30','K=50','K=70','K=90','K=110','K=130','K=150');title('Step response para distintos valores de K')
% A.1 Respuesta ante entrada tipo rampa, error en estado estacionario 
table(transpose(K),Kv,EssRamp,'VariableName',{'K' 'Kv' 'EssRamp'}) %
% A.2 Respuesta escalon unitario informacion de overshoot y tiempo de
%asentamiento
tabla=[array2table(transpose(K),'VariableName',{'K'}) tabla] 
figure(5)
subplot(1,2,1);plot(K,Kv);title('K vs Kv');
subplot(1,2,2);plot(K,EssRamp);title('K vs EssRamp')
%% Parte b
G=tf(1,[1,15,50,0]);
T_disign=Tf_disign(0.1,3) %Funcion que crea la funcion de transferencia de diseno
figure(2)%Grafica de lugar de las raices y step response de la Tf no compensada
subplot(1,2,1)
hold off
rlocus(G) %realiza el lugar de las raices del controlador proporcional
sgrid(T_disign.zeta,T_disign.omega_n)%Delimita los valores de diseño
limites_graficas(T_disign.polos,T_disign.y1,T_disign.y2)
xlim([-5 5])
ylim([-5 5])
[Kp,poles]=rlocfind(G,-1.8546 + 2.1634i) %Calcula la ganancia proporcional del controlador no compensado
% Se almacena la ganancia Kp necesaria para establecer el polo
G_sys_nocompensado=Kp*G %Controlador*Ganancia
Gc_nocompensada=Kp %muestra el controlador
T_nocompensada=feedback(G_sys_nocompensado,1) %la nueva funcion de transferencia en lazo cerrado producto del controlador
subplot(1,2,2);step(T_nocompensada);legend;title('T=91.68/(s^3 + 15.0*s^2 + 50.0*s + 91.68)')
%% Calculo de la compensacion del sistema
[kv_nocompensada,EssRamp_nocompensada]=error_rampa(G_sys_nocompensado.Numerator{1,1},G_sys_nocompensado.Denominator{1,1}) % Calculo del error del estado estacionario de la funcion no compensada ante una entrada rampa
kv_compensada = 10; %Limite de valor de Kv solicitado
alpha = kv_compensada/kv_nocompensada %calcular el aumento necesario que debe resultar por la relación polo-cero del compensador
zero = -0.005;%Valor tomado de cero, cercano al eje para evitar un error en el sistema
p =(zero/alpha);%Polo calculado del controlador
[num,den]= zp2tf(zero,p,Kp);%Funcion de transferencia de polos y ceros
Gc_compensada=tf(num,den) %Controlador compensado
G_sys_Compensado=Gc_compensada*G %Lazo abierto del sistema compensado
T_compensado=feedback(G_sys_Compensado,1)
%% Parte c
%Comparativa de sistema compensado y sin compensar
figure (3)
%Comparativa ante respuesta escalon unitario de sistema con y sin
%compensacion de retardo
hold off;step(T_nocompensada);hold on;step(T_compensado);legend;xlim([0 5])
figure(4)
%Comparativa ante respuesta rampa de sistema con y sin
%compensacion de retardo, xlim disminuye los limites para apreciar mejor
%las graficas
hold off;step(tf(1,[1 0])*T_nocompensada);hold on;step(tf(1,[1 0])*T_compensado);xlim([0 1.5])
legend('T_nocompensada','T_compensado')

%Error para entrada tipo rampa
%kV no compensada esta en la parte de arriba ya que es necesaria para el
%calculo del controlador compensado
[kv_compensada,EssRamp_compensada]=error_rampa(G_sys_Compensado.Numerator{1,1},G_sys_Compensado.Denominator{1,1});
Parteb.Sistema={'Sin Compensar'; 'Compensado'};
Parteb.Kv=[kv_nocompensada;kv_compensada];
Parteb.EssRamp=[EssRamp_nocompensada;EssRamp_compensada];

%Error para entrada tipo escalon unitario
[kp_nocompensada,EssStep_nocompensada]=error_step(G_sys_nocompensado.Numerator{1,1},G_sys_nocompensado.Denominator{1,1}); % Calculo del error del estado estacionario de la funcion no compensada ante una entrada rampa
[kp_compensada,EssStep_compensada]=error_step(G_sys_Compensado.Numerator{1,1},G_sys_Compensado.Denominator{1,1});
Parteb.Kp=[kp_nocompensada;kp_compensada];
Parteb.EssStep=[EssStep_nocompensada;EssStep_compensada];

Step_infor_T_nocompensada=stepinfo(T_nocompensada);
Step_infor_T_compensada=stepinfo(T_compensado);
Parteb.OvershootStep=[Step_infor_T_nocompensada.Overshoot;Step_infor_T_compensada.Overshoot];
Parteb.SettlingTimeStep=[Step_infor_T_nocompensada.SettlingTime;Step_infor_T_compensada.SettlingTime];
%Tabla final de resultados
tabla=struct2table(Parteb)
%% Error rampa es otra funcion que esta en otro archivo, es la modificacion de errortf solamente que permite ver el error de rampa
function Td=Tf_disign(Oshoot,tiempo_asentamiento)
    %% Funcion de transferencia deseada Td para establecer limites de diseño
    %Valores de seleccion de diseño, seleccionados por debajo de las
    %condiciones limites de design
    Td.Oshoot=Oshoot; %Porcentaje de sobrelongacion
    Td.t_asentamiento=tiempo_asentamiento; %Tiempo de asentamiento
    Td.zeta=sqrt(log(Td.Oshoot)^2/(pi^2+log(Td.Oshoot)^2));%Valor del factor de amortiguamiento
    Td.omega_n=4/(Td.zeta*Td.t_asentamiento); %Valor de la frecuencia w_n
    % Polo de diseño sigma+j*wd asociado a los valores de zeta y omega_n
    Td.sigma=Td.omega_n*Td.zeta;
    Td.wd=Td.omega_n*sqrt(1-Td.zeta^2);
    %Funcion de transferencia
    Td.transfer_function=tf(Td.omega_n^2,[1 2*Td.omega_n*Td.zeta Td.omega_n^2]);%wn^2/(s^2+2*zeta*wn+wn^2)
    %Polos del sistema
    Td.polos=pole(Td.transfer_function);
    %Limites de la seleccion de polos
    m=(imag(Td.polos)-0)./(real(Td.polos)-0);%pendiente de la recta y2-y1 / x2 -x1
    Td.y1=@(x) m(1)*x;
    Td.y2=@(x) m(2)*x;
    Td.theta=acos(Td.zeta);%angulo entre damping ratio y eje negativo;
end

function limites_graficas(polos_deseado,y1,y2)
    %Grafica de la asintota vertical asociada al tiempo de asentamiento,
    %izq cumple derecha no
    hold on
    plot([real(polos_deseado(1)) real(polos_deseado(1))],[5 -5],'r--')
    %Grafica del punto donde se ubican los polos a las condiciones
    %establecidas de Tiempo de asentamiento y overshoot
    hold on
    plot([real(polos_deseado)],[imag(polos_deseado)],'b^')
    %Graficas de las asintotas verticales asociadas al angulo con respecto al eje real 
    %del factor de calidad zeta, superar dicha vertical, puede producir una
    %sobrelongacion mayor a la establecida en design
    hold on
    fplot(y1,[-4,0],'k:')
    hold on
    fplot(y2,[-4,0],'k:')
    %mostrar en grafica la asintota vertical que delimita la seleccion del
    %polo para el tiempo de asentamiento
    text(real(polos_deseado(1))+0.5,-3,strcat('p=',string(real(polos_deseado(1)))))
end