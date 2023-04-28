%%Sección 1, calculos de variables de estado
% clear
% syms s U Y
% ec=Y/U==2.5/(s*(0.5*s+1));
% ec=isolate(ec,U);
% ec=ec*5
%%
% Simulación de lazo abierto
clc
clear
gp=tf([2.5],[0.5 1 0])
gpc=feedback(gp,tf([1]))
figure(1)
% subplot(2,1,1)
stepplot(gp)
% subplot(2,1,2)
% rlocus(gp)
% stepplot(gpc)
%%
% lazo cerrado
clc
clear
gp=tf([2.5],[0.5 1 0])
[A,B,C,D]=tf2ss([2.5],[0.5 1 0])
gpc=feedback(gp,tf([1]))
figure(1)
stepplot(gpc)

%%
% Obtención de la función de transferencia dada una ecuación de control
% U=-K+Ref
gp=tf([2.5],[0.5 1 0])
A=[0 1 ;0 -2];
B=[0;5];
C=[1 0];
D=0;
syms s k1 k2;
K=[k1 k2];
I=eye(2);
Gpc=(C*(s*I-(A-B*K))^(-1)*B);
[num,den]=numden(Gpc)
%La ecuacion del denominador esta dada por 
den1=det(s*I-(A-B*K))
%Polinomio de polos del sistema
    polos=(s + 1)*(s + 5);
    expand(polos)
    k2=solve(6==(2 + 5*k2))
    k1=solve(5==5*k1)
%calculos paso a paso
% % % B*K
% % % A-B*K
% % % s*I
% % % s*I-(A-B*K)

    k2=4/5
    k1=1
    K=[k1 k2]
    Gpc=(C*(s*I-(A-B*K))^(-1)*B)
    Gpc_tf=tf([5],[1 6 5])
%Graficando
    rlocus(Gpc_tf)
    figure(1);
%     subplot(2,1,1);
%     stepplot(Gpc_tf)
%     grid
%     subplot(2,1,2);
    rlocus(Gpc_tf)
    grid
% [num,den]=tfdata(gpc,'v') muestra los datos de la funcion de
% transferencia en numerador y denomidador, la v es para que muestre los
% resultados en forma de vector


%%
%Controlador mediante metodo directo
syms wn q s
gp=2.5/(s*(0.5*s+1))
qs=wn^2/(s^2+2*q*wn*s+wn^2)
gc=1/gp*qs/(1-qs)%Aplica el método directo con la ecuación de segundo grado denominada seg
gc=simplify(gc)

%%
%%Control Pid
syms k_p k_i k_d s
gp=2.5/(s*(0.5*s+1))
pid= k_p+k_i/s+k_d*s
G=gp*pid/(1+pid*gp)
Gpc=simplify(G)
% syms kp ki kd s
% gp=2.5/(s*(0.5*s+1))
% pid= kp+ki/s+kd*s
% G=gp*pid/(1+pid*gp)
% Gpc=simplify(G)

%obtencion de los parametros kd kp ki
k_d=solve((2+5*k_d)==(-p_2-p_3-p_1),k_d)
k_p=solve(5*k_p==(p_1*p_2+p_1*p_3+p_2*p_3 ),k_p)
ki=solve(5*k_i==-p_1*p_2*p_3,k_i)
p_1=-1;
p_2=-2;
p_3=-5;
k_d =- p_1/5 - p_2/5 - p_3/5 - 2/5
k_p =(p_1*p_2)/5 + (p_1*p_3)/5 + (p_2*p_3)/5
ki =-(p_1*p_2*p_3)/5

%% Estabilizacion del pid
a=2.5 
Tr=0.6
k_p=1/(a*Tr)
k_i=K_p/(2*Tr)
k_d=K_p*0.5*Tr
