syms K b s h
G1=K*b/(s+1)
T=G1/(1+G1*h);
T=simplify(T)%Funcion de transferencia en lazo cerrado
SbT_b=simplify(diff(T,b)*b/T)%Derivada parcial con respecto a b
SbT_h=simplify(diff(T,h)*h/T)%Derivada parcial con respecto a h

SbT_b
omega=0.014
Sb1=subs(SbT_b,[K b h s],[2 4 0.5 i*omega])
Sb2=subs(SbT_b,[K b h s],[0.5 4 0.5 i*omega])

SbT_h
Sh1=subs(SbT_h,[K b h s],[2 4 0.5 j*omega])

Sh2=subs(SbT_h,[K b h s],[0.5 4 0.5 j*omega])

S=vpa(abs([Sb1 Sb2 Sh1 Sh2]),4)
log10(S)*20
%% Complemento actividad 3

syms s
disp('Actividad 3')

T.a=tf([10 40],[1,8,17,10,0]);

T.b=tf2sym(T.a);
[n,d]=numden(tf2sym(T.a));
errortf(sym2poly(n),sym2poly(d))


figure(5)
T.escalon=(T.b*1/s^1);
T.rampa=(T.b*1/s^2);
T.aceleracion=(T.b*1/s^3);

% hold off
% fplot(ilaplace(T.escalon),[0 5])
% hold on
% fplot(ilaplace(T.rampa),[0 5])
% hold on
% fplot(ilaplace(T.aceleracion),[0 5])
% legend('T.escalon','T.rampa','T.aceleracion')
% 
% escalon=(ilaplace(1/s));
% hold on
% fplot(escalon,[0 5])
% rampa=(ilaplace(1/s^2));
% hold on
% fplot(rampa,[0 5])
% aceleracion=(ilaplace(1/s^3));
% hold on
% fplot(aceleracion,[0 5])

% P1.a=matlabFunction(ilaplace(T.escalon));
% P1.b=matlabFunction(escalon)
% P2.a=matlabFunction(ilaplace(T.rampa));
% P2.b=matlabFunction(rampa)
% P3.a=matlabFunction(ilaplace(T.aceleracion));
% P3.b=matlabFunction(aceleracion)
% figure
% fplot(P2.a,[0 5])
% hold on
% fplot(P2.b,[0 5])
% legend
%% Complemento actividad 4
clear T
syms s
disp('Actividad 4')
T.a=tf(10,[1 14 50]);
T.a=feedback(T.a,1);
[n,d]=tfdata(T.a);
errortf(n{1,1},d{1,1})%A diferencia de la funcion anterior, solicita es la funcion de transferencia
T.b=tf2sym(T.a);
figure(5)
T.escalon=(T.b*1/s^1);
T.rampa=(T.b*1/s^2);
T.aceleracion=(T.b*1/s^3);
escalon=(ilaplace(1/s));
rampa=(ilaplace(1/s^2));
aceleracion=(ilaplace(1/s^3));

hold off
fplot(ilaplace(T.escalon),[0 5])
hold on
fplot(ilaplace(T.rampa),[0 5])
hold on
fplot(ilaplace(T.aceleracion),[0 5])

P1=matlabFunction(ilaplace(T.escalon));
P2=matlabFunction(ilaplace(T.rampa));
P3=matlabFunction(ilaplace(T.aceleracion));

%% Complemento 3

syms s
disp('Actividad 3')

T.a=tf([10 40],[1,8,17,10,0]);

T.b=tf2sym(T.a);
[n,d]=numden(tf2sym(T.a));
errortf(sym2poly(n),sym2poly(d))


T.rampa=(s/(1+T.b)*1/s^2);
T.escalon=(T.b*1/s^1);
T.aceleracion=(T.b*1/s^3);
