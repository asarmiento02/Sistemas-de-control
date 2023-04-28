
    %% Es necesario el archivo de errortf y limites_graficas, ya que error tf fue modificado.
%% Funcion de transferencia deseada Td para establecer limites de diseño
%Valores de seleccion de diseño, seleccionados por debajo de las
%condiciones limites de design
Td.Oshoot=0.08; %Porcentaje de sobrelongacion
Td.t_asentamiento=4; %Tiempo de asentamiento
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
y1=@(x) m(1)*x;
y2=@(x) m(2)*x;
Td.theta=acos(Td.zeta);%angulo entre damping ratio y eje negativo;
%% Viendo el root locus del controlador proporcional, se halla el polo que se puede obtener
p_sigma=-2.5;%Se selecciona -2.5 como la parte real del polo ya que es por donde pasa el rootlocus
p_wd=p_sigma*tan(Td.theta)%Parte imaginaria que acompaña al polo real sin sobrepasar la asintota
p_polo=[(p_sigma+p_wd*1i);(p_sigma-p_wd*1i)]
%% Controlador proporcional
G=tf(1,[1 5 6]); %Ganancia del proceso  
sys_P=G; %sistema que se le aplicara rootlocus
figure(1)
subplot(1,2,1)
hold off
rlocus(sys_P) %realiza el lugar de las raices del controlador proporcional
sgrid(Td.zeta,Td.omega_n)%Delimita los valores de diseño
text(p_sigma+0.1,p_wd,'\sigma=-2.5') %Muestra en grafica el valor de diseño del rootlocus
%Aumentar el tamaño de los ejes
xlim([-5 5])
ylim([-5 5])
%Grafica los polos de diseño, asi como los polos seleccionados, y tambien
%la asintota vertical que delimita para no sobrepasarse en tiempo de
%asentamiento, y las diagonales que delimitan las de 
limites_graficas(Td.polos,p_polo,y1,y2) 
[Kp,poles]=rlocfind(sys_P,p_polo(1))%Halla el polo mas cercano a p_polo(1)
% Se almacena la ganancia Kp necesaria para establecer el polo
Gc_P=Kp %muestra el controlador
T_P=feedback(Gc_P*G,1) %la nueva funcion de transferencia en lazo cerrado producto del controlador
subplot(1,2,2)
step(T_P)
%% Controlador integral
G=tf(1,[1 5 6]);
Gc_I=tf(1,[1 0]);% Controlador integral 1/s
sys_I=Gc_I*G;
figure(2)
subplot(1,2,1)
rlocus(sys_I)
sgrid(Td.zeta,Td.omega_n)
xlim([-5 0])
ylim([-5 5])
limites_graficas(Td.polos,Td.polos,y1,y2) 
[K_I,poles]=rlocfind(sys_I)
%a diferencia del proporcional, aqui se selecciona segun los limites
%graficados y el cursor mostrado en la grafica, obteniendo la ganancia del
%controlador integral
Gc_I=K_I*Gc_I
T_I=feedback(Gc_I*G,1)
subplot(1,2,2)
step(T_I)
%% Controlador proporcional-integral
G=tf(1,[1 5 6]);
Gc_PI=tf([1 1],[1 0]);%Controlador proporcional integral (s+1)/s
sys_PI=Gc_PI*G;
figure(3)
subplot(1,2,1)
rlocus(sys_PI)
sgrid(Td.zeta,Td.omega_n)
xlim([-3 0])
ylim([-3 3])
limites_graficas(Td.polos,Td.polos,y1,y2) %resto del script
[K_PI,poles]=rlocfind(sys_PI)
Gc_PI=K_PI*Gc_PI
T_PI=feedback(Gc_PI*G,1)
subplot(1,2,2)
step(T_PI)

%% Comparativa de controladores
figure(4)
hold off
step(T_P)
Gproces=G*Gc_P;
display('     Error proporcional')
ess(1,1)=errortf(Gproces.Numerator{1,1},Gproces.Denominator{1,1});
hold on
step(T_I)
Gproces=G*Gc_I;
display('     Error integral')
ess(2,1)=errortf(Gproces.Numerator{1,1},Gproces.Denominator{1,1});
hold on
step(T_PI)
Gproces=G*Gc_PI;
display('     Error proporcional-integral')
ess(3,1)=errortf(Gproces.Numerator{1,1},Gproces.Denominator{1,1});
hold on
step(Td.transfer_function,'k-.')
legend('Tp','Ti','Tpi','T.design')
% Muestra en la grafica los errores en estado estacionario
text(7,1.2-ess(1),strcat('ess_p=',string(ess(1))));
text(7,1.1,strcat('ess_i=',string(ess(2))));
text(7,1.05,strcat('ess_{pi}=',string(ess(3))));
