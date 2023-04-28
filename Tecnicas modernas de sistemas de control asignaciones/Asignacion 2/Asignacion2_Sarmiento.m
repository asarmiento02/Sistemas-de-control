%% Asignación de polos
syms k_p k_i k_d s;
gm=2.5/((0.5*s+1))
g2=1/(0.5*s+1)
gp=2.5/((0.5*s+1)^2);
pid=k_p+k_i/s+k_d*s;
Gp=tf([0,0,10],[1,4,4]);
G=gp*pid/(1+pid*gp);

G=simplify(expand(G))

[num,den]=numden(G);
syms p_1 p_2 p_3
den==(s-p_1)*(s-p_2)*(s-p_3);
expand(ans)

%%
%obtencion de los parametros kd kp ki

k_d=solve((10*k_d+4)==(-p_2-p_3-p_1),k_d);
k_p=solve(4+10*k_p==(p_1*p_2+p_1*p_3+p_2*p_3 ),k_p);
k_i=solve(10*k_i==-p_1*p_2*p_3,k_i);
%% Obtencion de los polos del sistema
p_1=-2;
p_2=-1;
p_3=-5;
k_d =- p_1/10 - p_2/10 - p_3/10 - 2/5
k_p =(p_1*p_2)/10 + (p_1*p_3)/10 + (p_2*p_3)/10 - 2/5
k_i =-(p_1*p_2*p_3)/10

%% Zimmer y Nichols PID
K=2.5;tau=0.5;L=0.5;theta=L;
Kp=1.2*tau/(K*L)
Ki=(1.2*tau/(K*L))/(2*L)
Kd=1.2*tau/(K*L)*0.5*L
%% Cohen Coon control PID
K=2.5;tau=0.5;L=0.5;theta=L;
Kp=(1.35+0.25*theta/tau)*tau/(K*theta)
Ki=((1.35+0.25*theta/tau)*tau/(K*theta))/(theta*((1.35+0.25*theta/tau))/((0.54+0.33*theta/tau) ))
Kd=Kp*(0.5*theta)/((1.35+0.25*theta/tau) )
%% Dual loop ajuste
k1=4.5;k2=0.44;k3=8;
pic=1.003;
oshoot=(pic-1)/(1-0);
t_p=0.559;
xi=sqrt((log(oshoot))^2/(pi()^2+(log(oshoot))^2 ));
wn=pi()/(t_p*sqrt(1-xi^2));
A1=2*xi/wn 
A2=1/(wn^2)