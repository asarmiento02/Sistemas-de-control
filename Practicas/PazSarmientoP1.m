%% PROGRAMA BASE
%Lazo 1
clear
clc
%Se simplifica G1 y G2 y se asocia con H1
G_1=tf(1,[1 1]);
G_2=tf([1 0],[1 0 2]);
H_1=tf([4 2],[1 2 1]);
G_12=series(G_1,G_2); %Suma de G1 y G2
L_1=feedback(G_12,H_1);

%Lazo 2
%Se asocia G3 con H2
G_3=tf(1,[1 0 0]);
H_2=50; %Ganancia Proporcional como retroalimentación de H2
L_2=feedback(G_3,-H_2);

%Combinando Lazos 1 y 2
L_12=series(L_1,L_2);

%Lazo 3
%Se asocia el Lazo formado por Lazo 1 y Lazo 2 con H3
H_3=tf([1 0 2],[1 0 0 14]);
L_3=feedback(L_12,H_3);

%Se simplifica asociando la ganancia proporcional (4) con Lazo 3

G=series(4,L_3);


subplot(1,2,1)
pzmap(G)
subplot(1,2,2)
step(G)
xlabel('t Seg')
ylabel('Salida')

disp('Función de Transferencia')
G
disp('')
Z=zero(G);
disp('Ceros del Sistema:')
disp(Z)
disp('')
P=pole(G);
disp('Polos del Sistema:')
disp(P)

%% COMPROBACION - Desarrollo teorico
syms s
g_1=1/(s+1);
g_2=s/(s^2+2);
H_1=(4*s+2)/(s^2+2*s+1);
g_3=1/s^2;
H_2=-50;
H_3=(s^2+2)/(s^3+14);

l_1=g_1*g_2/(1+H_1*g_1*g_2);
l_2=g_3/(1-50*g_3);
l2_3=l_1*l_2/(1+H_3*l_1*l_2);
G2=simplify(l2_3*4);
pretty(G2);
[num,den]=numden(G2);
num=sym2poly(num);
den=sym2poly(den);
G2=tf(num,den);
step(G2);
xlabel('t Seg')
ylabel('Salida')
