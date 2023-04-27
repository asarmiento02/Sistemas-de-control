% Práctica 3

% Actividad 1
%Aplique el criterio de Routh-Hurwitz, presente los arreglos y determine si cada 
% una de las ecuaciones características presentadas representan un sistema estable
% o inestable.
disp('a) s^4 + 10s^3 + 35s^2 + 50s + 24 = 0')
a=[1 10 35 50 24];
routh(a)
disp('b) s^4 + 4s^3 + 7s^2 + 22s + 24 = 0')
a=[1 4 -7 -21 24]; 
routh(a)
format longEng
disp('c) s^4 + 5s^2 + 20s + 24 = 0')
a=[1 0 5 20 24];
routh(a)
disp('d) s^6 + 10s^5 + 36s^4 + 60s^3 + 59s^2 + 50s + 24 = 0')
a=[1 10 36 60 59 50 24];
routh(a)
%% Actividad 2
disp('Actividad 2')
syms K b s h;
G1=K*b/(s+1);
T=G1/(1+G1*h);
T=simplify(T)%Funcion de transferencia en lazo cerrado
ST_b=simplify(diff(T,b)*b/T)%Derivada parcial con respecto a b
ST_h=simplify(diff(T,h)*h/T)%Derivada parcial con respecto a h

%Graficas
figure(1)
Sb1=sb(ST_b,[K b h],[2 4 0.5]);%sensibilidad de b ante K=2
hold on
Sb2=sb(ST_b,[K b h],[0.5 4 0.5]);%sensibilidad de b ante K=0.5
legend('sensibilidad b K=2','Sensibilidad b K=0.5')
title('Sensibilidad ante la variacion de b')
figure(2)
Sh1=sb(ST_h,[K b h],[2 4 0.5]);%sensibilidad de h ante K=2
hold on
Sh2=sb(ST_h,[K b h],[0.5 4 0.5]);%sensibilidad de h ante K=0.5
legend('Sensibilidad h K=2','Sensibilidad h K=0.5')
title('Sensibilidad ante la variacion de h')
hold off
Sensibilidad=[Sb1,Sb2,Sh1,Sh2];
disp('  Sb1,      Sb2,     Sh1,    Sh2')
pretty(Sensibilidad)
%% Para obtener una comparativa entre b y h
figure(3) %Se grafican la sensibilidad de b y h con K=2
bode(sym2tf(Sb1))
hold on
bode(sym2tf(Sh1))
legend('Sensibilidad b K=2','Sensibilidad h K=2')
title('Comparacion de Sensibilidad de b y h ante K=2');
%
figure(4)%Se grafican la sensibilidad de b y h con K=0.5
bode(sym2tf(Sb2))
hold on
bode(sym2tf(Sh2))
legend('Sensibilidad b K=0.5','Sensibilidad h K=0.5')
title('Comparacion de Sensibilidad de b y h ante K=0.5');
hold off
%% Actividad 3
disp('Actividad 3')
%Para la siguiente función de transferencia, determine las constantes del error 
% y el tipo de sistema. Emplee la función errorzp codificada en MATLAB. Interprete
% el resultado.
k=10;
p=[0 -1 -2 -5];
z=[-4];
errorzp(z,p,k)%%La funcion solicita 3 parametros, los zeros, los polos, y la ganancia proporcional

%% Actividad 4
disp('Actividad 4')
T=tf(10,[1 14 50]);
T=feedback(T,1);
errortf(10,[1 14 60])%A diferencia de la funcion anterior, solicita es la funcion de transferencia
%% Adicional actividad 3 y 4 calculo teorico de los errores en estado estacionario
disp('Adicional actividad 3 y 4')
syms s
Ta.Transfer_function=[tf2sym(tf([10 40],[1,8,17,10,0])) tf2sym(feedback(tf(10,[1 14 50]),1))];
b0=1;
Ta.Kp=limit(Ta.Transfer_function,s,0);%Calcula el limite de G(s) cuando tiende a 0
Ta.Kv=limit(s*Ta.Transfer_function,s,0);%Calcula el limite de s*G(s) cuando tiende a 0
Ta.Ka=limit(s^2*Ta.Transfer_function,s,0);%Calcula el limite de s^2*G(s) cuando tiende a 0

for k=1:2
    if isnan(Ta.Kp(k))
        Ta.Kp(k)=inf;
    end
    if isnan(Ta.Kv(k))
        Ta.Kv(k)=inf;
    end
    if isnan(Ta.Ka(k))
        Ta.Ka(k)=inf;
    end
end
%Valores en estado estacionario, dados las constantes de error
% Ta.ess_escalon=b0./(1+Ta.Kp);
% Ta.ess_rampa=b0./Ta.Kv;
% Ta.ess_parabolica=factorial(2)*b0./Ta.Ka;

% Esto es equivalente a calcular el limite de s*E(s) siendo
% E(s)=R(s)/(1+G(s)), siendo R(s) la entrada escalon rampa o parabolica
% [1/s 1/s^2 1/s^3] respectivamente
Ta.ess_escalon=vpa(limit(s*1/s.*1./(1+Ta.Transfer_function),s,0),4);
Ta.ess_rampa=vpa(limit(s*1/s^2.*1./(1+Ta.Transfer_function),s,0),4);
Ta.ess_parabolica=vpa(limit(s*1/s^3.*1./(1+Ta.Transfer_function),s,0),4);
%El valor NaN es equivalente a un infinito
for k=1:2 
    fprintf('Funcion de transferencia de actividad %d\n',k+2); 
    disp('Error Constants:')
    disp('      Kp    Kv    Ka  ')
    disp(vpa([Ta.Kp(k),Ta.Kv(k),Ta.Ka(k)],4))
    disp('Steady-state Errors:')
    disp('        Step    Ramp   Parabolic')
    disp(vpa([Ta.ess_escalon(k), Ta.ess_rampa(k),Ta.ess_parabolica(k)],4))
end
