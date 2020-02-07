function [Q,F]=main2(zeta, gamma, L, F, Q, percent)
%     L = 0.3; %length
%     zeta = 0.8;%ou 0.4
%     gamma = 0.8;
    r = -0.98;
%     F=[1, 1]; %??,
%     Q=[0.1,0.11]; %??
%     percent = 0.3; %commentaire

    nbIter = 50000;

    c = 340;
    T = 2*L/c;
    deltaT = T/128;
    Zc = 1;
    eps = 0.000000001;
    %%
    b = bChoice(percent, T);
    a = aChoice(T, b, 1000);
    t=deltaT;

    for i=1:nbIter
        t = t +deltaT;
        realRoot = [];

        %equation 10 dirac en t-T
        if(i-T/deltaT >= 0)
            qh = r*(Q(floor(i-T/deltaT+1)) + Zc*F(floor(i-T/deltaT+1)));%%%%%
        else
            qh = 0;
        end
%        qh = qh1(t, Q, F, Zc, T, b, a, deltaT);

        %equations 1 11
        %q<gamma
        a1 = -zeta^2;
        b1 = zeta^2*(gamma - 2*(1-gamma)) - 1/Zc^2;
        c1 = 2*1/(Zc^2)*qh + zeta^2*(gamma*2*(1-gamma) - (1-gamma)^2);
        d1 = zeta^2*(1-gamma)^2*gamma - 1/Zc^2*qh^2;
        root = roots([a1 b1 c1 d1]);%%%%%%%%%
        %keep the real root in the right interval
        for k = 1:length(root)
            if(abs(imag(root(k)))<eps & real(root(k))<gamma)
                realRoot(end+1) = real(root(k));
            end
        end
        realRoot;%%%%%

        %q>gamma
        a2 = zeta^2;
        b2 = zeta^2*(-gamma + 2*(1-gamma)) - 1/Zc^2;
        c2 = 2*1/(Zc^2)*qh + zeta^2*(-gamma*2*(1-gamma) + (1-gamma)^2);
        d2 = -zeta^2*(1-gamma)^2*gamma - 1/Zc^2*qh^2;
        root = roots([a2 b2 c2 d2]);%%%%%%%%%%%%
        for k = 1:length(root)
            if(abs(imag(root(k)))<eps & real(root(k))>=gamma)
                realRoot(end+1) =  real(root(k));
            end
        end
        realRoot;%%%%%%%%%%%%%%%


        %enleve en dessous de gamma-1
        k=1;
        while k <= length(realRoot)
            if(realRoot(k)<=gamma-1)
                realRoot([k]) = [];
                k=k-1;
            end
            k =k+1;
        end
        realRoot;%%%%%%%%%%%

        %enleve si pas sol du l'eq pas au carre
        k =1;
        while k <= length(realRoot)
            q = realRoot(k);
            res = zeta.*(1-gamma+q).*sqrt(abs(gamma-q)).*sign(gamma - q)-realRoot(k)+qh;
            if(sqrt(eps) < res | -sqrt(eps) > res)
                realRoot([k]) = [];
                k=k-1;
            end
            k =k+1;
        end
        realRoot;%%%%%%%%%%%%%%%%%%%

        %ajout point dans partie statique
        if(qh<gamma-1)
            realRoot(end+1) = qh;
        end
        realRoot;%%%%%%%%%%%%%%%%%%%%
        %lequel des 3 points dintersection il faut garder
        if(length(realRoot) > 1)
            qa = linspace(-20,20,500);
            q2 = linspace(-20,gamma-1,500);
            d4 = zeta.*(1-gamma+qa).*sqrt(abs(gamma-qa)).*sign(gamma - qa);
            %figure
            %plot(qa,d4,qa,qa-qh, q2,q2*0)

            realRoot = sort(realRoot);
            if(length(realRoot)==3)
                realRoot([2]) = []; %on enleve celui du milieu
            end
            %on garde le plus proche du point d avant pour garder phenomene 
            if(abs(realRoot(1)-Q(i+1))<abs(realRoot(2)-Q(i+1)))
                q = realRoot(1);
            else
                q = realRoot(2);
            end
        else
            q=realRoot(1);
        end
        q;%%%%%%%%%%%%%%%

        f = zeta.*(1-gamma+q).*sqrt(abs(gamma-q)).*sign(gamma - q);
        F(2+i) = f;
        Q(2+i) = q;

    %     if(i>1933)
    %         if(q==qh)
    %             i
    %         end
    %         qa = linspace(-20,20,500);
    %         q2 = linspace(-20,gamma-1,500);
    %         d4 = zeta.*(1-gamma+qa).*sqrt(abs(gamma-qa)).*sign(gamma - qa);
    %         figure
    %         plot(qa,d4,qa,qa-qh, q2,q2*0)
    %     end
    end

    qa = linspace(-20,20,500);
    q2 = linspace(-20,gamma-1,500);
    d4 = zeta.*(1-gamma+qa).*sqrt(abs(gamma-qa)).*sign(gamma - qa);
    %figure
    %plot(qa,d4,qa,qa-qh, q2,q2*0)
end
