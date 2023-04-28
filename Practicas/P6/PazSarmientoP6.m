%COMPENSADOR EN ADELANTO
G=tf(1,[1,15,50,0]);
% EssRamp=0.1=>EssRamp=50/Gc => Gc=50/0.1
Gc_proporcional=50/0.1
Gsys=G*Gc_proporcional
% Wgm la frecuencia en radianes del gain margin
% Wpm la frecuencia en radianes del phase margin 
[Gain_margin,Phase_margin,Wgm,Wpm]=margin(Gsys)
                % Angulo de adelanto que se quiere obtener vs el que ya se tiene
                % Nota, para este tipo de controlador de adelanto, solo sirve para un valor
                % maximo de 55º de adelanto, para otros debe usarse en conjunto
    % El adelanto que se desea es de 55º y ya se tienen 11.4304º 
        % Paso 1, seleccion del angulo en adelanto
angulo_deseado_grados_adelanto=55
%angulo_deseado_grados_adelanto=input('Ingrese el adelanto requerido en grados para el compensador=º')
        % Paso 2, calculo de Phi
Phi_m=deg2rad(angulo_deseado_grados_adelanto-Phase_margin) %Adelanto de fase en radianes
% La formula de a proviene de sin(Phi_m)=(a-1)/(a+1)
        %Paso 3, Calculo de constante a y alpha
a=(1+sin(Phi_m))/(1-sin(Phi_m))%calculo de la constante a y a=1/alpha
    alpha=1/a
% Bode del sistema no compensado
figure(1)
hold off
margin(Gsys)

%% Paso 4, Obtencion de wm (frecuencia donde se incrementara el angulo)
figure(2)
[mag,phase, w]=bode(Gsys);  %Obtencion de las magnitudes de bode
w2=linspace(0.5,15,10000);  %Valores de x (frecuencia), para recta
mag_save(1,:)=mag(:,1,:);
% Calculo del valor de incremento de la ganancia del controlador alpha
Gananancia_de_alpha=-10*log10(a)*ones(length(w2), 1); % Seria equivalente a -10*log10(1/alpha)
disp('Ganancia de alpha')
Gananancia_de_alpha(1)
semilogx(w,20*log10(mag_save), w2,Gananancia_de_alpha), grid
%semilogx(frecuencia,magnitudes de Gsys(Nocompensado),frecuencia,);
xlabel('Frequency (rad/s)'), ylabel('Magnitude (dB)')
%Visto en la figura 2 el valor de wm a utilizar
wm=8.73; %Este valor debe cambiar cada vez que se modifique el angulo maximo deseado ya que eso modifica alpha y por ende su ganancia
% wm=input('Ingrese el valor de frecuencia wm en rad/seg que observa en la grafica 2=')
%% Calculo del controlador
tau=1/(wm*sqrt(a)) %Constante para el calculo del polo y el cero del controlador
disp('      Presentacion del design del controlador en adelanto final');
Gc_adelanto=tf([a*tau 1],[tau 1])
p=pole(Gc_adelanto)
z=zero(Gc_adelanto)
% MISMAS ECUACIONES PLANTEADAS DE OTRA MANERA PARA EL CONTROLADOR
% Tau=1/(wm*sqrt(alpha))
% Gc_adelanto=tf([Tau 1],[alpha*Tau 1])
% MISMAS ECUACIONES PLANTEADAS DE OTRA MANERA PARA EL CONTROLADOR
% p=wm*sqrt(a)
% z=p/a
% Gc_a=tf([1 z],[1 p])*a % Nota, es casi igual, falta multiplicar por a en
% la ecuacion dada para la practica, representa la atenuacion 1/a=1/alpha
% paso 8
%% Presentacion del funcionamiento del controlador compensado en adelanto
% El valor de Gc_proporcional Kelevacion, puede ser modificado, pero debido
% a que se opto por seguir cumpliendo el requerimiento del error ante
% entrada tipo rampa, este se debe mantener igual a 500 y 500*a si se
% utiliza la ecuacion del documento
Gsys_adelanto=Gc_proporcional*Gc_adelanto*G
T_adelanto=feedback(Gsys_adelanto,1)
figure(1)
hold on
margin(Gsys_adelanto)
legend
figure(6)
bode(Gc_proporcional*Gc_adelanto)
title('Bode del controlador del compensador en adelanto')
%% Step response
figure(3)
step(T_adelanto)
[kv_adelanto,EssRampa_adelanto]=error_rampa(Gsys_adelanto.Numerator{1,1},Gsys_adelanto.Denominator{1,1})
title('Step Response ante el uso del controlador en adelanto')
%% Parte c Comparativa de los 3 controladores realizados
% Controladores, simple, retardo y adelanto
simple.sistema={'Gain simple'};
retardo.sistema={'Compensador retardo'};
adelanto.sistema={'Compensador adelanto'};
%Calculo de los 3 controladores para ser obtenido su comportamiento con
%error_rampa error_step y las graficas asociadas al step y rampa del
%sistema ante cada controlador
simple.Gc=91.68;
retardo.Gc=tf([91.68 0.4584],[1 0.0009168]);
adelanto.Gc=Gc_proporcional*Gc_adelanto;    
disp('Controlador simple');
simple.Gc
disp('Compensador retardo');
retardo.Gc
disp('Compensador adelanto');
adelanto.Gc

