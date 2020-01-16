clear;
L = 1; %longueur
R = 0.05; %rayon
rho = 1.225;
qc = -2; %??
p = 100000; %bar ?? Pa
c = 340;

S = pi*R*R;
T = 2*L/c;
deltaT = T/128;
Zc = c*rho/S;

percent = 0.2; %for the choice of b
k = 1;%??
nbIte = 5;

%%
t=deltaT;
F=[1.8,2.6]; %??,
Q=[2.5,3.5]; %??

b = bChoice(percent, T);
a = aChoice(T, b, 1000);
    
for i=1:nbIte
    t = t + deltaT;
    
    %equation 1
    qh1 = qh(t, Q, F, Zc, T, b, a, deltaT);

    %equations 10-11
    if(qh1 < qc) 
        q = qh1;
        f = 0;
    else
        polynome = [-Zc*k -1+Zc*k*qc+p*k*Zc qh1-Zc*k*qc*p];
        q = roots(polynome);
        q = q(1); %lire la suite de l article pour voir lequel des deux prendre
        f = F1(q, k , p, qc);
    end
    F(2+i) = f;
    Q(2+i) = q;
    
end 

function out = F1(q, k , p, qc)
    out =  k.*(p-q).*(q-qc);
end