[simple.Gsys simple.T simple.Kp simple.EssStep simple.Kv simple.EssRamp,simple.OvershootStep,simple.SettlingTime]=comparar(G,simple.Gc);
[retardo.Gsys retardo.T retardo.Kp retardo.EssStep retardo.Kv retardo.EssRamp,retardo.OvershootStep,retardo.SettlingTime]=comparar(G,retardo.Gc);
[adelanto.Gsys adelanto.T adelanto.Kp adelanto.EssStep adelanto.Kv adelanto.EssRamp,adelanto.OvershootStep,adelanto.SettlingTime]=comparar(G,adelanto.Gc);
%% Graficas de step y rampa para los controladores en estudio
figure (4)
hold off;step(simple.T);hold on;step(retardo.T);hold on;step(adelanto.T);
title('Step Simple Retardo Adelanto');
legend('T_simple','T_retardo','T_adelanto')
figure(5)
hold off;step(tf(1,[1 0])*simple.T);hold on;step(tf(1,[1 0])*retardo.T);hold on;step(tf(1,[1 0])*adelanto.T);xlim([0 1.5])
legend('T_simple','T_retardo','T_adelanto')
title('Rampa Simple Retardo Adelanto')
%% Tabla comparativa de los controladores
Partec=[simple retardo adelanto];
Controladores=Partec;
Partec = rmfield(Partec, 'Gc');
Partec = rmfield(Partec, 'Gsys');
Partec = rmfield(Partec, 'T');
%Tabla final de resultados
tabla=struct2table(Partec)

function [Gsys,T,Kp,EssStep,Kv,EssRamp,OvershootStep,SettlingTimeStep]=comparar(G,Gc)
    Gsys=Gc*G; %Calcula la funcion de transferencia de lazo abierto del sistema
    T=feedback(Gsys,1); %Funcion de transferencia de lazo cerrado
    Step_infor=stepinfo(T); %Variable temporal para extraer los datos
    [Kp,EssStep]=error_step(Gsys.Numerator{1,1},Gsys.Denominator{1,1}); % Calculo del error del estado estacionario de la funcion no compensada ante una entrada rampa
    [Kv,EssRamp]=error_rampa(Gsys.Numerator{1,1},Gsys.Denominator{1,1});
    OvershootStep=Step_infor.Overshoot;%Obtiene la informacion del overshoot del sistema
    SettlingTimeStep=Step_infor.SettlingTime; %Obtiene la informacion del tiempo de asentamiento del sistema
end

